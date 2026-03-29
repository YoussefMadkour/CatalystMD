import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';

class HandoffScreen extends ConsumerWidget {
  const HandoffScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Handoff')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Center(child: Text('Handoff screen placeholder')),
      ),
    );
  }
}
