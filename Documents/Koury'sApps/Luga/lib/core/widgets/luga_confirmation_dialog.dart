import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'luga_button.dart';

abstract final class LugaConfirmationDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    String? cancelLabel,
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DialogBody(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDanger: isDanger,
      ),
    );
    return result ?? false;
  }
}

class _DialogBody extends StatelessWidget {
  const _DialogBody({
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel,
    required this.isDanger,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: isDanger ? AppColors.dangerLight : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDanger ? Icons.warning_rounded : Icons.help_outline_rounded,
                size: 24.sp,
                color: isDanger ? AppColors.danger : AppColors.primary,
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              title,
              style: AppTypography.h2(locale),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              message,
              style: AppTypography.body(locale).copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.xl),
            LugaButton(
              label: confirmLabel,
              onTap: () => Navigator.pop(context, true),
              variant: isDanger
                  ? LugaButtonVariant.danger
                  : LugaButtonVariant.primary,
            ),
            const Gap(AppSpacing.sm),
            LugaButton(
              label: cancelLabel ?? 'Cancel',
              onTap: () => Navigator.pop(context, false),
              variant: LugaButtonVariant.ghost,
            ),
          ],
        ),
      ),
    );
  }
}
