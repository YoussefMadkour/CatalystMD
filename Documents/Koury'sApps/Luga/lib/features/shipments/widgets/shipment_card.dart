import 'package:flutter/material.dart';

import '../../../core/models/shipment_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/luga_card.dart';

class ShipmentCard extends StatelessWidget {
  const ShipmentCard({super.key, required this.shipment});
  final ShipmentModel shipment;

  @override
  Widget build(BuildContext context) {
    return LugaCard(
      onTap: () { /* TODO: Navigate to shipment detail */ },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(shipment.departureCity, style: AppTypography.titleMedium),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(Icons.arrow_forward, size: 16),
              ),
              Text(shipment.arrivalCity, style: AppTypography.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${shipment.items.length} items • ${Formatters.weight(shipment.totalWeight)}',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
