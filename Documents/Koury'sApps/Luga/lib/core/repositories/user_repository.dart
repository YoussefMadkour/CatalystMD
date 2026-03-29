import '../models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser(String id);
  Future<UserModel> updateProfile(UserModel user);
  Future<String> uploadAvatar(String userId, String filePath);
  Future<void> deleteAccount(String userId);
}
