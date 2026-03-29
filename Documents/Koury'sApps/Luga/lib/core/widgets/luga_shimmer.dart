import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LugaShimmer extends StatelessWidget {
  const LugaShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  const LugaShimmer.card({super.key})
      : width = double.infinity,
        height = null,
        borderRadius = AppSpacing.radiusLg;

  const LugaShimmer.line({super.key, this.width = 120})
      : height = 12,
        borderRadius = AppSpacing.radiusSm;

  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.surfaceDark : AppColors.surfaceAlt,
      highlightColor: isDark ? AppColors.surfaceAltDark : AppColors.background,
      child: Container(
        width: width?.w,
        height: height?.h ?? 120.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.radiusMd),
        ),
      ),
    );
  }
}
