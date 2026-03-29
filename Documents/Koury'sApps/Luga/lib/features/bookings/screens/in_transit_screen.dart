import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../widgets/booking_status_timeline.dart';

class InTransitScreen extends ConsumerWidget {
  const InTransitScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('In transit')),
      body: const Padding(
        padding: EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            BookingStatusTimeline(),
            SizedBox(height: AppSpacing.lg),
            Center(child: Text('Your items are on their way!', style: AppTypography.headlineSmall)),
          ],
        ),
      ),
    );
  }
}
