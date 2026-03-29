# bookings — spec

## What this feature does
Full booking lifecycle from escrow creation through delivery confirmation and payout.
The most financially sensitive flows in the app — every state transition is irreversible or guarded.
Status machine is strictly one-directional.

## Screens
- `ActiveBookingScreen` — status timeline, escrow indicator, departure countdown, quick actions
- `PickupConfirmScreen` — traveler confirms item received: live camera photos, condition checklist, item mismatch option
- `InTransitScreen` — item is in the air: flight info, landing ETA, status for both parties
- `HandoffScreen` — coordinate meetup point OR door delivery address, controlled phone reveal
- `DeliveryConfirmScreen` — recipient photos delivery, confirms receipt, triggers escrow release
- `BookingHistoryScreen` — all past bookings: status, amounts, photos, expandable details

## Widgets
- `BookingStatusTimeline` — horizontal steps: Paid ✓ → Collected → In Transit → Delivered
- `EscrowStatusChip` — "Held in escrow: $54.00 🔒" — always visible on active bookings
- `PhotoProofUploader` — camera-only, progress bar, upload to Supabase Storage
- `GuaranteeBadge` — "$1,000 Luga Guarantee active 🛡" with teal background

## State
- `BookingNotifier (StateNotifier<BookingState>)` — status transitions, photo uploads, escrow actions
- `activeBookingProvider (StreamProvider<BookingModel>)` — real-time single booking watch
- `bookingHistoryProvider (FutureProvider<List<BookingModel>>)` — paginated history

## Data
- Models: `BookingModel`, `PhotoProofModel`
- Repository: `BookingRepository` → `SupabaseBookingRepository`
- Services: `StripeService` (payout on release), `FcmService`
- Table: `bookings` — see docs/schema.md

## Status machine — one directional, no skipping
```
awaiting_payment
  ↓ wallet deducted OR Stripe captured (Edge Function: create-booking)
escrow_held
  ↓ traveler uploads pickup photos + confirms condition (PickupConfirmScreen)
pickup_confirmed
  ↓ AviationStack detects departure OR traveler taps "I've departed"
in_transit
  ↓ AviationStack detects landing → push sent to both parties
  [HandoffScreen — coordinate meetup or door delivery]
  ↓ traveler uploads delivery photo (DeliveryConfirmScreen)
delivery_confirmed
  ↓ sender confirms receipt (or auto-release at T+48h)
  ↓ Edge Function release-escrow → Stripe Connect payout to traveler
completed

Side branches (available from most states):
→ cancelled   (cancellation flow with policy-based refund)
→ disputed    (dispute opened — escrow frozen)
→ refunded    (dispute resolved in sender's favour)
```

## Photo proof — critical rules
```dart
// ALWAYS use live camera for proof photos — no gallery
final photo = await ImagePicker().pickImage(
  source: ImageSource.camera,  // NOT ImageSource.gallery
  maxWidth: 1080,
  maxHeight: 1080,
  imageQuality: 75,
);
// Compress further if > 500kb using image_utils.dart
// Upload to Supabase Storage: delivery-photos/{bookingId}/{type}.jpg
// Store URL in bookings.pickup_photos[] or bookings.delivery_photos[]
```

## PickupConfirmScreen
```
Shown to traveler before departure.
Push notification at T-24h: "تذكّر التقاط صور الغرض / Remember to photograph the item"

Screen content:
  Shows sender's original item photos for comparison
  "صوّر الغرض الآن / Photograph the item now" — camera button (live only)
  Minimum: 1 photo. Recommended: 2+ (front + side).

  Condition checklist (all must be checked):
  ☐ الغرض مطابق للوصف / Item matches description
  ☐ الغرض مغلف أو محمي / Item is packaged or protected
  ☐ الوزن يبدو صحيحاً / Weight seems correct

  "الغرض لا يطابق الوصف / Item doesn't match" button:
    → Opens dispute pre-flag
    → Notifies sender immediately
    → Traveler NOT required to carry the item
    → Escrow held pending resolution

  "تأكيد الاستلام / Confirm pickup" button (disabled until photos + checklist):
    → Confirmation dialog: "هل تؤكد استلام الغرض؟ لا يمكن التراجع."
    → On confirm: call BookingRepository.confirmPickup(bookingId, photos)
    → Status: escrow_held → pickup_confirmed
    → Sender notified: "تم استلام غرضك / Your item has been collected"
```

