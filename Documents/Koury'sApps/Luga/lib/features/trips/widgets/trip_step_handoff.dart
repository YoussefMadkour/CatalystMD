import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';

class TripStepHandoff extends ConsumerWidget {
  const TripStepHandoff({super.key, required this.onSubmit});
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        children: [
          // TODO: Handoff method selection
          const Expanded(child: Center(child: Text('Handoff step'))),
          LugaButton(label: 'Post trip', onPressed: onSubmit),
        ],
      ),
    );
  }
}
