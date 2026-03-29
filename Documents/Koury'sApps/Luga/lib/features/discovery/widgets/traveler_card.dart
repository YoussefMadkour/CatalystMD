import 'package:flutter/material.dart';

import '../../../core/models/trip_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/luga_card.dart';
import '../../shipments/widgets/category_price_chip.dart';

class TravelerCard extends StatelessWidget {
  const TravelerCard({super.key, required this.trip});
  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return LugaCard(
      onTap: () { /* TODO: Navigate to trip detail or make offer */ },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${trip.departureCity} → ${trip.arrivalCity}', style: AppTypography.titleMedium),
              const Spacer(),
              Text(Formatters.dateShort(trip.departureDate), style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xxs,
            children: trip.acceptedCategories
                .map((c) => CategoryPriceChip(category: c))
                .toList(),
          ),
        ],
      ),
    );
  }
}
