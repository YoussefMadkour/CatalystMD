import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static String _family(Locale locale) =>
      locale.languageCode == 'ar' ? 'IBMPlexArabic' : 'PlusJakartaSans';

  /// Screen titles only.
  static TextStyle h1(Locale locale) => TextStyle(
        fontFamily: _family(locale),
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  /// Section headings.
  static TextStyle h2(Locale locale) => TextStyle(
        fontFamily: _family(locale),
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  /// Card titles, item names.
  static TextStyle title(Locale locale) => TextStyle(
        fontFamily: _family(locale),
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  /// Descriptions, chat, content.
  static TextStyle body(Locale locale) => TextStyle(
        fontFamily: _family(locale),
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  /// Timestamps, labels, hints.
  static TextStyle caption(Locale locale) => TextStyle(
        fontFamily: _family(locale),
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        height: 1.4,
      );

  /// Reward amounts, prices. Always amber (reward) or primary.
  static TextStyle money({bool isReward = false}) => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: isReward ? AppColors.amber : AppColors.primary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Button labels.
  static TextStyle button(Locale locale) => TextStyle(
        fontFamily: _family(locale),
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textInverse,
        height: 1.2,
      );
}
