import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

class SupabaseUserSource implements UserRepository {
  SupabaseUserSource(this._client);

  final SupabaseClient _client;

  @override
  Future<UserModel> getUser(String id) async {
    final data = await _client.from('users').select().eq('id', id).single();
    return UserModel.fromJson(data);
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    final data = await _client
        .from('users')
        .update(user.toJson())
        .eq('id', user.id)
        .select()
        .single();
    return UserModel.fromJson(data);
  }

  @override
  Future<String> uploadAvatar(String userId, String filePath) async {
    final path = 'avatars/$userId.jpg';
    await _client.storage.from('avatars').upload(path, java.io.File(filePath));
    return _client.storage.from('avatars').getPublicUrl(path);
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await _client.from('users').delete().eq('id', userId);
  }
}
