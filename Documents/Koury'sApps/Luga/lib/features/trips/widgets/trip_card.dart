import 'package:flutter/material.dart';

import '../../../core/models/trip_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/luga_card.dart';

class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return LugaCard(
      onTap: () {
        // TODO: Navigate to trip detail
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(trip.departureCity, style: AppTypography.titleMedium),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(Icons.arrow_forward, size: 16),
              ),
              Text(trip.arrivalCity, style: AppTypography.titleMedium),
              const Spacer(),
              Text(Formatters.dateShort(trip.departureDate), style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${trip.availableWeight} kg available • ${trip.acceptedCategories.length} categories',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
