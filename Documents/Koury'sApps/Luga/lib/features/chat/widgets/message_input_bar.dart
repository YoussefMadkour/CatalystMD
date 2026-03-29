import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/message_filter.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({super.key, required this.onSend});
  final ValueChanged<String> onSend;

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final _controller = TextEditingController();
  bool _hasOffPlatform = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasOffPlatform)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              color: AppColors.warning.withValues(alpha: 0.15),
              child: const Text('Sharing contact info outside Luga is not allowed'),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none),
                  onChanged: (text) {
                    setState(() {
                      _hasOffPlatform = MessageFilter.containsOffPlatformContact(text);
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: _hasOffPlatform
                    ? null
                    : () {
                        if (_controller.text.trim().isNotEmpty) {
                          widget.onSend(_controller.text.trim());
                          _controller.clear();
                        }
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
