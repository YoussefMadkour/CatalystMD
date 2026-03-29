import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../widgets/photo_proof_uploader.dart';

class PickupConfirmScreen extends ConsumerWidget {
  const PickupConfirmScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm pickup')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            const PhotoProofUploader(label: 'Take a photo of the items'),
            const Spacer(),
            LugaButton(label: 'Confirm pickup', onPressed: () { /* TODO */ }),
          ],
        ),
      ),
    );
  }
}
