import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';

class TripStepRoute extends ConsumerWidget {
  const TripStepRoute({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Column(
        children: [
          // TODO: Departure/arrival city pickers
          const Expanded(child: Center(child: Text('Route step'))),
          LugaButton(label: 'Next', onPressed: onNext),
        ],
      ),
    );
  }
}
