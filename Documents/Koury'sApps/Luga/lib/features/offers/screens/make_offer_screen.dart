import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/price_calculator.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_text_field.dart';
import '../../../core/widgets/price_breakdown_card.dart';
import '../providers/offer_notifier.dart';

class MakeOfferScreen extends ConsumerStatefulWidget {
  const MakeOfferScreen({super.key, required this.shipmentId, required this.tripId});
  final String shipmentId;
  final String tripId;

  @override
  ConsumerState<MakeOfferScreen> createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends ConsumerState<MakeOfferScreen> {
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  PriceBreakdown? _breakdown;

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _updateBreakdown(String value) {
    final amount = double.tryParse(value);
    if (amount != null) {
      setState(() {
        _breakdown = PriceCalculator.calculate(
          itemPrice: amount,
          category: 'other', // TODO: Use actual category
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make an offer')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: ListView(
          children: [
            Text('Item summary', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            // TODO: Show item summary from shipment
            LugaTextField(
              label: 'Your offer amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
              prefix: const Icon(Icons.attach_money),
              onChanged: _updateBreakdown,
            ),
            const SizedBox(height: AppSpacing.md),
            if (_breakdown != null) PriceBreakdownCard(breakdown: _breakdown!),
            const SizedBox(height: AppSpacing.md),
            LugaTextField(
              label: 'Message (optional)',
              controller: _messageController,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xl),
            LugaButton(
              label: 'Send offer',
              onPressed: () {
                // TODO: Submit offer via notifier
              },
            ),
          ],
        ),
      ),
    );
  }
}
