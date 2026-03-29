import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum LugaBadgeVariant { verified, trusted, flightVerified, isNew }

class LugaBadge extends StatelessWidget {
  const LugaBadge({
    super.key,
    required this.variant,
    required this.label,
    this.icon,
  });

  final LugaBadgeVariant variant;
  final String label;
  final IconData? icon;

  Color get _background => switch (variant) {
        LugaBadgeVariant.verified => AppColors.primaryLight,
        LugaBadgeVariant.trusted => AppColors.amberLight,
        LugaBadgeVariant.flightVerified => AppColors.primaryLight,
        LugaBadgeVariant.isNew => AppColors.surfaceAlt,
      };

  Color get _foreground => switch (variant) {
        LugaBadgeVariant.verified => AppColors.primary,
        LugaBadgeVariant.trusted => AppColors.amber,
        LugaBadgeVariant.flightVerified => AppColors.primary,
        LugaBadgeVariant.isNew => AppColors.textSecondary,
      };

  IconData? get _defaultIcon => switch (variant) {
        LugaBadgeVariant.verified => Icons.verified_rounded,
        LugaBadgeVariant.flightVerified => Icons.flight_rounded,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final displayIcon = icon ?? _defaultIcon;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (displayIcon != null) ...[
            Icon(displayIcon, size: 12.sp, color: _foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: _foreground,
            ),
          ),
        ],
      ),
    );
  }
}
