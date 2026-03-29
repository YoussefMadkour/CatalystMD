import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_empty_state.dart';
import '../providers/shipments_provider.dart';
import '../widgets/shipment_card.dart';

class ShipmentsHomeScreen extends ConsumerWidget {
  const ShipmentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(shipmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Shipments')),
      body: shipmentsAsync.when(
        data: (shipments) {
          if (shipments.isEmpty) {
            return const LugaEmptyState(
              title: 'No shipments yet',
              message: 'Create a shipment request to find a traveler',
              ctaLabel: 'Create shipment',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            itemCount: shipments.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => ShipmentCard(shipment: shipments[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create shipment
        },
        label: const Text('New shipment'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
