import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'luga_button.dart';

class LugaEmptyState extends StatelessWidget {
  const LugaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28.sp,
                color: AppColors.primary,
              ),
            ),
            const Gap(AppSpacing.lg),
            Text(
              title,
              style: AppTypography.h2(locale),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const Gap(AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTypography.body(locale).copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const Gap(AppSpacing.xl),
              LugaButton(
                label: actionLabel!,
                onTap: onAction!,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
