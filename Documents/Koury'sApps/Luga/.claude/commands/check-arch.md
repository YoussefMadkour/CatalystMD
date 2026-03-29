Audit the Luga codebase for architecture violations.

Read every .dart file in lib/ and check for these violations.
Report EVERY violation — do not stop at the first one.

## Check 1 — Hardcoded colors
Search for any of these patterns OUTSIDE lib/core/theme/app_colors.dart:
- `Color(0x`
- `Color(#`
- `Colors.`
- `color: Color`
- `background: Color`

Flag: file path + line + the offending code

## Check 2 — Direct Supabase calls outside data sources
Search for any of these OUTSIDE lib/core/data_sources/:
- `Supabase.instance`
- `supabase.from(`
- `.from('`
- `SupabaseClient`

Flag: file path + line + the offending code

## Check 3 — Business logic in build() methods
Inside any Widget's `build()` method, look for:
- Arithmetic operators: `*`, `/`, `+`, `-` applied to non-layout values
- Conditional fee calculations
- `.map()` or `.where()` on data lists (data transformation)
- Direct repository calls

Flag: file path + what logic was found

## Check 4 — Cross-feature imports
In any file under lib/features/X/, look for imports that reference lib/features/Y/
(where X ≠ Y — cross-feature dependencies are forbidden).
Shared code must live in lib/core/ instead.

Flag: file path + the illegal import path

## Check 5 — Hardcoded user-facing strings
In any widget or screen file, look for:
- Arabic text in string literals (Unicode Arabic characters)
- English sentences or phrases in Text() widgets (not single words like 'id')

Flag: file path + the hardcoded string

## Check 6 — Price calculations outside PriceCalculator
Outside lib/core/utils/price_calculator.dart, look for:
- `* 0.10` or `* 0.9` (fee percentages)
- `agreedPrice *`
- `commission`
- `platform_fee`

Flag: file path + the inline calculation

## Output format

If violations found:
```
ARCHITECTURE VIOLATIONS FOUND
==============================
[Check 1 — Hardcoded colors]
❌ lib/features/trips/widgets/trip_card.dart:34 — Color(0xFF1A9E92)

[Check 4 — Cross-feature imports]
❌ lib/features/chat/providers/chat_provider.dart:3 — import '../bookings/...'

[Clean checks]
✓ Check 2 — No direct Supabase calls outside data sources
✓ Check 3 — No business logic in build() methods
✓ Check 5 — No hardcoded strings
✓ Check 6 — No inline price calculations
```

If no violations:
```
✓ Architecture audit passed — no violations found.
All 6 checks clean.
```
