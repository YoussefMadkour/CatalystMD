Create a new shared Luga UI widget.

Widget name: $ARGUMENTS

Create `lib/core/widgets/[snake_case].dart`

Rules — enforced by root CLAUDE.md and docs/brand.md:
- flutter_screenutil: ALL dimensions use `.h`, `.w`, `.sp`, `.r`
- ALL colors from `AppColors` — never `Color(0x...)` or `Colors.`
- ALL text styles from `AppTypography` — never inline TextStyle
- ALL spacing from `AppSpacing` — never magic numbers
- Support RTL automatically via locale (never hardcode `TextDirection.rtl`)
- Const constructor if StatelessWidget
- Props must be typed — no `dynamic`

Template:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';

/// [WidgetName] — [one line description of what this widget does]
///
/// Usage:
/// ```dart
/// [WidgetName](
///   // TODO: show example usage here
/// )
/// ```
class $ARGUMENTS extends StatelessWidget {
  // TODO: define props — be specific about types

  const $ARGUMENTS({
    super.key,
    // TODO: required + optional props
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    // Use locale.languageCode == 'ar' for Arabic-specific adjustments

    return Container(
      // TODO: implement using AppColors, AppTypography, AppSpacing
      // TODO: use flutter_screenutil for all sizing
    );
  }
}
```

After creating the file:
1. Show me the completed widget
2. Show me how to add it to the exports in `core/widgets/widgets.dart`
   (create that barrel file if it doesn't exist)
3. Show me 2 example usages in context
