# Luga — Claude Code Workflow Guide

## How it works

Claude Code automatically reads two levels of specs:

| File | When it's read | What it enforces |
|------|---------------|-----------------|
| `CLAUDE.md` (root) | Every conversation | Stack, architecture rules, fee structure, business rules |
| `features/X/CLAUDE.md` | When you're working on feature X | Screens, state, data, acceptance criteria, edge cases |

You never need to paste specs or say "read the CLAUDE.md". It's automatic.

---

## Building a new feature from scratch

### Example: Building the offers feature

**Step 1 — Scaffold (optional, if feature folder doesn't exist yet)**
```
/new-feature offers
```
Creates `lib/features/offers/screens/`, `providers/`, `widgets/`, and a blank `CLAUDE.md`.

**Step 2 — Fill in the spec**

Open `lib/features/offers/CLAUDE.md` and write (or paste) the full spec:
screens, state, business rules, acceptance criteria, edge cases.

**Step 3 — Build**

Now just tell Claude what to build. It reads the spec automatically.

```
Build the MakeOfferScreen with real-time price breakdown
```

Claude already knows from the spec:
- Max 3 rounds, 6h expiry
- Floor price enforced via PriceCalculator
- Price breakdown updates as user types
- Amount below floor → blocked with message

**Step 4 — Build more pieces**

```
Build the OfferNotifier with create, counter, accept, decline methods
```

```
Build the OfferBubble widget and NegotiationRoundIndicator
```

```
Build the OfferThreadScreen that streams offers in real-time
```

**Step 5 — Audit**
```
/check-arch
```

**Step 6 — Close session**
```
/done
```

---

## Editing existing code

### Example: Adding a feature to an existing screen

```
Add a "Notify me" toggle to the TravelerFeedScreen that saves
the corridor preference for future push notifications
```

Claude reads `features/discovery/CLAUDE.md`, sees the AC item about "Notify me", and knows:
- The screen uses `travelerFeedProvider`
- It shows `TravelerCard` widgets with category price chips
- Notifications go through FCM

### Example: Fixing a bug

```
The offer expiry timer resets when the user backgrounds the app.
Fix it so the timer continues counting down based on the server expiry time.
```

Claude reads the offers spec, knows expiry is 6h enforced server-side, and fixes the timer to use `expiresAt` from the model instead of a local countdown.

### Example: Changing business logic

```
Change the cancellation refund policy from 100%/>48h to 80%/>48h
```

Claude knows from root `CLAUDE.md` that all fee logic goes through `PriceCalculator`, so it edits the right file — not inline in a screen.

### Example: Adding a field to a model

```
Add a `is_round_trip` boolean field to TripModel based on the schema
```

Claude reads `docs/schema.md`, sees the field definition, and updates:
- The model class (field + fromJson + toJson + copyWith)
- Any screens that should display it

---

## Using slash commands

### Scaffolding commands — use when creating new things

| Command | When to use | Example |
|---------|-------------|---------|
| `/new-feature X` | Starting a brand new feature module | `/new-feature referrals` |
| `/new-model X` | Need a new data model from schema | `/new-model Rating` |
| `/new-repository X` | Need data access for a new entity | `/new-repository Rating` |
| `/new-provider X/Y` | Need state management for a feature | `/new-provider bookings/BookingNotifier` |
| `/new-screen X/Y` | Need a new routable screen | `/new-screen wallet/TopupScreen` |
| `/new-widget X` | Need a new shared widget | `/new-widget LugaCountdown` |

### Quality commands — use during and after building

| Command | When to use | Example |
|---------|-------------|---------|
| `/check-arch` | Before committing, after building | `/check-arch` |
| `/done` | End of every coding session | `/done` |

---

## What you can just say (no commands needed)

For most work, plain English is all you need. The specs do the heavy lifting.

### Building screens
```
Build the PostTripScreen 4-step form with draft recovery
```

### Building widgets
```
Create a TripCard widget that shows route, date, weight, and category price chips
```

### Building providers
```
Create the ChatProvider that streams messages and tracks unread count
```

### Refactoring
```
The shipment creation flow is too slow. Split the item cart into
its own provider so it doesn't rebuild the whole form on every item add.
```

### Connecting things
```
Wire up the BookingSummaryScreen to actually call Stripe payment sheet
when the user taps Confirm & Pay
```

### Asking questions
```
How should I handle the case where both users send a counter-offer
at the exact same time?
```
Claude reads the offers spec edge cases section and gives you the answer.

---

## Tips

1. **Fill in the CLAUDE.md before building.** The spec is your contract with Claude. Vague spec → vague code.

2. **One feature at a time.** Don't say "build the whole chat feature". Say "build the ConversationScreen" then "build the MessageInputBar with the off-platform filter".

3. **Run `/check-arch` often.** Architecture violations compound fast. Catch them early.

4. **Run `/done` every session.** This is what keeps your CLAUDE.md files accurate. Skip it and the specs rot.

5. **Be specific about edge cases.** "Handle the error" is vague. "Show a retry button with the specific Stripe error message, don't show a spinner" is actionable.

6. **Reference the acceptance criteria.** You can say: "Build whatever is needed to tick off the first 3 ACs in the offers spec". Claude reads them and builds exactly that.
