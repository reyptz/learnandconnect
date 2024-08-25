import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chatId; // Firestore Auto-generated ID
  DateTime createdAt;
  DateTime lastMessageAt;

  Chat({
    required this.chatId,
    required this.createdAt,
    required this.lastMessageAt,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Chat(
      chatId: doc.id,
      createdAt: (data['created_at'] as Timestamp).toDate(),
      lastMessageAt: (data['last_message_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'created_at': createdAt,
      'last_message_at': lastMessageAt,
    };
  }
}

class Message {
  String senderId; // Reference to users/user_id
  String messageText;
  DateTime sentAt;
  List<String> attachments; // List of URLs

  Message({
    required this.senderId,
    required this.messageText,
    required this.sentAt,
    required this.attachments,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
      senderId: data['sender_id'],
      messageText: data['message_text'],
      sentAt: (data['sent_at'] as Timestamp).toDate(),
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sender_id': senderId,
      'message_text': messageText,
      'sent_at': sentAt,
      'attachments': attachments,
    };
  }
}
