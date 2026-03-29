import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../widgets/shipment_request_card.dart';

class ShipmentFeedScreen extends ConsumerWidget {
  const ShipmentFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipment Requests')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: 0, // TODO: From provider
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => const SizedBox(), // TODO: ShipmentRequestCard
      ),
    );
  }
}
