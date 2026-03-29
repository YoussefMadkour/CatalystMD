import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'supabase_provider.dart';

/// Current user auth state stream.
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final client = ref.watch(supabaseClientProvider);

  return client.auth.onAuthStateChange.asyncMap((event) async {
    final session = event.session;
    if (session == null) return null;

    final userId = session.user.id;
    final data = await client.from('users').select().eq('id', userId).maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  });
});

/// Synchronous access to current user (nullable).
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
