import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum LugaButtonVariant { primary, secondary, ghost, danger }

class LugaButton extends StatelessWidget {
  const LugaButton({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = LugaButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback onTap;
  final LugaButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final bool expand;

  Color get _background => switch (variant) {
        LugaButtonVariant.primary => AppColors.primary,
        LugaButtonVariant.secondary => Colors.transparent,
        LugaButtonVariant.ghost => Colors.transparent,
        LugaButtonVariant.danger => AppColors.danger,
      };

  Color get _foreground => switch (variant) {
        LugaButtonVariant.primary => AppColors.textInverse,
        LugaButtonVariant.secondary => AppColors.primary,
        LugaButtonVariant.ghost => AppColors.primary,
        LugaButtonVariant.danger => AppColors.textInverse,
      };

  BorderSide? get _border => switch (variant) {
        LugaButtonVariant.secondary =>
          const BorderSide(color: AppColors.primary, width: 1.5),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final disabled = isDisabled || isLoading;

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 20.w,
        height: 20.w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _foreground,
        ),
      );
    } else {
      final textWidget = Text(
        label,
        style: AppTypography.button(locale).copyWith(color: _foreground),
      );
      if (icon != null) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18.sp, color: _foreground),
            const SizedBox(width: AppSpacing.sm),
            textWidget,
          ],
        );
      } else {
        child = textWidget;
      }
    }

    return Opacity(
      opacity: disabled ? 0.4 : 1.0,
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: 52.h,
        child: Material(
          color: _background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: _border != null ? Border.fromBorderSide(_border!) : null,
              ),
              alignment: Alignment.center,
              padding: expand
                  ? null
                  : const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
