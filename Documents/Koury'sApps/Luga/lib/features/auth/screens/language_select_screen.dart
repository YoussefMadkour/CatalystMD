import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';

class LanguageSelectScreen extends ConsumerWidget {
  const LanguageSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Choose your language', style: TextStyle(fontSize: 24)),
              const SizedBox(height: AppSpacing.xl),
              LugaButton(
                label: 'English',
                onPressed: () {
                  ref.read(localeProvider.notifier).state = const Locale('en');
                  context.goNamed(RouteNames.roleSelect);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              LugaButton(
                label: 'العربية',
                variant: LugaButtonVariant.secondary,
                onPressed: () {
                  ref.read(localeProvider.notifier).state = const Locale('ar');
                  context.goNamed(RouteNames.roleSelect);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
