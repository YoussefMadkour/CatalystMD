import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum LugaSnackbarVariant { success, error, info, warning }

abstract final class LugaSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    LugaSnackbarVariant variant = LugaSnackbarVariant.info,
  }) {
    final (bg, fg, icon) = switch (variant) {
      LugaSnackbarVariant.success => (
          AppColors.success,
          AppColors.textInverse,
          Icons.check_circle_rounded,
        ),
      LugaSnackbarVariant.error => (
          AppColors.danger,
          AppColors.textInverse,
          Icons.error_rounded,
        ),
      LugaSnackbarVariant.info => (
          AppColors.info,
          AppColors.textInverse,
          Icons.info_rounded,
        ),
      LugaSnackbarVariant.warning => (
          AppColors.warning,
          AppColors.textPrimary,
          Icons.warning_rounded,
        ),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          margin: const EdgeInsets.all(AppSpacing.lg),
          content: Row(
            children: [
              Icon(icon, color: fg, size: 20.sp),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
