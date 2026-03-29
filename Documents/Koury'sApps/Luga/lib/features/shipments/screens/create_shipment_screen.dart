import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../providers/create_shipment_notifier.dart';

class CreateShipmentScreen extends ConsumerWidget {
  const CreateShipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create shipment')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            // TODO: Multi-step form with cart
            const Expanded(child: Center(child: Text('Shipment creation form'))),
            LugaButton(
              label: 'Submit',
              onPressed: () {
                // TODO: Submit shipment
              },
            ),
          ],
        ),
      ),
    );
  }
}
