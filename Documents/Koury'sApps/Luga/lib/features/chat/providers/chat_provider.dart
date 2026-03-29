import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/message_model.dart';

final chatMessagesProvider = StreamProvider.family<List<MessageModel>, String>(
  (ref, conversationId) {
    // TODO: Watch messages from ChatRepository
    return const Stream.empty();
  },
);

final unreadCountProvider = StreamProvider<int>((ref) {
  // TODO: Watch unread count
  return const Stream.empty();
});
