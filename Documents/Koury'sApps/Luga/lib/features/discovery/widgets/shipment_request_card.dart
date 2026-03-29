import 'package:flutter/material.dart';

import '../../../core/models/shipment_model.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/luga_card.dart';
import '../../../core/widgets/luga_reward_bar.dart';

class ShipmentRequestCard extends StatelessWidget {
  const ShipmentRequestCard({super.key, required this.shipment});
  final ShipmentModel shipment;

  @override
  Widget build(BuildContext context) {
    return LugaCard(
      onTap: () { /* TODO: Navigate to shipment detail or offer */ },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${shipment.departureCity} → ${shipment.arrivalCity}', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('${shipment.items.length} items • ${Formatters.weight(shipment.totalWeight)}', style: AppTypography.bodySmall),
          const SizedBox(height: AppSpacing.xs),
          LugaRewardBar(rewardText: 'Earn ${Formatters.currency(shipment.totalValue * 0.1)} commission'),
        ],
      ),
    );
  }
}
