import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../widgets/booking_status_timeline.dart';
import '../widgets/escrow_status_chip.dart';

class ActiveBookingScreen extends ConsumerWidget {
  const ActiveBookingScreen({super.key, required this.bookingId});
  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active booking')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: const [
            EscrowStatusChip(status: 'held'),
            SizedBox(height: AppSpacing.lg),
            BookingStatusTimeline(),
            // TODO: Booking details, actions
          ],
        ),
      ),
    );
  }
}
