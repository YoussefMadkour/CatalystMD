# offers — spec

## What this feature does
Structured price negotiation between traveler and sender.
Three paths to booking: instant (preset prices), negotiation (3 rounds), fixed price (no negotiation).
Culminates in BookingSummaryScreen before payment.

## Screens
- `MakeOfferScreen` — sender sends first offer: item summary, suggested range bar, amount input, real-time fee breakdown, optional message, courier add-on toggle
- `OfferThreadScreen` — full negotiation timeline, round indicator, live countdown timer, accept/counter/decline actions
- `BookingSummaryScreen` — final review before payment: full price breakdown with tooltips, guarantee badge, "Before you proceed" trust gate, pay CTA

## Widgets
- `OfferBubble` — single offer in thread: sender bubbles right-aligned (teal), traveler left-aligned (grey). Shows amount + status chip + timestamp.
- `OfferActionBar` — Accept (green) | Counter (blue) | Decline (red ghost) — shown to receiving party only
- `NegotiationRoundIndicator` — "Round 2 of 3" pill. Turns amber on round 3 with "Final round" text.
- `CountdownTimer` — live hh:mm:ss. Red when under 1 hour. Updates every second.
- `PriceRangeBar` — visual min–mid–max bar with filled teal range. Shows "Typical: $35–55"
- `PriceBreakdownCard` — real-time: agreed → sender pays / traveler earns / Luga revenue. Updates as user types.

## State
- `OfferNotifier (StateNotifier<OfferState>)` — send, counter, accept, decline
- `offerThreadProvider (StreamProvider<List<OfferModel>>)` — real-time thread via Supabase Realtime
- `bookingSummaryProvider (FutureProvider<DealBreakdown>)` — computed breakdown for summary screen

## Data
- Models: `OfferModel`, `DealBreakdown`, `PriceRange`
- Repository: `OfferRepository` → `SupabaseOfferRepository`
- Utils: `PriceCalculator.calculate()`, `PriceCalculator.suggestedRange()`, `PriceCalculator.floorFor()`
- Table: `offers` — see docs/schema.md

## Three paths to booking
```
Path 1 — Instant booking (traveler has preset price for item category):
  Sender sees "Book at $50" on TravelerCard in discovery feed.
  Tap → skip MakeOfferScreen entirely.
  Go directly to BookingSummaryScreen with amount = preset price.

Path 2 — Negotiation (no preset price OR sender wants different price):
  Tap "Make offer" → MakeOfferScreen → OfferThreadScreen.
  Up to 3 rounds. On acceptance → BookingSummaryScreen.

Path 3 — Fixed price trip (traveler set is_fixed_price = true):
  No negotiation possible at all.
  "Book now at $X" button only. No "Make offer" option.
  → BookingSummaryScreen directly.
```

## Offer state machine
```
Sender sends offer → status: pending, round_num: 1
  ├─ Traveler ACCEPTS → status: accepted
  │    → Both notified via FCM
  │    → Navigate to BookingSummaryScreen
  │
  ├─ Traveler COUNTERS → status: countered
  │    → New offer row created with round_num: 2, from_role: 'traveler'
  │    → Sender notified via FCM
  │    → Sender can accept / counter (round 3) / decline
  │
  ├─ Traveler DECLINES → status: declined
  │    → Thread closed. "Start fresh" button resets to round 1.
  │
  └─ 6 hours pass → status: expired (Supabase cron expire-offers)
       → Both notified via FCM
       → "Start fresh" available to reset to round 1

Round 3 counter → last possible counter.
If round 3 expires/declined → "Start fresh" or abandon.
DB constraint: CHECK (round_num <= 3) — four rounds impossible.
```

## MakeOfferScreen layout
```
Item summary card (read-only): photo + name + weight + declared value
Suggested price range bar: [min]----[●mid]----[max] with "Typical range" label
Large amount input (numeric keyboard, USD)
Real-time PriceBreakdownCard below input:
  Traveler reward:    $XX.XX   (= amount entered)
  Service fee (10%):  $X.XX   (= amount × 0.10)
  ─────────────────────────────
  You pay total:      $XX.XX
  Traveler receives:  $XX.XX  (= amount - commission)
Courier add-on toggle (if traveler offers courier): "+$10 door delivery"
Optional message field (150 chars)
"Send offer of $XX" button — disabled if amount below floor
Floor warning: "Minimum for electronics: $20" shown inline if below floor
Round indicator: "Round 1 of 3 — 2 rounds remaining"
```

## BookingSummaryScreen layout
```
Header: "تم الاتفاق! / Deal agreed!" with green checkmark animation

Two-column summary:
  Item: photo + name + weight + declared value
  Traveler: avatar + name + rating + flight date

Full price breakdown (each row has ? tooltip):
  Delivery reward:     $40.00   ? "What the traveler earns"
  Service fee (10%):   $4.00   ? "Platform fee for escrow + guarantee"
  Courier add-on:      $10.00  ? "Door delivery to your address" (if selected)
  ────────────────────────────
  Total you pay:       $54.00

  Traveler receives:   $36.00  (shown for transparency, not required)

Luga Guarantee badge: shield icon + "محمي بضمان لوقا حتى $1,000"
Tappable → bottom sheet explaining guarantee in plain Arabic/English

Handoff details: meetup preference OR door delivery address field

"Before you proceed" trust section:
  Small illustrated person with shield checkmark
  "Luga connects trusted community members. To protect everyone,
   we hold payment in escrow until delivery is confirmed."

Primary CTA: Apple Pay / Google Pay button (prominent, top)
  → Stripe Payment Sheet with digital wallets primary, card fallback
Secondary fallback: "ادفع ببطاقة / Pay with card" (if digital wallets unavailable)
Back option: "العودة للتفاوض / Back to negotiate" (text link)
```

## Business rules
- Floor prices enforced client AND server: PriceCalculator.floorFor(category)
- round_num > 3 impossible: DB CHECK constraint + client validation
- Offer expiry: 6 hours from creation. Enforced by Supabase cron, not client.
- Client countdown timer is visual only — always re-fetch status from DB on mount
- Both parties notified via FCM on every offer action
- Race condition (both counter simultaneously): last write wins, other party sees "Offer updated" prompt
- Accepted offer: navigate immediately to BookingSummaryScreen with no extra taps

## Acceptance criteria
- [ ] Offer below floor shows specific message with the minimum amount for that category
- [ ] Round counter shows "Round 2 of 3" — never "Round 4"
- [ ] Round 3 shows amber "Final round" warning
- [ ] Countdown timer updates every second — shows red when under 1 hour
- [ ] Expired offer shows "Offer expired" state — not a generic error
- [ ] After 3 expired rounds "Start fresh" resets to round 1
- [ ] Accepted offer navigates to BookingSummaryScreen immediately — no extra taps
- [ ] PriceBreakdownCard updates in real-time as amount is typed
- [ ] Fixed-price trip shows "Book now" only — no "Make offer" button rendered
- [ ] Preset price path skips MakeOfferScreen entirely
- [ ] Apple Pay / Google Pay shown as primary payment option on BookingSummaryScreen

## What NOT to build here
- Stripe payment execution → triggered from here but executed in features/bookings/ Edge Function
- Chat → features/chat/ (linked from OfferThreadScreen header icon)
- Price range calculation → core/utils/price_calculator.dart
- Traveler payout setup → features/onboarding/
