import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input_bar.dart';
import '../widgets/pre_payment_gate_banner.dart';

class ConversationScreen extends ConsumerWidget {
  const ConversationScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          const PrePaymentGateBanner(),
          const Expanded(
            child: Center(child: Text('Messages')),
            // TODO: ListView of MessageBubble from stream
          ),
          MessageInputBar(
            onSend: (text) {
              // TODO: Send message via provider
            },
          ),
        ],
      ),
    );
  }
}
