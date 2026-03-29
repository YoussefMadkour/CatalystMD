# trips — spec

## What this feature does
Travelers post upcoming trips (route, date, capacity, prices, handoff options).
Trips appear in the sender discovery feed. Draft recovery for interrupted form sessions.

## Screens
- `TripsHomeScreen` — traveler's home: active trips list, quick stats (earnings, trips), "Post Trip" CTA
- `PostTripScreen` — 4-step form with draft recovery
- `TripDetailScreen` — full trip info, matched shipment requests, edit/cancel options

## Widgets
- `TripCard` — compact card for list views: route, date, remaining weight, status badge
- `TripStepRoute` — Step 1: origin/destination city pickers with UAE/Egypt quick chips
- `TripStepFlight` — Step 2: date picker + flight number + AviationStack verification
- `TripStepCapacity` — Step 3: weight slider, handoff toggle, category price chips
- `TripStepHandoff` — Step 4: meetup vs courier, review summary

## State
- `PostTripNotifier (StateNotifier<PostTripState>)` — manages all 4 steps, validation, draft save/restore, submission
- `tripsProvider (FutureProvider<List<TripModel>>)` — traveler's own trips
- `activeTripProvider (StreamProvider<TripModel>)` — real-time single trip

## Data
- Models: `TripModel`
- Repository: `TripRepository` → `SupabaseTripRepository`
- Tables: `trips`, `drafts`
- See docs/schema.md: `trips` table, `drafts` table

## Business rules
- Draft saves to Supabase `drafts` table (not local storage) after each step
- `DraftRecoveryDialog` shown on form entry if draft exists
- Flight number verified via `verify-flight` Edge Function (AviationStack)
- Verified flight → status changes from "planned" to "confirmed"
- `remaining_weight_kg` decremented when booking is accepted
- Trip with 0 remaining weight hidden from discovery feed
- Category preset prices stored as JSONB `category_prices` on trip
- Handoff type: 'meetup' (default) or 'courier' (adds courier addon fee)

## Acceptance criteria
- [ ] 4-step form navigates forward/backward with state preserved
- [ ] Draft auto-saves to Supabase after each step change
- [ ] DraftRecoveryDialog appears on re-entry with pending draft
- [ ] Flight verification shows airline + route confirmation
- [ ] Invalid flight number shows specific error
- [ ] Category price chips editable per category
- [ ] Posted trip appears in TripsHomeScreen immediately
- [ ] Planned trip shows "Planned" badge, cannot accept bookings

## Edge cases
- User kills app mid-form → draft in Supabase, recovered on next visit
- Flight API unavailable → allow posting as "planned", show warning
- Trip date passes while active → auto-expire via Supabase cron
- Traveler edits trip with existing bookings → warn, block weight reduction below booked

## What NOT to build here
- Discovery feed → belongs in `features/discovery/`
- Offer negotiation → belongs in `features/offers/`
- Price calculation → use `PriceCalculator` from `core/utils/`
