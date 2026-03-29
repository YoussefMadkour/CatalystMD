import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/dispute_model.dart';

final disputeNotifierProvider = StateNotifierProvider<DisputeNotifier, AsyncValue<void>>((ref) {
  return DisputeNotifier();
});

class DisputeNotifier extends StateNotifier<AsyncValue<void>> {
  DisputeNotifier() : super(const AsyncData(null));

  Future<void> submitDispute(DisputeModel dispute) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // TODO: Submit via DisputeRepository
    });
  }
}
