import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class NegotiationRoundIndicator extends StatelessWidget {
  const NegotiationRoundIndicator({super.key, required this.currentRound, required this.maxRounds});
  final int currentRound;
  final int maxRounds;

  @override
  Widget build(BuildContext context) {
    final isFinal = currentRound >= maxRounds;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs, horizontal: AppSpacing.md),
      color: isFinal ? AppColors.warning.withValues(alpha: 0.15) : AppColors.surfaceVariant,
      child: Text(
        isFinal ? 'Final round' : 'Round $currentRound of $maxRounds',
        style: AppTypography.labelMedium.copyWith(
          color: isFinal ? AppColors.secondaryDark : AppColors.textSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
