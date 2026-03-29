# auth — spec

## What this feature does
Phone OTP authentication. Language selection (AR/EN). Role selection (traveler/sender).
No email, no password — phone-only, which matches Egyptian/UAE user behaviour.

## Screens
- `SplashScreen` — Luga logo + language select (AR / EN). First launch only. Skip if returning user.
- `RoleSelectScreen` — Two cards: "I'm a Traveler" / "I'm a Sender". Can switch roles later.
- `PhoneEntryScreen` — Country code picker + phone number. "Send Code" button.
- `OtpScreen` — 6-box OTP input, auto-submit on fill, 60s resend timer, 3-attempt lockout.
- `ProfileSetupScreen` — Name, display name, profile photo (required). Links to KYC for travelers.

## State
- `AuthNotifier (StateNotifier<AuthState>)` — manages: phone entry, OTP sending/verifying, session, error states
- `authStateProvider (StreamProvider<User?>)` — global auth stream from Supabase
- `currentUserProvider (FutureProvider<UserModel?>)` — hydrates UserModel from DB

## Data
- Models: `UserModel`
- Repository: `AuthRepository` → `SupabaseAuthRepository`
- Tables: `auth.users` (Supabase managed), `public.users`
- See docs/schema.md: `users` table

## Business rules
- Phone numbers stored in E.164 format (e.g. +201012345678)
- Language preference stored via `flutter_secure_storage` — persists without account
- Role stored on `users.role` — can be changed in settings later
- Traveler role → continues to `KycScreen` after profile setup
- Sender role → goes directly to sender home after profile setup
- Session token stored in `flutter_secure_storage` — NEVER SharedPreferences

## Acceptance criteria
- [ ] OTP received within 10s on +20 and +971 numbers
- [ ] Wrong OTP shows specific error, not generic message
- [ ] Locked 5 min after 3 failed attempts
- [ ] Returning user bypasses all auth screens
- [ ] Language persists across full app restart
- [ ] Role stored on user record immediately
- [ ] No personal data logged to console in production

## Edge cases
- User pastes 6 digits → all boxes fill instantly, auto-submit
- User changes phone number after OTP sent → "Change number" taps back, invalidates sent OTP
- User backgrounded app during 60s timer → timer continues, not reset
- Network offline when sending OTP → retry button shown, not spinner
- New user profile setup interrupted → allow completion from home banner

## Navigation flow
```
App open
  └─ Session exists? → Home (role-appropriate)
  └─ First launch → SplashScreen
       └─ Language select → RoleSelectScreen
            └─ Role selected → PhoneEntryScreen
                 └─ OTP verified
                      ├─ New user → ProfileSetupScreen
                      │    ├─ Traveler → KycScreen → TravelerHome
                      │    └─ Sender → SenderHome
                      └─ Returning user → Home
```

## What NOT to build here
- KYC → belongs in `features/onboarding/`
- Home screen → belongs in `features/trips/` or `features/shipments/`
- Settings/language toggle for logged-in users → belongs in `features/more/`
