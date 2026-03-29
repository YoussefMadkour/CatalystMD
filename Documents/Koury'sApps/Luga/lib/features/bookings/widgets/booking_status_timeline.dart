import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class BookingStatusTimeline extends StatelessWidget {
  const BookingStatusTimeline({super.key, this.currentStep = 0});
  final int currentStep;

  static const _steps = ['Booked', 'Picked up', 'In transit', 'Delivered', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_steps.length, (i) {
        final isActive = i <= currentStep;
        return Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isActive ? AppColors.primary : AppColors.border,
                  child: isActive ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                ),
                if (i < _steps.length - 1)
                  Container(width: 2, height: 24, color: isActive ? AppColors.primary : AppColors.border),
              ],
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(_steps[i], style: isActive ? AppTypography.titleMedium : AppTypography.bodyMedium),
          ],
        );
      }),
    );
  }
}
