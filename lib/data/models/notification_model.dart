import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String notificationId; // Firestore Auto-generated ID
  String userId; // Reference to users/user_id
  String ticketId; // Reference to tickets/ticket_id
  String notificationText;
  String notificationType; // Enum: "Push", "Email"
  bool isRead;
  DateTime createdAt;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.ticketId,
    required this.notificationText,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Notification(
      notificationId: doc.id,
      userId: data['user_id'],
      ticketId: data['ticket_id'],
      notificationText: data['notification_text'],
      notificationType: data['notification_type'],
      isRead: data['is_read'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'ticket_id': ticketId,
      'notification_text': notificationText,
      'notification_type': notificationType,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }
}
