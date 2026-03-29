import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';

class SupabaseAuthSource implements AuthRepository {
  SupabaseAuthSource(this._client);

  final SupabaseClient _client;

  @override
  Future<void> sendOtp(String phone) async {
    await _client.auth.signInWithOtp(phone: phone);
  }

  @override
  Future<UserModel> verifyOtp(String phone, String otp) async {
    final response = await _client.auth.verifyOTP(
      phone: phone,
      token: otp,
      type: OtpType.sms,
    );
    final userId = response.user!.id;
    final data = await _client.from('users').select().eq('id', userId).single();
    return UserModel.fromJson(data);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<UserModel?> authStateChanges() {
    // TODO: Implement auth state stream
    throw UnimplementedError();
  }

  @override
  UserModel? get currentUser {
    // TODO: Implement current user getter
    throw UnimplementedError();
  }
}
