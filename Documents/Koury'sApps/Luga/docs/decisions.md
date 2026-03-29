# Luga — Architecture Decision Record (ADR)

Format: `DATE | DECISION | REASON`
Add one line every time a non-obvious decision is made during development.

---

## Stack decisions
```
[date] | Flutter over React Native | Arabic RTL rendering quality; Flutter owns its own rendering engine — pixel-perfect across devices. No JS bridge overhead.
[date] | Riverpod over GetX/BLoC | Type-safe, testable, compile-time safe. GetX is invasive. BLoC is overkill for this scope.
[date] | go_router over auto_route | Official Flutter team package. ShellRoute for bottom nav preserves scroll state.
[date] | Supabase over Firebase | Postgres SQL is better for the relational data model (trips, offers, bookings). Realtime is sufficient for chat.
[date] | Stripe for ALL payments (no Paymob) | US LLC registration → Stripe US account. Apple Pay / Google Pay as primary UI → bypasses Egyptian debit card 3DS failures. Credit cards work fine. Funds land in USD in Mercury Bank.
[date] | USD-first, no EGP in app | EGP lost 60% vs USD in 3 years. All prices, fees, payouts denominated in USD. Convert to EGP via Wise on your schedule when spending in Egypt.
[date] | Mercury Bank for revenue | USD account, integrates with Stripe. Anti-inflation protection for revenue.
[date] | InstaPay for Egyptian traveler payouts | Travelers in Egypt can opt for EGP payout via InstaPay (bank transfer). Converted from USD at market rate via Wise. Stripe Connect as alternative for USD payouts.
[date] | Stripe Connect for international traveler payouts | USD payouts, Express accounts handle traveler KYC for payouts.
[date] | Persona for KYC | Supports Egyptian national ID + UAE residence visa + passport. $1.50/check. No Flutter SDK — WebView approach.
[date] | flutter_screenutil for sizing | Egypt device mix is heavily fragmented (Realme, Xiaomi, Samsung budget). Without responsive sizing, layouts break on non-iPhone screens.
[date] | AviationStack via Edge Function | Free tier 100 calls/month. API key never exposed to client. Supabase Edge Function is the proxy.
[date] | Multi-item shipment model | Adopted from Hitchhiker analysis. One shipment = shopping cart of items. Doubles average deal value vs single-item model.
[date] | No wallet top-up model | Senders pay directly via Stripe at booking time (Apple Pay / Google Pay / card). Simpler UX, no pre-funding friction. Escrow via Stripe capture_method: manual.
[date] | Category preset prices on traveler cards | Adopted from Hykerz. Eliminates negotiation for standard items (70% of deals). 3-round offer still available for unusual/high-value items.
[date] | Blind ratings revealed after 72h | Prevents retaliation ratings. Both parties submit without seeing each other's rating. Reveal when both submit or 72h passes.
```

## Planned for V2 (not in V1 scope)
```
[2026-03-29] | Prepaid credits system (Luga Credits) | Non-refundable, non-withdrawable credits for referral rewards, affiliate payouts, promo codes. Legally framed as prepaid service credits (like app store credit), not a wallet. Avoids CBE/CBUAE licensing. At checkout: apply credits first, charge Stripe for remainder.
[2026-03-29] | Affiliate revenue via in-app browser | AddItemScreen Options 2+3 (Popular stores, Browse web) open WebViews with affiliate tags (Amazon Associates, Noon, etc). Earns 1-5% on purchases made through Luga. V1: make in-app browser the most prominent option in AddItemScreen. V2: offer fee discount (10% → 5% service fee) for purchases made through Luga's browser to incentivize affiliate flow. Revenue: ~3% affiliate + 5% fee = $4 vs 0% + 10% = $5 per deal — slightly less per deal but builds second revenue stream.
[2026-03-29] | InstaPay traveler payouts | Deferred to V2. V1 uses Stripe Connect bank transfer only. InstaPay adds EGP conversion complexity.
```

## Feature decisions (add here as you build)
```
[date] | [decision] | [reason]
```
