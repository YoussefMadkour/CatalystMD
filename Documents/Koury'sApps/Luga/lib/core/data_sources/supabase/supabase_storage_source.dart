import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageSource {
  SupabaseStorageSource(this._client);
  final SupabaseClient _client;

  Future<String> uploadImage({
    required String bucket,
    required String path,
    required File file,
  }) async {
    await _client.storage.from(bucket).upload(path, file);
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  Future<void> deleteImage({
    required String bucket,
    required String path,
  }) async {
    await _client.storage.from(bucket).remove([path]);
  }
}
