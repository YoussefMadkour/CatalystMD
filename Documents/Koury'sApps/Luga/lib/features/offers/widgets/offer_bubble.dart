import 'package:flutter/material.dart';

import '../../../core/models/offer_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';

class OfferBubble extends StatelessWidget {
  const OfferBubble({super.key, required this.offer, required this.isFromCurrentUser});
  final OfferModel offer;
  final bool isFromCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs, horizontal: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isFromCurrentUser ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Formatters.currency(offer.amount), style: AppTypography.titleLarge),
            if (offer.message != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Text(offer.message!, style: AppTypography.bodySmall),
            ],
            const SizedBox(height: AppSpacing.xxs),
            Text('Round ${offer.round} • ${Formatters.relativeTime(offer.createdAt)}',
                style: AppTypography.labelSmall),
          ],
        ),
      ),
    );
  }
}
