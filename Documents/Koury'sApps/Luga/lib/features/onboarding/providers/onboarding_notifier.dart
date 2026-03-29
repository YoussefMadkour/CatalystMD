import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_model.dart';

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<void>>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<AsyncValue<void>> {
  OnboardingNotifier() : super(const AsyncData(null));

  Future<void> setupProfile({
    required String name,
    String? avatarPath,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // TODO: Upload avatar, update user profile
    });
  }

  Future<void> submitKyc(String inquiryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // TODO: Verify KYC status with Persona
    });
  }
}
