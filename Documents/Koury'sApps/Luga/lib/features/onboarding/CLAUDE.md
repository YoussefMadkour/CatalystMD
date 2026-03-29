# onboarding — spec

## What this feature does
Profile setup after first sign-up. ID verification (KYC) for travelers via Persona WebView.
Stripe Connect Express onboarding for travelers to receive payouts.
Senders skip KYC and go straight to home after profile setup.

## Screens
- `ProfileSetupScreen` — name, display name, profile photo (required). Both roles.
- `KycScreen` — KYC explainer + Persona WebView flow. Travelers only.
- `PayoutSetupScreen` — Stripe Connect Express onboarding. Triggered after first deal accepted, not at signup.

## Widgets
- `PhotoPickerCircle` — circular avatar with tap-to-edit. Compresses to 400×400px before upload.

## State
- `OnboardingNotifier (StateNotifier<OnboardingState>)` — profile photo upload, name validation, KYC status polling

## Data
- Models: `UserModel`
- Repository: `UserRepository`
- Services: `PersonaService`, `StripeService`
- Tables: `users` — see docs/schema.md

## KYC flow
```
KycScreen:
  1. Show explainer screen (Luga-branded, not Persona yet)
     - Why we verify: protect senders, unlock earnings, get badge
     - "Start Verification" (primary) | "Maybe Later" (text link)

  2. "Maybe Later" → go to traveler home with persistent banner
     - Banner: "أكمل التحقق لتبدأ الكسب / Complete verification to earn"
     - Tapping banner returns to KycScreen
     - Cannot post trips or accept deals until verified

  3. "Start Verification" → call PersonaService.createInquiryUrl(userId)
     → open returned URL in WebView (webview_flutter)

  4. WebView NavigationDelegate watches for redirect containing 'persona-complete'
     → close WebView
     → show "Reviewing your identity — usually under 2 minutes" screen
     → Supabase Realtime watches users.kyc_status for change to 'approved'
     → on approved: push notification + navigate to traveler home

  5. Persona webhook hits Edge Function persona-webhook
     → validates Persona signature
     → updates users.kyc_level and users.kyc_status
     → Realtime triggers UI update automatically
```

## Payout setup flow
```
NOT triggered at onboarding — triggered lazily:
  After traveler's first offer is accepted:
    → Check if users.stripe_connect_id is null
    → If null: show "Set up payouts to receive your earnings" bottom sheet
    → Tap "Set up" → call StripeService.createExpressAccountLink(userId)
    → Open returned URL in WebView or external browser
    → Stripe handles KYC for payouts (separate from Persona)
    → On complete: Stripe webhook updates users.stripe_connect_id
```

## Business rules
- Profile photo is required — cannot proceed without it
- Compress photo to 400×400px, max 200kb before upload (image_utils.dart)
- Full name minimum 2 words enforced
- Traveler: kyc_level must be >= 2 before posting trips or accepting deals
- Payout setup must be complete before escrow can be released to traveler
- KYC explainer screen always shown before Persona WebView — never jump straight to Persona

## Acceptance criteria
- [ ] Profile photo required — continue button disabled until photo added
- [ ] Photo compressed to under 200kb before upload
- [ ] "Maybe Later" on KYC stores state — banner shows on traveler home
- [ ] Persona WebView opens within 3 seconds of tapping "Start Verification"
- [ ] "Reviewing identity" screen shown immediately after Persona completes — no blank screen
- [ ] kyc_level updates automatically without user having to refresh
- [ ] Payout setup prompt shown after first deal accepted — not before
- [ ] Travelers without stripe_connect_id cannot have escrow released

## Edge cases
- Persona verification fails (document unclear) → show failure screen with retry option
- User backgrounds app during Persona flow → WebView state preserved on return
- Network drops during photo upload → retry button shown, draft state preserved

## What NOT to build here
- Auth (phone OTP) → features/auth/
- Role switching → features/more/settings
- Payout history → features/wallet/
