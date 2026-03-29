# disputes — spec

## What this feature does
Formal dispute process when a delivery goes wrong.
Escrow frozen immediately on dispute open.
Admin reviews via Supabase Studio (no custom admin UI in V1).
Resolution results in full refund, partial refund, or ruling for traveler.

## Screens
- `DisputeScreen` — reason selection, written description, evidence photo upload, submission

## State
- `DisputeNotifier (StateNotifier<DisputeState>)` — form state, submission, status polling

## Data
- Models: `DisputeModel`
- Repository: `DisputeRepository` → `SupabaseDisputeRepository`
- Table: `disputes` — see docs/schema.md

## Dispute triggers — three ways a dispute opens
```
1. Recipient taps "No, there's an issue" on DeliveryConfirmScreen
   → immediately opens DisputeScreen

2. Either party taps "فتح نزاع / Open dispute" on ActiveBookingScreen
   Available 72h after expected delivery date with no confirmation
   → opens DisputeScreen

3. System auto-flag (no user action):
   24h after expected landing with no delivery confirmation from traveler
   → booking.status stays in_transit
   → admin alert created in Supabase (Slack webhook or email)
   → sender shown: "تم تصعيد هذه الحالة لفريق لوقا"
   → this is NOT a formal dispute — admin intervenes directly
```

## Dispute reasons
```dart
enum DisputeReason {
  itemDamaged,          // 'الغرض تالف / Item damaged'
  wrongItem,            // 'الغرض مختلف / Wrong item'
  notReceived,          // 'لم أستلم الغرض / Item not received'
  travelerDisappeared,  // 'المسافر اختفى / Traveler disappeared'
  other,                // 'مشكلة أخرى / Other issue'
}
```

## DisputeScreen layout
```
Header: "فتح نزاع / Open dispute" — booking summary shown at top (item + traveler)

Reason selection (radio buttons, one required):
  ○ الغرض تالف — Item damaged
  ○ الغرض مختلف عن الوصف — Wrong item delivered
  ○ لم أستلم الغرض — Item not received
  ○ المسافر اختفى — Traveler not responding
  ○ مشكلة أخرى — Other issue

Description field (textarea, required, 500 chars max):
  "اشرح ما حدث / Describe what happened"

Evidence photos (optional, up to 5):
  Gallery OR camera allowed here (unlike proof photos, evidence can be pre-existing)
  Shows original item photos from shipment alongside for comparison

Notification text:
  "سيتم تجميد الدفع حتى يتم حل النزاع / Payment will be frozen until resolved"
  "سنراجع نزاعك خلال 24 ساعة / We'll review within 24 hours"

Submit button: "أرسل النزاع / Submit dispute"
  → Confirmation dialog: "هل أنت متأكد؟ سيتم إيقاف الدفع فوراً."
  → On confirm: call DisputeRepository.openDispute(...)
  → booking.status → disputed
  → escrow FROZEN — neither side can release or cancel
  → both parties notified via FCM
```

## Resolution rules (admin applies in Supabase Studio)
```
itemDamaged (pickup photo ok, delivery photo shows damage):
  → Full refund to sender via Stripe. Traveler earns $0.
  → Flag traveler account: disputes_count++

wrongItem (shipment photos vs delivery photos mismatch):
  → Admin reviews photo evidence
  → Full refund if clear mismatch; split if ambiguous

notReceived + delivery photo exists and clear:
  → Sender claim rejected, traveler paid
  → Advise sender to look again / check with building

notReceived + NO delivery photo:
  → Full refund to sender from protection fund
  → Traveler account flagged, earnings withheld

travelerDisappeared (pickup photo exists, 48h+ no response):
  → Full refund from protection fund
  → Traveler account suspended pending review
  → Option to file report (Persona ID on file)
```

## Business rules
- Escrow frozen immediately on dispute.open — no releases permitted while status = 'disputed'
- Both parties notified via FCM when dispute opened
- Admin reviews via Supabase Studio — resolution sets disputes.status + disputes.resolution
- Resolution target: 24h review, 48h payout after resolution
- 48h appeal window after resolution — either party can escalate
- Refunds paid from protection fund (ring-fenced in Mercury Bank)
- NOT from Luga operating account

## Acceptance criteria
- [ ] Escrow frozen immediately on dispute submission (verify booking status in DB)
- [ ] Both parties receive FCM notification when dispute opened
- [ ] Booking status shows "Under review" UI — no release or cancel buttons visible
- [ ] Admin can see dispute in Supabase Studio with all evidence
- [ ] Appeal window: "Submit appeal" available for 48h after resolution

## What NOT to build here
- Protection fund management → backend only, no UI in V1
- Admin dashboard → Supabase Studio in V1 (custom admin UI in V2)
- Escrow release (after resolution) → Edge Function release-escrow
