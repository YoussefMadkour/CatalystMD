import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';
import '../../../core/widgets/luga_text_field.dart';

class DisputeScreen extends ConsumerWidget {
  const DisputeScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open dispute')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            // TODO: Reason dropdown, description, photo evidence
            const LugaTextField(label: 'Describe the issue', maxLines: 5),
            const Spacer(),
            LugaButton(label: 'Submit dispute', onPressed: () { /* TODO */ }),
          ],
        ),
      ),
    );
  }
}
