enum MessageType { text, image, audio }

enum MessageStatus { sent, delivered, seen }

class Message {
  final String id;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;

  final bool isSeen;
  final MessageStatus status;

  // 🔥 Reply Support
  final String? replyToMessageId;
  final String? replyToText;
  final String? replyToSenderId;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.replyToMessageId,
    this.replyToText,
    this.replyToSenderId,
    this.isSeen = false,
    this.status = MessageStatus.sent,
  });

  /// 🔥 Proper copyWith (NO ERROR)
  Message copyWith({
    String? id,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isSeen,
    MessageStatus? status,
    String? replyToMessageId,
    String? replyToText,
    String? replyToSenderId,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isSeen: isSeen ?? this.isSeen,
      status: status ?? this.status,
      replyToMessageId:
          replyToMessageId ?? this.replyToMessageId,
      replyToText: replyToText ?? this.replyToText,
      replyToSenderId:
          replyToSenderId ?? this.replyToSenderId,
    );
  }
}