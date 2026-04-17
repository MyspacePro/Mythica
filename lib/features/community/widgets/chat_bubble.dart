import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message_model.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String currentUserId;

  /// For scroll-to-message highlight
  final bool isHighlighted;

  /// Callback when reply preview tapped
  final Function(String)? onReplyTap;

  /// Callback for delete (optional)
  final Function(String)? onDelete;

  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.isHighlighted = false,
    this.onReplyTap,
    this.onDelete,
  });

  bool get isMe => message.senderId == currentUserId;

  String formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final bubbleContent = _buildBubble(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isHighlighted
            ? Colors.deepPurple.withValues(alpha:0.2)
            : Colors.transparent,
      ),
      child: Align(
        alignment:
            isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () => _showOptions(context),
          child: bubbleContent,
        ),
      ),
    );
  }

  Widget _buildBubble(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 270),
            padding: message.type == MessageType.text
                ? const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10)
                : const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(0xFF6C63FF)
                  : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isMe
                    ? const Radius.circular(16)
                    : const Radius.circular(4),
                bottomRight: isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                if (message.replyToMessageId != null)
                  _buildReplyPreview(),

                _buildMessageContent(),

                const SizedBox(height: 4),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatTime(message.timestamp),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      _buildStatusIcon(),
                    ],
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    return GestureDetector(
      onTap: () {
        if (onReplyTap != null &&
            message.replyToMessageId != null) {
          onReplyTap!(message.replyToMessageId!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha:0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message.replyToText ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (message.type == MessageType.image) {
      if (message.content.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.content,
            height: 180,
            width: 220,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(message.content),
            height: 180,
            width: 220,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return Text(
      message.content,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sent:
        return const Icon(
          Icons.check,
          size: 16,
          color: Colors.grey,
        );

      case MessageStatus.delivered:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: Colors.grey,
        );

      case MessageStatus.seen:
        return const Icon(
          Icons.done_all,
          size: 16,
          color: Colors.blue,
        );
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.copy, color: Colors.white),
              title: const Text(
                "Copy",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: message.content));
                Navigator.pop(context);
              },
            ),
            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete,
                    color: Colors.red),
                title: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (onDelete != null) {
                    onDelete!(message.id);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}