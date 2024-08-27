import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chatId; // Firestore Auto-generated ID
  DateTime createdAt;
  DateTime lastMessageAt;
  List<Message> messages; // Liste des messages associés à ce chat

  Chat({
    required this.chatId,
    required this.createdAt,
    required this.lastMessageAt,
    required this.messages,
  });

// Convertir un DocumentSnapshot Firestore en instance de Chat
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    var messagesData = data['messages'] as List<dynamic>? ?? [];

    return Chat(
      chatId: doc.id,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessageAt: (data['last_message_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      messages: messagesData.map((messageData) => Message.fromMap(messageData)).toList(),
    );
  }

  // Convertir une instance de Chat en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'created_at': createdAt,
      'last_message_at': lastMessageAt,
      'messages': messages.map((message) => message.toMap()).toList(),
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

  // Convertir un DocumentSnapshot Firestore en instance de Message
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      senderId: data['sender_id'] ?? '',
      messageText: data['message_text'] ?? '',
      sentAt: (data['sent_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  /// Méthode pour créer une instance de Message à partir d'une Map (généralement extraite de Firestore)
  factory Message.fromMap(Map<String, dynamic> data) {
    return Message(
      senderId: data['sender_id'] ?? '',
      messageText: data['message_text'] ?? '',
      sentAt: (data['sent_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  // Convertir une instance de Message en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'message_text': messageText,
      'sent_at': sentAt,
      'attachments': attachments,
    };
  }
}
