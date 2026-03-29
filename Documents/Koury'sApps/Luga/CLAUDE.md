# Luga — Claude Code project brief

## What this app is
Peer-to-peer package delivery marketplace. Egyptians abroad (travelers) carry packages inbound to Egypt for senders. UAE → Egypt is the primary corridor, KSA → Egypt expands at month 3. Two-sided marketplace: travelers earn money on flights they're already taking, senders get cheaper + faster delivery than DHL/FedEx.

## Stack — no deviations without explicit approval
- **Flutter 3 / Dart** — iOS + Android + Web from one codebase
- **Supabase** — Postgres DB, Auth (phone OTP only), Realtime, Storage, Edge Functions (Deno)
- **Riverpod** — ALL state management. Never GetX. Never Provider. Never BLoC.
- **go_router** — ALL navigation. Route constants in `core/routing/route_names.dart`
- **flutter_screenutil** — ALL sizing. `.sp` for text, `.h`/`.w` for dimensions. Base: 390×844
- **flutter_animate** — micro-animations on cards, success states, transitions
- **shimmer** — loading skeletons on every feed screen, never a spinner alone
- **cached_network_image** — all remote images
- **flutter_localizations + intl** — Arabic (ar_EG) + English (en_US). ARB files.
- **flutter_secure_storage** — session tokens. Never SharedPreferences for auth data.
- **image_picker** — photos. Pickup/delivery proofs: `ImageSource.camera` only (no gallery).
- **Stripe** — ALL payments. Sender pays via Apple Pay / Google Pay (primary) or credit card. Payment intents via Edge Functions. Funds land in USD in Mercury Bank.
- **Stripe Connect** — traveler payouts in USD. Express accounts.
- **InstaPay** — Egyptian traveler payouts in EGP (optional payout method for Egypt-based travelers).
- **Persona** — KYC via WebView. No Flutter SDK — use `webview_flutter`.
- **AviationStack** — flight verification. Called from Edge Function only. Never client-side.
- **FCM (firebase_messaging)** — push notifications
- **Mixpanel** — analytics. Every key user action tracked from day one.
- **Sentry** — crash reporting in production builds
- **gap** — spacing utility. `Gap(16)` not `SizedBox(height: 16)`

## Architecture — non-negotiable rules
**Pattern: Feature-first Clean Architecture**

```
UI (Flutter widgets)
  ↓ calls
Providers (Riverpod StateNotifier / FutureProvider / StreamProvider)
  ↓ calls
Repositories (abstract interfaces in core/repositories/)
  ↓ implemented by
Data Sources (core/data_sources/supabase/)
  ↓ returns
Models (core/models/ — typed Dart, fromJson/toJson/copyWith)
```

**Enforced rules — these are bugs if violated:**
1. No `Supabase.instance` or `.from(` calls outside `core/data_sources/`. Zero exceptions.
2. No business logic in widget `build()` methods. Build renders state. Nothing else.
3. No hardcoded colors anywhere. Always `AppColors.x` from `core/theme/app_colors.dart`.
4. No hardcoded user-facing strings. Always localisation keys from ARB files.
5. Features never import from other features. If two features share something, it moves to `core/`.
6. All fee/price calculations go through `PriceCalculator` in `core/utils/price_calculator.dart`.
7. All message filtering runs in an Edge Function before DB insert — never client-side only.

## Folder layout (top level)
```
lib/
├── main.dart              # Supabase.initialize, ProviderScope, SentryFlutter.init
├── app.dart               # MaterialApp.router, locale, theme, router
├── core/                  # Shared across all features
│   ├── theme/             # AppColors, AppTypography, AppSpacing, AppTheme
│   ├── widgets/           # LugaButton, LugaCard, LugaBadge, LugaAvatar...
│   ├── models/            # All data models
│   ├── repositories/      # Abstract repository interfaces
│   ├── data_sources/      # Supabase implementations
│   ├── services/          # External APIs (Stripe, Persona, etc.)
│   ├── utils/             # PriceCalculator, Formatters, Validators, etc.
│   ├── routing/           # AppRouter, RouteNames
│   ├── constants/         # AppConstants, CategoryConstants, CorridorConstants
│   └── providers/         # Global providers (auth, locale, supabase client)
└── features/              # One folder per feature
    ├── auth/
    ├── onboarding/
    ├── trips/
    ├── shipments/
    ├── discovery/
    ├── offers/
    ├── bookings/
    ├── chat/
    ├── profile/
    ├── wallet/
    ├── disputes/
    └── more/
```

## DRY rules
- Same widget in 2+ places → `core/widgets/` before writing it twice
- Same calculation anywhere → `core/utils/` first
- Same color value → `AppColors` first
- Same route string → `RouteNames` first
- Same user-facing string → ARB localisation file first

## Payment architecture — USD-first
- **All prices in USD.** No EGP in the app. Anti-inflation protection (EGP lost 60% in 3 years).
- **Sender pays via Stripe:** Apple Pay / Google Pay shown as primary. Credit card as fallback. Egyptian debit cards may fail 3DS — credit cards and Apple/Google Pay work fine.
- **Funds land in Mercury Bank (USD).** You convert to EGP on your schedule via Wise when needed.
- **Traveler payouts:** Stripe Connect (USD) for international travelers. InstaPay (EGP conversion) for Egypt-based travelers.
- **UI rule:** Apple Pay / Google Pay buttons shown prominently above the card form. Most users should never see a card input.

## Fee structure (single source of truth — never inline these)
- Sender pays: `agreed_price + (agreed_price × 0.10) + courier_addon`
- Traveler earns: `agreed_price - (agreed_price × 0.10) + (courier_addon × 0.80)`
- Luga revenue: `(agreed_price × 0.10) + (agreed_price × 0.10) + (courier_addon × 0.20)`
- Protection fund allocation: `luga_revenue × 0.20` (ring-fenced)
- Implementation: `PriceCalculator.calculate()` — see `core/utils/price_calculator.dart`

## Business rules — never violate
- Max 3 negotiation rounds. Round 4 auto-rejected server-side AND client-side.
- Offer expiry: 6 hours — enforced by Supabase cron, client timer is visual only.
- Pickup photo: live camera (`ImageSource.camera`) — no gallery. Hard gate.
- Delivery photo: live camera — hard gate before escrow release.
- Escrow release is irreversible — always show `LugaConfirmationDialog` first.
- Pre-payment chat: max 10 messages — enforced by Edge Function, not just UI.
- Wallet mutations: only via Edge Functions with idempotency keys.
- Booking status machine is one-directional — never skip or reverse states.

## Booking status machine
```
awaiting_payment → escrow_held → pickup_confirmed → in_transit
  → delivery_confirmed → completed
Branches off any state: → disputed | → refunded | → cancelled
```

## Localisation
- Default locale: `ar_EG` (Arabic Egypt, RTL)
- Secondary: `en_US`
- All Arabic text uses IBM Plex Arabic font
- All English text uses Plus Jakarta Sans font
- RTL is automatic via locale — never hardcode `TextDirection.rtl`

## Current build status — UPDATE THIS EVERY SESSION
```
Phase:             Phase 1 — Foundation + first transaction
Currently building: [UPDATE ME]
Last completed:    [UPDATE ME]
```

## Reference docs (read when relevant — not always)
- Full DB schema: `docs/schema.md`
- Acceptance criteria (all modules): `docs/acceptance_criteria.md`
- External API integration patterns: `docs/api.md`
- Brand/design tokens: `docs/brand.md`
- Architecture decisions log: `docs/decisions.md`
