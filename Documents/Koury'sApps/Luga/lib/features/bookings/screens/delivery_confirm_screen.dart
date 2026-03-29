import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../widgets/photo_proof_uploader.dart';

class DeliveryConfirmScreen extends ConsumerWidget {
  const DeliveryConfirmScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm delivery')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            const PhotoProofUploader(label: 'Photo of delivered items'),
            const Spacer(),
            LugaButton(label: 'Confirm delivery', onPressed: () { /* TODO */ }),
          ],
        ),
      ),
    );
  }
}
