import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/price_calculator.dart';
import 'luga_card.dart';

class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({
    super.key,
    required this.breakdown,
  });

  final PriceBreakdown breakdown;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return LugaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price breakdown', style: AppTypography.title(locale)),
          const SizedBox(height: AppSpacing.sm),
          _row(locale, 'Item price', breakdown.itemPrice),
          _row(locale, 'Service fee', breakdown.serviceFee),
          _row(locale, 'Commission', breakdown.commission),
          if (breakdown.courierFee > 0)
            _row(locale, 'Courier add-on', breakdown.courierFee),
          const Divider(),
          _row(locale, 'Total', breakdown.total, bold: true),
        ],
      ),
    );
  }

  Widget _row(Locale locale, String label, double amount,
      {bool bold = false}) {
    final style =
        bold ? AppTypography.title(locale) : AppTypography.body(locale);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: style.copyWith(
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
