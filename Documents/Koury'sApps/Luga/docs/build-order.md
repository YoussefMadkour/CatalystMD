# Luga — Build Order & Prompts

Open a new Claude Code tab for each feature. Copy the prompt exactly.
End every session with `/done`.

---

## Phase 1 — Foundation (must build first)

### 1. Core theme + widgets
```
Read CLAUDE.md and docs/brand.md.
Delete all existing scaffold .dart files in lib/core/theme/ and lib/core/widgets/.
Rebuild from scratch:
- app_colors.dart matching docs/brand.md exactly (teal primary, amber accent)
- app_typography.dart with locale-aware fonts (Plus Jakarta Sans / IBM Plex Arabic) using flutter_screenutil .sp
- app_spacing.dart matching docs/brand.md radii
- app_theme.dart assembling light + dark themes
Then build all core widgets from docs/brand.md specs:
- LugaButton (primary, secondary, ghost, danger, loading, disabled)
- LugaCard (border, radius, padding per spec)
- LugaBadge (verified, trusted, flightVerified, new)
- LugaAvatar, LugaShimmer, LugaEmptyState, LugaSnackbar, LugaBottomSheet
- LugaRewardBar, LugaConfirmationDialog
Use flutter_screenutil for all sizing. Gap() for spacing. No hardcoded colors.
```

### 2. Core models
```
Read CLAUDE.md and docs/schema.md.
Delete all existing scaffold .dart files in lib/core/models/.
Rebuild every model from the schema with proper fromJson/toJson/copyWith/==:
- UserModel (from users table)
- TripModel (from trips table)
- ShipmentModel + ShipmentItemModel (from shipments + shipment_items)
- OfferModel (from offers table)
- BookingModel (from bookings table)
- MessageModel (from messages table)
- RatingModel (from ratings table)
- WalletLedgerEntry (from wallet_ledger table)
- DisputeModel (from disputes table)
- NotificationModel (from notifications table)
Match every column name and type exactly from schema.md.
```

### 3. Core repositories + data sources
```
Read CLAUDE.md and docs/schema.md.
Delete all existing scaffold files in lib/core/repositories/ and lib/core/data_sources/.
Rebuild abstract repository interfaces for every entity.
Then build Supabase implementations in core/data_sources/supabase/.
Also create lib/core/providers/repository_providers.dart to wire them all up.
Follow the abstract repo pattern — features never touch Supabase directly.
Use the updated models you just built.
```

### 4. Core utils + services + routing + constants
```
Read CLAUDE.md, docs/api.md, and docs/brand.md.
Delete all existing scaffold files in lib/core/utils/, services/, routing/, constants/, providers/.
Rebuild:
- PriceCalculator with all fee logic from CLAUDE.md fee structure section
- Validators, Formatters, MessageFilter, ImageUtils, Extensions
- StripeService (payment sheet + Connect), PersonaService, AviationService,
  ScraperService, FcmService, AnalyticsService, DeepLinkService
- AppRouter with go_router, RouteNames with all route constants
- AppConstants, CategoryConstants, CorridorConstants
- Global providers: supabase_provider, auth_provider, locale_provider
Then rebuild main.dart and app.dart with ScreenUtil init, Sentry, Supabase init.
```

---

## Phase 2 — Auth + Onboarding (can't do anything without these)

### 5. Auth feature
```
Read CLAUDE.md and features/auth/CLAUDE.md.
Delete all existing scaffold files in lib/features/auth/.
Build the complete auth feature:
- SplashScreen — logo + auto-navigate based on auth state
- LanguageSelectScreen — AR/EN toggle persisted via flutter_secure_storage
- RoleSelectScreen — traveler/sender cards
- PhoneEntryScreen — country code picker + phone input + validation
- OtpScreen — 6-box input, auto-submit on fill, 60s resend timer, 3-attempt lockout
- ProfileSetupScreen — name + display name + required photo upload
- AuthNotifier with sendOtp, verifyOtp, signOut
- authStateProvider streaming from Supabase auth
- currentUserProvider for sync access
Wire all routes in AppRouter. Follow the navigation flow in the spec exactly.
All strings should use ARB localisation keys.
```

### 6. Onboarding feature
```
Read CLAUDE.md and features/onboarding/CLAUDE.md.
Delete all existing scaffold files in lib/features/onboarding/.
Build:
- KycScreen — explainer page + Persona WebView flow + "Maybe Later" path
- PayoutSetupScreen — Stripe Connect Express WebView (triggered lazily, not at signup)
- OnboardingNotifier managing photo upload, KYC status polling
- PhotoPickerCircle widget (400x400 compress before upload)
Wire KYC into auth flow: traveler → KycScreen after ProfileSetup.
Sender → skip to home. Persistent banner if KYC skipped.
```

