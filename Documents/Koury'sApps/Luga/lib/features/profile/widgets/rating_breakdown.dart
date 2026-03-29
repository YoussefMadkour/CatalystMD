import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class RatingBreakdown extends StatelessWidget {
  const RatingBreakdown({super.key, required this.averageRating, required this.totalRatings, required this.distribution});
  final double averageRating;
  final int totalRatings;
  final Map<int, int> distribution;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(averageRating.toStringAsFixed(1), style: AppTypography.displayLarge),
            Text('$totalRatings reviews', style: AppTypography.bodySmall),
          ],
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            children: List.generate(5, (i) {
              final star = 5 - i;
              final count = distribution[star] ?? 0;
              final fraction = totalRatings > 0 ? count / totalRatings : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text('$star', style: AppTypography.labelSmall),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: LinearProgressIndicator(value: fraction, backgroundColor: AppColors.border, color: AppColors.rewardAmber)),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
