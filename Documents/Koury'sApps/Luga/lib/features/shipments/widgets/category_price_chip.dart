import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/price_calculator.dart';

class CategoryPriceChip extends StatelessWidget {
  const CategoryPriceChip({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final floor = PriceCalculator.floorFor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        '$category from \$${floor.toStringAsFixed(0)}',
        style: AppTypography.labelSmall,
      ),
    );
  }
}
