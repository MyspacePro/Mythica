import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> sendMessage({
  required String chatId,
  required String senderId,
  required String text,
  required List<String> members,
}) async {

  final chatRef =
      FirebaseFirestore.instance.collection('chats').doc(chatId);

  // Add message
  await chatRef.collection('messages').add({
    'senderId': senderId,
    'text': text,
    'timestamp': FieldValue.serverTimestamp(),
  });

  // Update unread count
  final chatSnap = await chatRef.get();
  Map<String, dynamic> unread =
      Map<String, dynamic>.from(chatSnap['unreadCount']);

  for (var user in members) {
    if (user != senderId) {
      unread[user] = (unread[user] ?? 0) + 1;
    }
  }

  await chatRef.update({
    'unreadCount': unread,
    'lastMessage.text': text,
    'lastMessage.timestamp': FieldValue.serverTimestamp(),
  });
}