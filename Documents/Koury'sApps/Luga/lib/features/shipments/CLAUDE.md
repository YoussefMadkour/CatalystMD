# shipments — spec

## What this feature does
Senders create shipments — a bundle of one or more shopping items going to Egypt.
4-way item entry gate (URL scraper, popular stores, in-app browser, manual).
Draft recovery. Auto-calculated totals. Summary screen with declaration before posting.

## Screens
- `ShipmentsHomeScreen` — sender home: active shipments list, "Post Request" + "Find Traveler" CTAs, quick search bar
- `CreateShipmentScreen` — step 1: route + deadline + delivery pref. Step 2: item cart. Step 3: summary.
- `AddItemScreen` — 4-way entry gate: URL | Popular stores | Browse web | Manual
- `ItemFormScreen` — individual item: name, URL, qty stepper, weight, price, category picker, photos (min 2)
- `ShipmentDetailScreen` — full shipment view, matching travelers, edit options before booking

## Widgets
- `ShipmentCard` — compact card: route, deadline, weight, status badge, reward bar at bottom
- `ItemCartTile` — single item row: photo thumbnail, name, qty × weight, price, edit/delete icons
- `UrlScraperField` — URL input with paste detection, loading state, auto-fill trigger, graceful fallback
- `PopularStoresGrid` — 8-12 store logo chips (Amazon.ae, Noon, Shein, H&M, Zara, Nike, ASOS, Namshi)
- `CategoryPriceChip` — category label with price (used in both discovery and item form)
- `ShipmentSummaryCard` — total items, total weight, suggested reward range, fee preview

## State
- `CreateShipmentNotifier (StateNotifier<CreateShipmentState>)` — form state, item cart, totals, draft
- `shipmentsProvider (FutureProvider<List<ShipmentModel>>)` — sender's own shipments by status
- `shipmentDetailProvider (FutureProvider<ShipmentModel>)` — single shipment with items

## Data
- Models: `ShipmentModel`, `ShipmentItemModel`, `ShipmentDraft`, `ScrapedProduct`
- Repositories: `ShipmentRepository` → `SupabaseShipmentRepository`
- Services: `ScraperService` (calls Edge Function scrape-product)
- Tables: `shipments`, `shipment_items`, `drafts` — see docs/schema.md

## Multi-item model — critical design
```
One shipment = One route + deadline + delivery preference
              + List<ShipmentItem> (1 to 10 items)

Computed automatically (never let user enter these directly):
  total_weight_g = Σ(item.unit_weight_g × item.quantity)
  total_declared_value_usd = Σ(item.unit_price_usd × item.quantity)
  suggested_reward = PriceCalculator.rangeForShipment(items)
```

## 4-way entry gate — AddItemScreen
```
Option 1 — "I have the URL":
  UrlScraperField shown. User pastes URL.
  Detect paste via TextEditingController listener.
  Validate domain against whitelist (client-side first).
  Call ScraperService.scrape(url) → supabase.functions.invoke('scrape-product').
  On success: pre-fill ItemFormScreen (name, photos, price, category suggestion).
  On failure: show snackbar "Couldn't import — fill in manually", open blank form.
  Never block on scraper failure.

Option 2 — "Show me popular stores":
  PopularStoresGrid shown. Tap store → opens store URL in WebView.
  User browses, finds product, taps "Use this URL" floating button.
  URL passed back to Option 1 flow.

Option 3 — "Browse the web":
  WebView with search engine. Same "Use this URL" button.
  User can navigate anywhere.

Option 4 — "Enter manually":
  Blank ItemFormScreen. User fills everything.
```

## URL scraper — supported domains
Amazon.ae, Amazon.com, Noon.com, Shein.com, H&M (hm.com), Zara (zara.com),
Nike (nike.com), ASOS (asos.com), Namshi (namshi.com), Carrefour UAE,
Sharaf DG (sharafdg.com)

Short URL handling: amzn.to, noon.ooo → resolve redirect before scraping.

## ItemFormScreen fields
```
- Name (text, required, auto-filled from scraper)
- Source URL (optional, auto-filled, user can clear)
- Quantity (stepper +/−, min 1, max 10)
- Unit weight in grams (number input or preset buttons: 100g / 500g / 1kg / 2kg)
- Unit price USD (number, auto-filled from scraper if available)
- Category (dropdown with subcategories — see CategoryConstants)
- Photos (min 2 required, gallery OR camera allowed here)
  Auto-filled from scraper (up to 4 images downloaded and added)
```

## Summary screen — step 3
```
Shows before posting:
  - Total items count
  - Total weight (formatted by LugaFormatters.weight())
  - Suggested reward range (from PriceCalculator)
  - Platform service fee preview (10%)
  - Customs warning if total declared value > $150

Required before "Post Shipment" button is enabled:
  - Prohibited items checkbox: "I confirm this shipment does not contain
    cash, liquids over 100ml, controlled medications, or items over $200
    declared value without customs documentation."

"Post Shipment" button disabled until checkbox ticked.

Show: "$1,000 Luga Guarantee included" badge prominently.
Show: "50–70% cheaper than DHL" social proof line.
```

## Draft recovery
```
On CreateShipmentScreen and ItemFormScreen init:
  Check drafts table for user_id + form_type = 'shipment'
  If draft exists: show DraftRecoveryDialog
    "Continue where you left off?" → Continue | Cancel
  Continue: restore all state including item cart
  Cancel: delete draft from DB, start fresh

Auto-save: after every step change and every item add/remove/edit
Clear: on successful post OR explicit cancel
```

## Business rules
- Minimum 2 photos per item — enforced in ItemFormScreen, Next button disabled
- Scraper always fails gracefully — never throw uncaught error to user
- Short URLs resolved before scraping — fetch with follow redirects
- Prohibited items checkbox required — Post button disabled until ticked
- Items with declared value > $150 → show orange customs warning
- Total declared value > $1,000 → show red warning (exceeds Luga Guarantee)
- Max 10 items per shipment — add button hidden after 10
- Draft saved after every state change — not just on step transitions

## Acceptance criteria
- [ ] Amazon.ae URL auto-fills name + photos + price within 3 seconds
- [ ] Noon.com URL works correctly
- [ ] Unsupported URL shows graceful fallback — manual entry form opens
- [ ] Short URLs (amzn.to) resolved before scraping
- [ ] Min 2 photos enforced — Next disabled without them
- [ ] Total weight updates in real-time as items added/changed
- [ ] Suggested reward range updates as weight and category change
- [ ] Customs warning shown for declared value > $150
- [ ] Prohibited items checkbox required — Post button disabled without it
- [ ] Draft recovery works — abandoning and returning restores full cart
- [ ] Quantity stepper correctly multiplies weight and price

## What NOT to build here
- Finding travelers → features/discovery/
- Making offers → features/offers/
- Payment → features/bookings/
- Scraper Edge Function → supabase/functions/scrape-product/ (backend)
