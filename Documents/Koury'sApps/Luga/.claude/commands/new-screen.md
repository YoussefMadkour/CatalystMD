Create a new screen for a Luga feature.

Input format: [FeatureName]/[ScreenName]
Example: $ARGUMENTS (e.g. "trips/PostTripScreen")

Parse $ARGUMENTS to get feature name and screen name.

Create `lib/features/[feature]/screens/[snake_case]_screen.dart`

Rules:
- Screen = a routable page registered in AppRouter
- Screen assembles widgets — NO business logic in build()
- ALL state from Riverpod providers via `ref.watch()`
- Error states use `LugaEmptyState.error()`
- Loading states use `LugaShimmer`
- All strings via localisation keys

Template:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
// TODO: import feature providers

/// [ScreenName]
/// Route: [RouteNames.xxx] — add to core/routing/route_names.dart
class [ScreenName] extends ConsumerWidget {
  const [ScreenName]({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: watch providers
    // final state = ref.watch(someProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'TODO: localised title',
          // style: AppTypography.title(Localizations.localeOf(context)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg.w),
          child: Column(
            children: [
              // TODO: build screen content
            ],
          ),
        ),
      ),
    );
  }
}
```

After creating:
1. Show the screen file
2. Show the route constant to add to `core/routing/route_names.dart`
3. Show the GoRoute to add to `core/routing/app_router.dart`
