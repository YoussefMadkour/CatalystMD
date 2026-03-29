Scaffold a new Luga feature module.

Feature name: $ARGUMENTS

Do the following:

1. Create this folder structure under `lib/features/$ARGUMENTS/`:
   - `screens/` (empty)
   - `providers/` (empty)
   - `widgets/` (empty)

2. Create `lib/features/$ARGUMENTS/CLAUDE.md` with this exact content
   (replace $ARGUMENTS with the actual feature name):

```
# $ARGUMENTS — spec

## What this feature does
[TODO: 1-2 sentence description]

## Screens
- `[ScreenName]` — [what it shows and does]

## Widgets
- `[WidgetName]` — [what it renders]

## State
- `[NotifierName] (StateNotifier<[State]>)` — manages [what]
- `[providerName] (FutureProvider/StreamProvider)` — provides [what]

## Data
- Models: [ModelName]
- Repository: [Name]Repository → Supabase[Name]Repository
- Tables: [table_name] — see docs/schema.md

## Business rules
- [Rule 1]
- [Rule 2]

## Acceptance criteria
- [ ] [AC item — paste from docs/acceptance_criteria.md]

## Edge cases
- [scenario] → [how to handle]

## What NOT to build here
- [thing] → belongs in [other feature or core/]
```

3. Show me the created structure and list every file path created.

4. Remind me: "Fill in the CLAUDE.md TODOs before asking me to build anything in this feature."
