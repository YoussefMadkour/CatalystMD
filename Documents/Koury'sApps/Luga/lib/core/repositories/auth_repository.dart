import '../models/user_model.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String phone);
  Future<UserModel> verifyOtp(String phone, String otp);
  Future<void> signOut();
  Stream<UserModel?> authStateChanges();
  UserModel? get currentUser;
}
