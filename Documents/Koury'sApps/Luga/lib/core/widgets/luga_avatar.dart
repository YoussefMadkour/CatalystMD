import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class LugaAvatar extends StatelessWidget {
  const LugaAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.initials,
  });

  final String? imageUrl;
  final double radius;
  final String? initials;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: size.w,
          height: size.w,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(size),
          errorWidget: (_, __, ___) => _fallback(size),
        ),
      );
    }

    return _fallback(size);
  }

  Widget _placeholder(double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _fallback(double size) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials ?? '',
        style: TextStyle(
          fontSize: (size * 0.4).sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
