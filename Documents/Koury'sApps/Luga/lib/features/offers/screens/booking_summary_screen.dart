import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/price_breakdown_card.dart';
import '../../bookings/widgets/guarantee_badge.dart';

class BookingSummaryScreen extends ConsumerWidget {
  const BookingSummaryScreen({super.key, required this.offerId});
  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking summary')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review your booking', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.lg),
            // TODO: Price breakdown card with real data
            const SizedBox(height: AppSpacing.md),
            const GuaranteeBadge(),
            const SizedBox(height: AppSpacing.lg),
            Text('Before you proceed', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            // TODO: Trust gate checklist
            const Spacer(),
            LugaButton(
              label: 'Confirm & Pay',
              onPressed: () {
                // TODO: Hold escrow and create booking
              },
            ),
          ],
        ),
      ),
    );
  }
}
