import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data_sources/supabase/supabase_auth_source.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/supabase_provider.dart';
import '../../../core/repositories/auth_repository.dart';

/// Auth state with loading, error, lockout, and OTP tracking.
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.otpSent = false,
    this.failedAttempts = 0,
    this.lockedUntil,
  });

  final UserModel? user;
  final bool isLoading;
  final String? error;
  final bool otpSent;
  final int failedAttempts;
  final DateTime? lockedUntil;

  bool get isLocked =>
      lockedUntil != null && DateTime.now().isBefore(lockedUntil!);

  Duration get lockoutRemaining => isLocked
      ? lockedUntil!.difference(DateTime.now())
      : Duration.zero;

  static const maxAttempts = 3;
  static const lockoutDuration = Duration(minutes: 5);

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool? otpSent,
    int? failedAttempts,
    DateTime? lockedUntil,
    bool clearError = false,
    bool clearUser = false,
    bool clearLock = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      otpSent: otpSent ?? this.otpSent,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: clearLock ? null : (lockedUntil ?? this.lockedUntil),
    );
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthNotifier(SupabaseAuthSource(client));
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repo) : super(const AuthState());

  final AuthRepository _repo;

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repo.sendOtp(phone);
      state = state.copyWith(isLoading: false, otpSent: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _mapError(e),
      );
    }
  }

  Future<UserModel?> verifyOtp(String phone, String otp) async {
    if (state.isLocked) {
      final minutes = state.lockoutRemaining.inMinutes + 1;
      state = state.copyWith(
        error: 'Too many attempts. Try again in $minutes min.',
      );
      return null;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repo.verifyOtp(phone, otp);
      state = state.copyWith(
        isLoading: false,
        user: user,
        failedAttempts: 0,
        clearLock: true,
      );
      return user;
    } catch (e) {
      final attempts = state.failedAttempts + 1;
      final locked = attempts >= AuthState.maxAttempts;
      state = state.copyWith(
        isLoading: false,
        failedAttempts: attempts,
        lockedUntil: locked
            ? DateTime.now().add(AuthState.lockoutDuration)
            : null,
        error: locked
            ? 'Too many failed attempts. Locked for 5 minutes.'
            : 'Invalid code. Please try again.',
      );
      return null;
    }
  }

  Future<void> resendOtp(String phone) async {
    state = state.copyWith(clearError: true);
    await sendOtp(phone);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState();
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Please check and try again.';
    }
    if (msg.contains('rate') || msg.contains('limit')) {
      return 'Too many requests. Please wait a moment.';
    }
    return 'Something went wrong. Please try again.';
  }
}
