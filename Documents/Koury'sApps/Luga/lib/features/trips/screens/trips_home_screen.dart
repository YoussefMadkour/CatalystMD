import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/luga_empty_state.dart';
import '../providers/trips_provider.dart';
import '../widgets/trip_card.dart';

class TripsHomeScreen extends ConsumerWidget {
  const TripsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: tripsAsync.when(
        data: (trips) {
          if (trips.isEmpty) {
            return const LugaEmptyState(
              title: 'No trips yet',
              message: 'Post your first trip to start earning',
              ctaLabel: 'Post a trip',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            itemCount: trips.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => TripCard(trip: trips[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to post trip
        },
        label: const Text('Post trip'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