---

## Phase 3 — Core marketplace (posting + discovery)

### 7. Trips feature
```
Read CLAUDE.md and features/trips/CLAUDE.md.
Delete all existing scaffold files in lib/features/trips/.
Build:
- TripsHomeScreen — traveler's trip list + stats + "Post Trip" FAB
- PostTripScreen — 4-step PageView (route → flight → capacity → handoff)
  with draft auto-save to Supabase drafts table after every step
- TripDetailScreen — full info + matched shipments + edit/cancel
- TripCard, TripStepRoute, TripStepFlight, TripStepCapacity, TripStepHandoff widgets
- PostTripNotifier with 4-step state + draft save/restore
- tripsProvider, activeTripProvider
- DraftRecoveryDialog integration
Flight verification via AviationService. Category price chips editable per category.
```

### 8. Shipments feature
```
Read CLAUDE.md and features/shipments/CLAUDE.md.
Delete all existing scaffold files in lib/features/shipments/.
Build:
- ShipmentsHomeScreen — sender's shipment list + "Post Request" FAB
- CreateShipmentScreen — 3-step: route+deadline → item cart → summary
- AddItemScreen — 4-way entry gate (URL scraper, popular stores, browse web, manual)
- ItemFormScreen — name, URL, qty stepper, weight, price, category, photos (min 2)
- ShipmentDetailScreen
- ShipmentCard, ItemCartTile, UrlScraperField, PopularStoresGrid,
  CategoryPriceChip, ShipmentSummaryCard widgets
- CreateShipmentNotifier with item cart + draft recovery
- shipmentsProvider, shipmentDetailProvider
URL scraper calls Edge Function via ScraperService. Graceful fallback on failure.
Prohibited items checkbox required before posting. Customs warning at $150+.
```

### 9. Discovery feature
```
Read CLAUDE.md and features/discovery/CLAUDE.md.
Delete all existing scaffold files in lib/features/discovery/.
Build:
- SearchScreen — route/date/weight search form with tabs
- TravelerFeedScreen — paginated list with shimmer loading
- ShipmentFeedScreen — paginated list with shimmer loading
- TravelerCard — full spec: avatar, badges, rating, route, weight,
  category price chips, "Book at $X" + "Make offer" + "Message" buttons
- ShipmentRequestCard — photo, name, route, deadline, reward bar (amber)
- SearchFiltersBar, CorridorSearchForm widgets
- TravelerFeedProvider, ShipmentFeedProvider, DiscoverySearchNotifier
Sort options, filter chips, empty states with "Notify me" toggle.
Only show remaining_weight (not total). Verified travelers ranked higher.
```

---

## Phase 4 — Transaction flow (the money path)

### 10. Offers feature
```
Read CLAUDE.md and features/offers/CLAUDE.md.
Delete all existing scaffold files in lib/features/offers/.
Build:
- MakeOfferScreen — item summary, price range bar, amount input,
  real-time PriceBreakdownCard, courier add-on toggle, floor price validation
- OfferThreadScreen — negotiation timeline with OfferBubbles,
  NegotiationRoundIndicator, CountdownTimer (live hh:mm:ss),
  OfferActionBar (accept/counter/decline)
- BookingSummaryScreen — full breakdown with tooltips, guarantee badge,
  trust gate section, Apple Pay/Google Pay primary CTA via Stripe Payment Sheet
- All widgets: OfferBubble, OfferActionBar, NegotiationRoundIndicator,
  CountdownTimer, PriceRangeBar, PriceBreakdownCard
- OfferNotifier (send, counter, accept, decline)
- offerThreadProvider (StreamProvider real-time)
Three paths: instant booking (preset price), negotiation (3 rounds), fixed price.
Floor price enforced. Max 3 rounds enforced. 6h expiry visual only (server cron).
```

