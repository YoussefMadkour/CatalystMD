import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'luga_button.dart';

class DraftRecoveryDialog extends StatelessWidget {
  const DraftRecoveryDialog({
    super.key,
    required this.draftType,
    required this.lastSaved,
    required this.onRecover,
    required this.onDiscard,
  });

  final String draftType;
  final DateTime lastSaved;
  final VoidCallback onRecover;
  final VoidCallback onDiscard;

  static Future<bool?> show(
    BuildContext context, {
    required String draftType,
    required DateTime lastSaved,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => DraftRecoveryDialog(
        draftType: draftType,
        lastSaved: lastSaved,
        onRecover: () => Navigator.of(context).pop(true),
        onDiscard: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Resume draft?'),
      content: Text(
        'You have an unsaved $draftType draft. Would you like to continue where you left off?',
      ),
      actions: [
        LugaButton(
          label: 'Discard',
          variant: LugaButtonVariant.ghost,
          onTap: onDiscard,
          expand: false,
        ),
        const SizedBox(width: AppSpacing.xs),
        LugaButton(
          label: 'Resume',
          onTap: onRecover,
          expand: false,
        ),
      ],
    );
  }
}
