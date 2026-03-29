import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_empty_state.dart';
import '../../../core/widgets/luga_avatar.dart';
import '../../../core/theme/app_typography.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch conversations from provider
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const LugaEmptyState(
        title: 'No messages yet',
        message: 'Your conversations will appear here after a booking',
      ),
    );
  }
}