### 11. Bookings feature
```
Read CLAUDE.md and features/bookings/CLAUDE.md.
Delete all existing scaffold files in lib/features/bookings/.
Build:
- ActiveBookingScreen — status timeline + escrow chip + departure countdown
- PickupConfirmScreen — live camera only, condition checklist, item mismatch option
- InTransitScreen — flight info, landing ETA
- HandoffScreen — meetup location OR door delivery, controlled phone reveal
- DeliveryConfirmScreen — live camera, LugaConfirmationDialog before escrow release
- BookingHistoryScreen — past bookings paginated
- BookingStatusTimeline, EscrowStatusChip, PhotoProofUploader, GuaranteeBadge widgets
- BookingNotifier with status transitions
- activeBookingProvider (StreamProvider), bookingHistoryProvider
Status machine is one-directional. Photos required before transitions.
Camera only (ImageSource.camera) for proof photos. Auto-release at T+48h.
Cancellation rules computed server-side.
```

---

## Phase 5 — Communication + Trust

### 12. Chat feature
```
Read CLAUDE.md and features/chat/CLAUDE.md.
Delete all existing scaffold files in lib/features/chat/.
Build:
- InboxScreen — conversation list with avatars, last message, unread badges
- ConversationScreen — real-time message list (Supabase Realtime),
  MessageInputBar with client-side filter warning,
  PrePaymentGateBanner ("7 of 10 messages"), BookingShortcutCard at message 10
- MessageBubble (sender right teal, traveler left grey, system centered)
- ChatNotifier sending via Edge Function (never direct DB insert)
- messagesProvider (StreamProvider), inboxProvider
Handle all filter error responses: CONTACT_INFO_DETECTED, SOCIAL_HANDLE_DETECTED,
OFF_APP_PAYMENT, MESSAGE_LIMIT_REACHED. Arabic error messages.
Read-only 72h after delivery_confirmed. Mixed AR+EN text rendering.
```

### 13. Profile feature
```
Read CLAUDE.md and features/profile/CLAUDE.md.
Delete all existing scaffold files in lib/features/profile/.
Build:
- OwnProfileScreen — avatar, name, badges, both ratings, review history, edit button
- UserProfileScreen — public profile with trust signals, reviews, sticky bottom bar
  Layout matches spec exactly: teal header, stats row, rating breakdown, tag chips
- RatingScreen — star rating + tag chips (separate tags for sender vs traveler) + comment
- RatingBreakdown, ReviewTagChips, TrustIndicatorsRow, TierBadge widgets
- profileProvider, RatingNotifier
Blind rating system: visible_at set when both submit or 72h passes.
Separate traveler_rating and sender_rating — never merged.
Trust tiers: New → Verified → Trusted → Elite based on trips + rating + disputes.
Phone/email omitted entirely from public profile.
```

---

## Phase 6 — Money + Safety

### 14. Wallet feature
```
Read CLAUDE.md and features/wallet/CLAUDE.md.
Delete all existing scaffold files in lib/features/wallet/.
Build:
- WalletScreen — traveler earnings balance (USD), pending vs available,
  "Request Payout" CTA, quick stats, transaction tabs
- PayoutSettingsScreen — Stripe Connect Express setup WebView, bank status
- WalletHistoryScreen — full ledger with All/Earnings/Payouts tabs
- EarningsCard, PayoutStatusChip, WalletTransactionTile widgets
- WalletNotifier, walletLedgerProvider
All USD. No EGP. Minimum payout $10. Stripe Connect required before payout.
Pending earnings from in-transit bookings shown separately.
```

### 15. Disputes feature
```
Read CLAUDE.md and features/disputes/CLAUDE.md.
Delete all existing scaffold files in lib/features/disputes/.
Build:
- DisputeScreen — reason radio buttons (5 options with Arabic), description textarea,
  evidence photo upload (gallery allowed here), confirmation dialog
- DisputeNotifier with form state + submission
Three triggers: delivery issue, manual open, system auto-flag.
Escrow frozen immediately. Both parties notified via FCM.
Admin resolves via Supabase Studio (no admin UI in V1).
```

### 16. More feature
```
Read CLAUDE.md and features/more/CLAUDE.md.
Delete all existing scaffold files in lib/features/more/.
Build:
- MoreScreen — profile card + menu sections (Account, Help, Info, Danger)
- SettingsScreen — language toggle (immediate switch), notification prefs
- NotificationsScreen — real-time list with deep links, unread badges, mark all read
- HowItWorksScreen — tabbed explainer (Senders / Travelers)
- TrustSafetyScreen — guarantee, KYC, escrow explanation
- DeleteAccountScreen — blocker check for active bookings, 30-day grace period,
  confirmation dialog, sign out after request
- SettingsNotifier, notificationsProvider
Notification deep links must handle missing bookings gracefully.
Language change via Riverpod locale — no restart needed.
```

---

## After all features

### 17. Architecture audit
```
/check-arch
```

### 18. Close out
```
/done
```
