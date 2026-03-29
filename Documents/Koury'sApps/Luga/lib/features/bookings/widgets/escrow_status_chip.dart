import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class EscrowStatusChip extends StatelessWidget {
  const EscrowStatusChip({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'held' => (AppColors.escrowHeld, 'Funds held in escrow'),
      'released' => (AppColors.escrowReleased, 'Funds released'),
      _ => (AppColors.surfaceVariant, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock, size: 14),
          const SizedBox(width: AppSpacing.xxs),
          Text(label, style: AppTypography.labelMedium),
        ],
      ),
    );
  }
}
