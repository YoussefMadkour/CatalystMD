import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_card.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            LugaCard(
              child: Column(
                children: [
                  Text('Balance', style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text('\$0.00', style: AppTypography.displayLarge.copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: LugaButton(label: 'Top up', onPressed: () { /* TODO */ })),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: LugaButton(label: 'History', variant: LugaButtonVariant.secondary, onPressed: () { /* TODO */ })),
              ],
            ),
            // TODO: Recent transactions
          ],
        ),
      ),
    );
  }
}
