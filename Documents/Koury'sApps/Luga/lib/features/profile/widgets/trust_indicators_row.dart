import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';

class TrustIndicatorsRow extends StatelessWidget {
  const TrustIndicatorsRow({super.key, required this.rating, required this.trips, required this.shipments});
  final double rating;
  final int trips;
  final int shipments;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _indicator(Icons.star, '$rating', 'Rating'),
        _indicator(Icons.flight, '$trips', 'Trips'),
        _indicator(Icons.inventory_2, '$shipments', 'Shipments'),
      ],
    );
  }

  Widget _indicator(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: AppSpacing.xxs),
        Text(value, style: AppTypography.titleLarge),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}
