# discovery — spec

## What this feature does
Both sides browse and find each other.
Senders browse verified travelers on their corridor.
Travelers browse open shipment requests on their route.
Smart matching: push notifications when a match appears.

## Screens
- `SearchScreen` — entry point with route/date/weight search form. Tabs: Find Traveler | Find Requests.
- `TravelerFeedScreen` — paginated list of travelers on corridor, with filters and sort
- `ShipmentFeedScreen` — paginated list of open shipment requests on corridor, with filters

## Widgets
- `TravelerCard` — full traveler card: avatar + verified badge, name, rating (stars + count + completion%), departure date + route, remaining weight, category price chips, handoff options, "Book at $X" + "Make offer" + "Message" buttons
- `ShipmentRequestCard` — full request card: item photo, item name, route + deadline, weight, sender avatar + rating, reward bar (amber, bottom of card), "Send offer" button + bookmark
- `SearchFiltersBar` — horizontal scroll chips: All | Departing soon | Most rated | Has space | Door delivery
- `CorridorSearchForm` — origin + destination city pickers, date range, weight filter

## State
- `TravelerFeedProvider (FutureProvider<List<TripModel>>)` — travelers for corridor + date
- `ShipmentFeedProvider (FutureProvider<List<ShipmentModel>>)` — requests for corridor
- `DiscoverySearchNotifier (StateNotifier)` — search params (origin, dest, date, weight filter)

## Data
- Models: `TripModel`, `ShipmentModel`, `UserModel`
- Repositories: `TripRepository`, `ShipmentRepository`
- Tables: `trips`, `shipments`, `users` — see docs/schema.md

## TravelerCard spec
```
Top section:
  Left: avatar (48px) + verified badge overlay
  Center: display name, rating "4.8 ★ · 23 trips · 98% completion"
  Right: "Verified" badge chip

Middle section:
  Route: Dubai → Cairo (flag emojis for origin/dest)
  Departs: 15 Dec 2024
  Weight: "7kg remaining" (NOT total capacity — remaining after bookings)
  Destination area: "delivers to Maadi" if courier option enabled

Category price chips (horizontal scroll):
  Phone $50 | Laptop $70 | Cosmetics $15 | Clothes $12 | ...
  Only show categories traveler has priced (not exclusions)
  "Negotiable" chip shown if traveler has no preset prices

Bottom actions:
  "Book at $[price]" — only shown if sender's item category has preset price
  "Make offer" — always shown
  "Message" — opens pre-payment chat (counts toward 10-msg limit)
```

## ShipmentRequestCard spec
```
Left: item photo (80×80px, rounded corners)
      Weight badge overlay on photo: "🎒 450g"

Right:
  Item name (bold, 1 line truncated)
  Route: United States → Cairo (with flag + arrow)
  Deadline: "Before 26 Mar 2026"
  Divider line
  Sender avatar (32px) + name + star rating

Bottom bar (full width, AppColors.surface background):
  Left: "Reward" label (secondary text, 11sp)
  Right: amount in AppColors.amber, 16sp bold e.g. "US$14.00"

Trailing actions:
  ">>" button — expand/view details
  Bookmark icon — save to wishlist
```

## Sort options
Travelers: Departing soon (default) | Highest rated | Most trips | Cheapest
Requests: Highest reward (default) | Lightest item | Newest | Soonest deadline

## Filter chips
```
For traveler feed:
  All | Departing this week | 4.5+ rating | Has 5kg+ space | Door delivery

For shipment feed:
  All | Electronics | Cosmetics | Clothing | Medicine | Food | Documents
```

## Smart matching — push notifications
```
When traveler posts a trip:
  → Query open shipments matching origin_iata + destination_iata
  → For each matching sender: send FCM push
    "مسافر جديد متجه لـ القاهرة في 15 ديسمبر — 8 كيلو متاحة"

When sender posts a shipment:
  → Query confirmed trips matching corridor + date range
  → For each matching traveler: send FCM push
    "طلب شحن جديد على مسارك — مكافأة $14"

Implemented in Edge Function or Supabase DB trigger.
```

## Boosted listings
```
Travelers who pay $2.99 boost appear at top of feed for 48h.
Shown with subtle "مميز / Featured" chip — same visual style, not garish.
Max 2 boosted listings per page (don't pollute the feed).
```

## Empty states
```
No travelers on corridor:
  Plane illustration + "لا يوجد مسافرون على هذا المسار حالياً"
  Toggle: "أُخطَر عند توفر مسافر / Notify me when one is available"
  → saves corridor preference to user record

No shipment requests on corridor:
  Package illustration + "لا توجد طلبات شحن على مسارك حالياً"
  CTA: "تصفح المسارات الأخرى / Browse other corridors"
```

## Business rules
- Only show trips with status = 'confirmed' OR 'planned' in feed (not cancelled/completed)
- Only show shipments with status = 'open' in feed
- remaining_weight_kg must be > 0 for trip to appear
- Traveler's own trips never shown in their own traveler feed
- Sender's own shipments never shown in their own shipment feed
- Verified travelers (kyc_level >= 2) ranked above unverified in default sort

## Acceptance criteria
- [ ] Traveler feed loads under 2 seconds on real 4G
- [ ] Shimmer skeleton shown while loading — not spinner
- [ ] Category price chips correct per traveler's settings
- [ ] Reward bar shows amber amount at bottom of every shipment card
- [ ] "Book at $X" button only appears if sender's item category has preset price
- [ ] Remaining weight shown (not total capacity)
- [ ] Empty state shown with notify toggle when no results
- [ ] Boosted listings appear at top with "Featured" label, max 2 per page
- [ ] Weight filter correctly excludes travelers with insufficient remaining capacity

## What NOT to build here
- Making an offer → features/offers/
- Chat → features/chat/
- Traveler profile detail → features/profile/
- Trip detail → features/trips/
