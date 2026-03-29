import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary brand
  static const Color primary = Color(0xFF1A9E92);
  static const Color primaryLight = Color(0xFFE0F2EE);
  static const Color primaryDark = Color(0xFF0E7068);

  // Accent — ONLY for reward amounts, earnings, payout numbers
  static const Color amber = Color(0xFFF5A623);
  static const Color amberLight = Color(0xFFFFF4E0);

  // Surfaces — light
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F8FA);
  static const Color surfaceAlt = Color(0xFFEDEEF0);

  // Surfaces — dark
  static const Color backgroundDark = Color(0xFF1A1D23);
  static const Color surfaceDark = Color(0xFF22262E);
  static const Color surfaceAltDark = Color(0xFF2C3038);

  // Text
  static const Color textPrimary = Color(0xFF1A1D23);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Dark-mode text
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF6B7280);

  // Borders
  static const Color border = Color(0xFFEDEEF0);
  static const Color borderStrong = Color(0xFFC8CAD0);
  static const Color borderDark = Color(0xFF2C3038);
  static const Color borderStrongDark = Color(0xFF4B5058);

  // Semantic
  static const Color success = Color(0xFF22A559);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF5A623);
  static const Color warningLight = Color(0xFFFFF3CD);
  static const Color danger = Color(0xFFE53935);
  static const Color dangerLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF1565C0);
  static const Color infoLight = Color(0xFFE3F2FD);
}
