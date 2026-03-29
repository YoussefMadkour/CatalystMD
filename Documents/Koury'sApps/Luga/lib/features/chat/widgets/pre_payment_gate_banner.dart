import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class PrePaymentGateBanner extends StatelessWidget {
  const PrePaymentGateBanner({super.key, this.isPaid = false});
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    if (isPaid) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: AppColors.info.withValues(alpha: 0.1),
      child: Text(
        'Messages are limited until booking is confirmed. Complete your booking to unlock full chat.',
        style: AppTypography.bodySmall.copyWith(color: AppColors.info),
        textAlign: TextAlign.center,
      ),
    );
  }
}
