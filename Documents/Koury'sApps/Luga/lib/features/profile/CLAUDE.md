# profile — spec

## What this feature does
User profiles with comprehensive trust signals.
Separate traveler rating and sender rating (never merged into one score).
Blind rating system — reveal only after both parties submit or 72h pass.
Review tags shown as frequency chips.

## Screens
- `OwnProfileScreen` — own profile with edit button, stats, both ratings, review history
- `UserProfileScreen` — another user's public profile — trust signals, reviews, active trips/shipments
- `RatingScreen` — post-delivery rating: stars, structured tag chips, optional written comment

## Widgets
- `RatingBreakdown` — large score number + star distribution bars (5★ to 1★) + traveler/sender split with separate scores
- `ReviewTagChips` — horizontal wrap of frequency chips: "في الموعد · 28", "تعامل بحرص · 21"
- `TrustIndicatorsRow` — response rate, completion rate, member since date, total deals completed
- `TierBadge` — New | Verified | Trusted | Elite — based on trip count + rating + disputes

## State
- `profileProvider (FutureProvider<UserModel>)` — parameterised by userId
- `RatingNotifier (StateNotifier<RatingState>)` — manages submission of blind rating

## Data
- Models: `UserModel`, `RatingModel`
- Repositories: `RatingRepository`, `UserRepository`
- Tables: `ratings`, `users` — see docs/schema.md

## Rating system — blind reveal
```
After booking status → completed:

Both parties shown RatingScreen immediately.
Submitting is optional — but prompt appears again after 24h if not done.
Rating window: 7 days. After 7 days, rating opportunity expires.

Blind logic:
  Both submit → visible_at = NOW() for both rows → both appear on profiles
  One submits, other doesn't within 72h → visible_at = submitted_at + 72h
    (revealed regardless, to prevent holding ratings hostage)
  Neither submits → no rating shown (ratings table has no rows)

Supabase cron (every hour):
  UPDATE ratings SET visible_at = NOW()
  WHERE visible_at IS NULL
    AND submitted_at < NOW() - INTERVAL '72 hours'
```

## Review tags
```dart
// Traveler rates sender with (shown on sender's profile):
const senderTags = [
  ('accurate_description', 'وصف دقيق / Accurate description'),
  ('responsive',           'سريع الاستجابة / Quick to respond'),
  ('easy_handoff',         'سهل التسليم / Easy handoff'),
  ('reliable',             'موثوق / Reliable'),
];

// Sender rates traveler with (shown on traveler's profile):
const travelerTags = [
  ('on_time',             'في الموعد / On time'),
  ('handled_carefully',   'تعامل بحرص / Handled carefully'),
  ('great_communication', 'تواصل ممتاز / Great communication'),
  ('professional',        'احترافي / Professional'),
];

// Display as frequency chips on profile:
// Sorted by frequency descending
// "في الموعد · 28" means this tag was given across 28 separate bookings
```

## Trust tier thresholds
```dart
TierBadge tierFor(UserModel user) {
  if (user.tripCount >= 30 && user.travelerRating >= 4.7
      && user.disputeCount == 0) return TierBadge.elite;
  if (user.tripCount >= 10 && user.travelerRating >= 4.5)
      return TierBadge.trusted;
  if (user.tripCount >= 3 && user.travelerRating >= 3.5)
      return TierBadge.verified;
  return TierBadge.newUser;
}
```

## UserProfileScreen layout
```
Top section (AppColors.primary background, white text):
  Back arrow | "[Name] S." | City + country flag
  Avatar (80px) | Document verified badge | Phone verified badge
  Stats row: [31 Deal(s)] | [37 Shipment(s)] | [0 Trip(s)]

White section:
  "Basic Info" (NOTE: email and phone shown as "Not available" to others)
  DO NOT show "Not available" fields — omit entirely if private.
  Only show: Member since date, Response rate, Completion rate.

  "Reviews [count]"
  Large score: "4.8" with 5 stars
  Bar chart: ★★★★★ ████████████ 23
             ★★★★☆ ████         8
             ★★★☆☆ ██           3
             ★★☆☆☆ █            1
             ★☆☆☆☆             0

  "Traveler Rating: 4.8 ★ · Sender Rating: 5.0 ★" — SEPARATE, not merged

  ReviewTagChips

  Review list (latest 5, "See all" expander):
  Each review: avatar + display name + stars + date + comment text

Sticky bottom bar (if viewing someone else's profile):
  "راسل / Message" | "احجز / Book" buttons
```

## Business rules
- Ratings only unlocked after booking status = 'completed' — not before
- Minimum 3 completed bookings before public score shown (show "New — no rating yet" before)
- Traveler rating and sender rating calculated and stored completely separately
- Rating below 3.5 → users.is_flagged = true → visible to admin, NOT to other users
- Public profile never shows phone number or email address
- Report user available from 3-dot menu on UserProfileScreen
- Block user available from same menu — blocked users cannot message or book

## Acceptance criteria
- [ ] Traveler rating and sender rating shown as separate scores on profile
- [ ] Rating not visible until both parties submit OR 72h passes (verify timing)
- [ ] ReviewTagChips frequency count correct — counts unique bookings not taps
- [ ] Users with < 3 trips show "New traveler — no rating yet" not a 0.0 score
- [ ] Report flow creates entry in Supabase (verify in Studio)
- [ ] Rating below 3.5 sets is_flagged = true in users table
- [ ] Phone and email fields omitted entirely from public profile (not "Not available")

## What NOT to build here
- Post-delivery escrow release → features/bookings/
- Dispute resolution → features/disputes/
- Settings (language, notifications) → features/more/
