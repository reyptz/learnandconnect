import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String messageId; // Firestore Auto-generated ID
  String senderId; // Reference to users/user_id
  String messageText;
  DateTime sentAt;
  List<String> attachments; // List of URLs for attachments

  Message({
    required this.messageId,
    required this.senderId,
    required this.messageText,
    required this.sentAt,
    required this.attachments,
  });

  // Factory method to create a Message instance from Firestore data
  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
      messageId: doc.id,
      senderId: data['sender_id'],
      messageText: data['message_text'],
      sentAt: (data['sent_at'] as Timestamp).toDate(),
      attachments: List<String>.from(data['attachments'] ?? []),
    );
  }

  // Method to convert a Message instance to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'sender_id': senderId,
      'message_text': messageText,
      'sent_at': sentAt,
      'attachments': attachments,
    };
  }
}
