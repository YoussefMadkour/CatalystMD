import '../models/message_model.dart';

abstract class ChatRepository {
  Stream<List<MessageModel>> watchMessages(String conversationId);
  Future<MessageModel> sendMessage(MessageModel message);
  Future<List<Map<String, dynamic>>> getConversations(String userId);
  Future<String> getOrCreateConversation(String userId1, String userId2, String bookingId);
  Future<void> markAsRead(String conversationId, String userId);
  Stream<int> watchUnreadCount(String userId);
}
