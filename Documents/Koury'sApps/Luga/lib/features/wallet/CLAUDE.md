# wallet — spec

## What this feature does
Traveler earnings dashboard and payout management. All amounts in USD.
Senders pay via Stripe at booking time (Apple Pay / Google Pay / credit card) — no wallet top-up.
Travelers see their earned balance and request bank transfer payouts via Stripe Connect.
This is NOT a sender-facing feature — senders have no balance, they pay per booking.

## Screens
- `WalletScreen` — traveler earnings balance (USD), pending payouts, recent transactions, "Request payout" CTA
- `PayoutSettingsScreen` — Stripe Connect Express setup (WebView), bank account status, payout method
- `WalletHistoryScreen` — full ledger: All | Earnings | Payouts tabs, each entry typed and colored

## Widgets
- `WalletTransactionTile` — single ledger row: type icon, description (AR/EN), signed amount (green credit, red debit), date
- `EarningsCard` — large balance display: "$142.50 Available" + "$36.00 Pending" (in-transit bookings)
- `PayoutStatusChip` — "Processing" | "Completed" | "Failed" with appropriate colors

## State
- `WalletNotifier (StateNotifier<WalletState>)` — balance, payout requests
- `walletLedgerProvider (FutureProvider<List<WalletLedgerEntry>>)` — paginated transaction history
- `payoutStatusProvider (StreamProvider<PayoutStatus>)` — real-time payout tracking

## Data
- Models: `WalletLedgerEntry`
- Repository: `WalletRepository` → `SupabaseWalletRepository`
- Services: `StripeService` (Connect Express for payouts)
- Table: `wallet_ledger` — see docs/schema.md

## How money flows (USD-first, no EGP in the system)
```
Sender books → Stripe Payment Intent (capture_method: manual)
  → Escrow held by Stripe (NOT in our DB — Stripe holds the funds)
  → Delivery confirmed → Edge Function captures payment
  → Funds land in Mercury Bank (USD)
  → Traveler payout via Stripe Connect (bank transfer)

No wallet top-up. No EGP. No Paymob.
Anti-inflation protection: all revenue stays USD in Mercury Bank.
Convert to EGP via Wise on YOUR schedule when spending in Egypt.
```

## WalletScreen layout (traveler view)
```
Top card (teal background, white text):
  "أرباحك / Your Earnings"
  Large: "$142.50" (available balance)
  Small: "$36.00 pending" (from in-transit bookings, not yet released)

  [اطلب تحويل / Request Payout] button (white on teal)
    → Disabled if available balance < $10
    → Disabled if Stripe Connect not set up → shows "Set up payouts first"

Quick stats row:
  Total earned | This month | Completed deals

Transaction tabs:
  [All] [Earnings] [Payouts]
  Each tab shows filtered WalletTransactionTile list
```

## Payout flow (Stripe Connect bank transfer)
```
1. Traveler sets up Stripe Connect Express (one-time):
   PayoutSettingsScreen → opens Stripe Express onboarding WebView
   Stripe handles bank account verification, KYC
   On completion: users.stripe_connect_id stored

2. Traveler taps "Request Payout" on WalletScreen:
   Minimum payout: $10 USD
   Confirmation dialog: "سيتم تحويل $142.50 إلى حسابك البنكي خلال 2-5 أيام عمل"
   On confirm: Edge Function initiates Stripe Connect payout
   wallet_ledger entry created (type: 'payout', payout_status: 'processing')

3. Stripe processes payout (2-5 business days for bank transfer):
   stripe-webhook Edge Function updates payout_status
   Traveler notified via FCM when payout completes or fails

4. If payout fails:
   Balance restored to available
   Error shown with Stripe's specific reason
   "Try again" or "Update bank details" options shown
```

## PayoutSettingsScreen
```
If Stripe Connect NOT set up:
  "أعد إعداد الحساب البنكي / Set up bank account"
  Explanation: "لاستلام أرباحك، نحتاج ربط حسابك البنكي عبر Stripe"
  [ابدأ الإعداد / Start Setup] → opens Stripe Express WebView

If Stripe Connect set up:
  Bank name + last 4 digits shown
  Status: "Active ✓" or "Action required ⚠"
  [Update bank details] → opens Stripe Express dashboard WebView

  Payout schedule: "Manual" (traveler requests) — not automatic
```

## Earnings breakdown (per booking)
```
When a booking completes, wallet_ledger gets an entry:
  type: 'earning'
  amount_usd: traveler_payout_usd (agreed_price - commission + courier_portion)
  ref_id: booking_id
  description_en: "Earning from booking #ABC123"
  description_ar: "أرباح من الحجز #ABC123"
```

## Business rules
- ALL wallet mutations via Edge Functions with idempotency keys — zero direct DB writes from Flutter
- No wallet top-up — senders pay via Stripe at booking time, not pre-funded balance
- All amounts in USD — no EGP anywhere in the wallet system
- Minimum payout: $10 USD
- Stripe Connect Express required before first payout (onboarding prompted after first completed booking)
- Payout method: bank transfer via Stripe Connect — no InstaPay in V1
- Pending earnings (from in-transit bookings) shown separately — not available for payout
- Refunds from cancelled bookings: Stripe refunds sender directly — does NOT go through wallet

## Acceptance criteria
- [ ] Traveler earnings balance shows correct USD amount
- [ ] Pending vs available earnings shown separately
- [ ] Stripe Connect Express onboarding opens in WebView and completes
- [ ] Payout request disabled when balance < $10
- [ ] Payout request disabled when Stripe Connect not set up — shows setup prompt
- [ ] Payout confirmation dialog shows amount and timeline (2-5 business days)
- [ ] Payout status updates in real-time via Stripe webhook
- [ ] Failed payout restores balance and shows specific error
- [ ] Transaction history shows correct type labels (earning vs payout)
- [ ] Idempotency key prevents duplicate payout requests
- [ ] All amounts displayed in USD throughout

## What NOT to build here
- Sender payment flow → features/bookings/ (Stripe Payment Sheet at booking time)
- Dispute refunds → features/disputes/ + Edge Functions (refund goes to sender via Stripe, not wallet)
- Booking creation → features/bookings/ + Edge Functions
- InstaPay payouts → deferred to V2
