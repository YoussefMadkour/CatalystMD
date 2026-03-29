import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch trip by ID
    return Scaffold(
      appBar: AppBar(title: const Text('Trip details')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Center(child: Text('Trip detail placeholder')),
      ),
    );
  }
}
