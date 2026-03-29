import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/luga_card.dart';

class GuaranteeBadge extends StatelessWidget {
  const GuaranteeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return LugaCard(
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: AppColors.success, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Luga Protection', style: AppTypography.titleMedium),
                Text(
                  'Your payment is held in escrow until delivery is confirmed.',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
