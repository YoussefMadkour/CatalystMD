import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_button.dart';

class OfferActionBar extends StatelessWidget {
  const OfferActionBar({super.key, this.onAccept, this.onCounter, this.onDecline});
  final VoidCallback? onAccept;
  final VoidCallback? onCounter;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: LugaButton(
              label: 'Decline',
              variant: LugaButtonVariant.ghost,
              onPressed: onDecline,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: LugaButton(
              label: 'Counter',
              variant: LugaButtonVariant.secondary,
              onPressed: onCounter,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: LugaButton(
              label: 'Accept',
              onPressed: onAccept,
            ),
          ),
        ],
      ),
    );
  }
}
