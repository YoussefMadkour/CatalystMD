import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';

class ShipmentDetailScreen extends ConsumerWidget {
  const ShipmentDetailScreen({super.key, required this.shipmentId});
  final String shipmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shipment details')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Center(child: Text('Shipment detail placeholder')),
      ),
    );
  }
}
