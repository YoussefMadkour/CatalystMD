import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/luga_button.dart';

class KycScreen extends ConsumerWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Identity verification')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Verify your identity', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'To ensure safety, we need to verify your identity. This takes about 2 minutes.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            // TODO: Launch Persona WebView for KYC
            const Spacer(),
            LugaButton(
              label: 'Start verification',
              onPressed: () {
                // TODO: Open Persona KYC flow
              },
            ),
            const SizedBox(height: AppSpacing.md),
            LugaButton(
              label: 'Skip for now',
              variant: LugaButtonVariant.ghost,
              onPressed: () {
                // TODO: Navigate to home
              },
            ),
          ],
        ),
      ),
    );
  }
}
