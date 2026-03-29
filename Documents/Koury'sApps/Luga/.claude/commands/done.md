End of session — update all Luga project documentation.

You have just completed a Claude Code session working on Luga.
Follow these steps in order:

## Step 1 — Ask me these questions (one at a time, wait for each answer)

1. "What file(s) did you finish building this session?"
2. "What are you building at the start of next session?"
3. "Which acceptance criteria did you complete? (list the feature and AC text)"
4. "Any architecture or library decisions made this session? (e.g. chose X over Y, handled edge case Z by doing W)"

## Step 2 — Update root CLAUDE.md

Read the current CLAUDE.md and update:
```
Currently building: [answer from question 2]
Last completed:    [answer from question 1]
```

## Step 3 — Update feature CLAUDE.md

Based on question 3, in the relevant `lib/features/[feature]/CLAUDE.md`:
Change `- [ ]` to `- [x]` for each completed AC item.

## Step 4 — Update docs/decisions.md

For each decision from question 4, add a new line:
```
[YYYY-MM-DD] | [decision made] | [reason]
```

## Step 5 — Show summary

Output:
```
SESSION SUMMARY
═══════════════
Completed:     [what was built]
Up next:       [what to build next]
AC ticked:     [X items in Y feature]
Decisions logged: [count]

Files updated:
  ✓ CLAUDE.md
  ✓ features/[x]/CLAUDE.md
  ✓ docs/decisions.md

Start next session with: /check-arch
```
