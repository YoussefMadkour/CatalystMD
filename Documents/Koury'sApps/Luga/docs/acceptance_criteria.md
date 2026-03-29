# Luga — Full acceptance criteria (all modules)

Tick these off as features are built and tested.
Each item should be tested on a real device before marking complete.

## auth
- [ ] OTP received within 10 seconds on Egyptian (+20) and UAE (+971) numbers
- [ ] Wrong OTP shows specific error, not a generic "something went wrong"
- [ ] Account locked for 5 minutes after 3 wrong OTP attempts
- [ ] Returning user with valid session bypasses all auth screens and lands on home
- [ ] Language selection (AR/EN) persists across full app restarts
- [ ] Role selection stored on user record and reflected in home screen immediately
- [ ] Session token in flutter_secure_storage — confirmed not in SharedPreferences
- [ ] No personal data (phone, name) logged to console in production builds
- [ ] Auth redirect guard prevents accessing home screens when logged out

## trips
- [ ] Valid flight number (e.g. EK922) shows confirmed flight details within 3 seconds
- [ ] Invalid flight number shows specific error message — not generic
- [ ] AviationStack API key is never visible in client network requests
- [ ] Abandoning trip form mid-way and returning shows DraftRecoveryDialog
- [ ] Continuing from draft restores exact step and all entered values
- [ ] Cancelling draft clears it from DB — next open starts fresh
- [ ] Categories-won't-carry appear correctly on traveler's public profile card
- [ ] Planned trip (no flight) posts with "Planned" badge and cannot accept bookings
- [ ] Available weight updates in real-time when a booking is accepted
- [ ] Trip with 0kg remaining does not appear in discovery feed
- [ ] Category preset prices display as chips on traveler card in discovery feed

## shipments
- [ ] Amazon.ae product URL populates name, photos, and price within 3 seconds
- [ ] Noon.com URL scraper works correctly
- [ ] Unsupported domain URL shows graceful fallback — "Enter manually" option
- [ ] Shortened URLs (amzn.to) are resolved before scraping
- [ ] Minimum 2 photos enforced — "Next" button disabled until satisfied
- [ ] Live camera requirement enforced for delivery proof (no gallery option)
- [ ] Total weight auto-calculates as items are added/removed
- [ ] Suggested reward range updates in real-time as items/weight change
- [ ] Prohibited items checkbox required — cannot post without ticking
- [ ] Draft recovery works identically to trips
- [ ] Customs warning shown for items with declared value above $150

## discovery
- [ ] Traveler feed loads in under 2 seconds on a real 4G Egyptian connection
- [ ] Shimmer skeleton shown while feed is loading
- [ ] Category price chips visible on each traveler card
- [ ] Reward bar with amber amount visible at bottom of each shipment card
- [ ] "No travelers available" empty state shown when corridor is empty
- [ ] "Notify me" toggle saves corridor preference for future notifications
- [ ] Boosted traveler listings appear at top with "Featured" label

## offers
- [ ] Offer below platform floor price blocked with clear message showing the minimum
- [ ] Round counter displays "Round 2 of 3" — never shows Round 4
- [ ] Round 3 shows amber "Final round" warning banner
- [ ] Countdown timer shows live seconds — not just "expires in 6 hours"
- [ ] Offer expiry enforced server-side — confirmed by testing with expired offer attempt
- [ ] Expired offer shows "Offer expired" state — not a generic error
- [ ] After 3 expired rounds: "Start fresh" option resets to Round 1
- [ ] Accepted offer immediately navigates to BookingSummaryScreen with no extra taps
- [ ] Price breakdown updates in real-time as amount is typed in offer field
- [ ] Fixed-price trip shows "Book now" button — no negotiation UI shown

## bookings
- [ ] Wallet deducted atomically — no partial deduction possible on network failure
- [ ] Escrow status visible on active booking screen at all times
- [ ] Pickup photo forces live camera — gallery button absent or disabled
- [ ] Delivery confirmation requires recipient photo — escrow button disabled until photo uploaded
- [ ] Escrow release confirmation dialog shown with clear irreversibility warning
- [ ] Auto-release triggers exactly 48h after delivery photo uploaded with no sender action
- [ ] Sender receives push + email 24h before auto-release
- [ ] Sender receives push + email 6h before auto-release
- [ ] Cancellation refund amount matches policy: 100% if >48h, 0% if <48h to departure
- [ ] All booking status transitions logged with timestamp in DB

## chat
- [ ] Egyptian phone number (+201...) is blocked before send, sender sees explanation
- [ ] UAE phone number (+9715...) is blocked before send
- [ ] Social media handles (@...) blocked before send
- [ ] WhatsApp link (wa.me/) blocked before send
- [ ] "Instapay" text blocked before send
- [ ] Blocked message is stored with flagged=true — not silently dropped
- [ ] Pre-payment message count shows "7 of 10 messages used" indicator
- [ ] Message 11 attempt shows booking prompt — message NOT sent
- [ ] Messages load in under 1 second on 4G (tested on real device)
- [ ] Arabic + English mixed text renders correctly on Android 10+ devices
- [ ] Chat auto-closes to read-only 72h after delivery_confirmed status

## payments & wallet
- [ ] Booking payment shows Apple Pay / Google Pay buttons prominently above card form
- [ ] Apple Pay works on iOS devices with supported cards
- [ ] Google Pay works on Android devices with supported cards
- [ ] Credit card fallback form works for users without Apple/Google Pay
- [ ] Stripe Payment Sheet displays amount in USD
- [ ] Payment failure shows user-friendly error — specific message for 3DS failures
- [ ] Successful payment creates booking and holds escrow (capture_method: manual)
- [ ] Escrow capture triggers on delivery confirmation — funds to Mercury Bank
- [ ] Traveler earnings ledger shows correct USD amounts
- [ ] Traveler payout via Stripe Connect works for international travelers
- [ ] Traveler payout via InstaPay works for Egypt-based travelers (EGP conversion)
- [ ] Payout settings screen lets traveler choose: Stripe Connect (USD) or InstaPay (EGP)
- [ ] Idempotency key prevents duplicate charges on webhook retry
- [ ] All amounts displayed in USD throughout the app

## ratings
- [ ] Rating screen shown immediately after escrow release
- [ ] Rating screen dismissable — reminder appears after 24h if not submitted
- [ ] Rating not visible on profile until both parties submit OR 72h elapses
- [ ] Traveler rating and sender rating are calculated and displayed separately
- [ ] Review tags count correctly — "On time · 23" = 23 unique bookings
- [ ] Rating below 3.5 — account flagged in Supabase Studio (visible to admin)
- [ ] Users with fewer than 3 trips show "New — no rating yet" on profile

## security
- [ ] Supabase RLS confirmed: user cannot read another user's wallet ledger
- [ ] Supabase RLS confirmed: user cannot read another user's private messages
- [ ] Supabase RLS confirmed: user cannot modify another user's trip listing
- [ ] AviationStack API key not visible in any client network request
- [ ] Stripe secret key not visible in any client network request
- [ ] Stripe publishable key is the only Stripe key on client side
