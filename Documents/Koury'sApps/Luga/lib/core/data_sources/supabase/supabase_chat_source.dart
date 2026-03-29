import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/message_model.dart';
import '../../repositories/chat_repository.dart';

class SupabaseChatSource implements ChatRepository {
  SupabaseChatSource(this._client);
  final SupabaseClient _client;

  @override
  Stream<List<MessageModel>> watchMessages(String conversationId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((rows) => rows.map((e) => MessageModel.fromJson(e)).toList());
  }

  @override
  Future<MessageModel> sendMessage(MessageModel message) async {
    // Messages go through Edge Function for filtering
    final data = await _client.functions.invoke('send-message', body: message.toJson());
    return MessageModel.fromJson(data.data as Map<String, dynamic>);
  }

  @override
  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    return await _client.from('conversations').select().or('user1_id.eq.$userId,user2_id.eq.$userId').order('updated_at', ascending: false);
  }

  @override
  Future<String> getOrCreateConversation(String userId1, String userId2, String bookingId) async {
    // TODO: Implement conversation creation
    throw UnimplementedError();
  }

  @override
  Future<void> markAsRead(String conversationId, String userId) async {
    await _client.from('messages').update({'is_read': true}).eq('conversation_id', conversationId).neq('sender_id', userId);
  }

  @override
  Stream<int> watchUnreadCount(String userId) {
    // TODO: Implement unread count stream
    throw UnimplementedError();
  }
}