## DeliveryConfirmScreen
```
Triggered after HandoffScreen when traveler uploads delivery photo.

Traveler side:
  "أكّد التسليم / Confirm delivery" — live camera button
  After photo: "في انتظار تأكيد المستلم / Awaiting recipient confirmation"

Recipient/sender side (push notification triggers this):
  Shows traveler's delivery photo (full width, large)
  "هل وصل الغرض بحالة جيدة؟ / Did the item arrive in good condition?"
  [نعم، اطلق الدفع / Yes, release payment] (green)
  [لا، هناك مشكلة / No, there's an issue] (red) → DisputeScreen

  On "Yes, release":
    LugaConfirmationDialog shown:
      "ستُطلق $36.00 للمسافر. هذا القرار لا يمكن التراجع عنه."
      [إلغاء / Cancel] [نعم، اطلق / Yes, release]
    On confirm: BookingRepository.releaseEscrow(bookingId)
    Edge Function release-escrow: update status → delivery_confirmed,
      initiate Stripe Connect payout to traveler
    Both parties get FCM push
    RatingScreen shown to both parties
```

## Auto-release
```
auto_release_at = pickup_confirmed_at + 48 hours
Stored in bookings.auto_release_at

Supabase cron (every hour):
  SELECT * FROM bookings
  WHERE status = 'in_transit'
    AND auto_release_at < NOW()
    AND delivery_confirmed_at IS NULL

FCM push to sender at T-24h: "غرضك سيُسلَّم تلقائياً خلال 24 ساعة / Auto-release in 24h"
FCM push to sender at T-6h:  "غرضك سيُسلَّم تلقائياً خلال 6 ساعات / Auto-release in 6h"
On trigger: same as manual release — full payout to traveler
```

## Cancellation rules
```
Pre-escrow (awaiting_payment) — either party:
  No penalty. Offer thread archived.

Traveler cancels > 48h before departure:
  Full refund to sender wallet. Traveler earns $0.

Traveler cancels < 48h before departure:
  Full refund to sender wallet. Traveler earns $0.
  (Capacity was reserved — traveler bears the cost)

Sender cancels > 48h before departure:
  Refund: sender_total - platform_fee (Luga keeps 10%)

Sender cancels < 48h before departure:
  50% refund to sender wallet.
  50% of agreed price paid to traveler as compensation.

All computed by Edge Function cancel-booking — never inline in Flutter.
```

## HandoffScreen — controlled phone reveal
```
Meetup option (default):
  Traveler: enter meetup location text / share Google Maps link via button
  Location sent as message in chat thread
  Both: coordinate via chat

Door delivery option:
  Sender: delivery address already entered at booking — shown here
  Traveler: "Open in Google Maps" button (deep link)

Phone reveal (door delivery only):
  "مشاركة رقم الهاتف للتوصيل / Share phone for delivery coordination"
  Both sides see each other's phone — one-time controlled reveal
  Logged in bookings.phone_revealed_at
  ONLY available after escrow_held status — never before payment
  Shown in HandoffScreen only — never in chat UI
```

## Business rules
- Status transitions only via Edge Functions — never direct DB update from Flutter
- Every transition logged with timestamp in bookings table
- Pickup photos must exist before pickup_confirmed transition is allowed
- Delivery photos must exist before escrow release button is active
- LugaConfirmationDialog always shown before escrow release — never skip it
- Phone reveal logged with timestamp — only post-escrow, only in HandoffScreen
- BookingRepository.releaseEscrow() is idempotent — safe to call twice

## Acceptance criteria
- [ ] Wallet deducted atomically — no partial deduction possible on network error
- [ ] Escrow chip visible on ActiveBookingScreen at all times during booking lifecycle
- [ ] Pickup photo forces live camera — gallery button not shown
- [ ] Delivery confirmation requires photo — release button disabled without it
- [ ] LugaConfirmationDialog shown before escrow release — irreversibility stated clearly
- [ ] Auto-release fires at exactly T+48h after delivery photo upload
- [ ] Sender push notifications at T-24h and T-6h before auto-release
- [ ] Cancellation refund matches policy based on hours to departure
- [ ] All status transitions logged with timestamp in DB

## What NOT to build here
- Dispute resolution UI → features/disputes/
- Rating flow → features/profile/
- Payout history → features/wallet/
- Stripe Connect Express onboarding → features/onboarding/
