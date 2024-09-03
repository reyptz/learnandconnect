import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String ticketId; // Firestore Auto-generated ID
  String userId; // Reference to users/user_id
  String category; // Reference to categories/category
  String title;
  String description;
  String status; // Enum: "Attente", "En cours", "Résolu"
  String priority; // Enum: "Basse", "Moyenne", "Haute"
  DateTime createdAt;
  DateTime updatedAt;
  String? assignedTo; // Reference to users/user_id (nullable)

  Ticket({
    required this.ticketId,
    required this.userId,
    required this.category,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Ticket(
      ticketId: doc.id,
      userId: data['user_id'],
      category: data['category'],
      title: data['title'],
      description: data['description'],
      status: data['status'],
      priority: data['priority'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      assignedTo: data['assigned_to'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'category': category,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'assigned_to': assignedTo,
    };
  }
}

class Response {
  String responderId; // Reference to users/user_id
  String responseText;
  DateTime createdAt;

  Response({
    required this.responderId,
    required this.responseText,
    required this.createdAt,
  });

  factory Response.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Response(
      responderId: data['responder_id'],
      responseText: data['response_text'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'responder_id': responderId,
      'response_text': responseText,
      'created_at': createdAt,
    };
  }
}

class TicketHistory {
  String status; // Enum: "Attente", "En cours", "Résolu"
  String changedBy; // Reference to users/user_id
  DateTime changedAt;

  TicketHistory({
    required this.status,
    required this.changedBy,
    required this.changedAt,
  });

  factory TicketHistory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TicketHistory(
      status: data['status'],
      changedBy: data['changed_by'],
      changedAt: (data['changed_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'status': status,
      'changed_by': changedBy,
      'changed_at': changedAt,
    };
  }
}

class Chat {
  String chatId; // Firestore Auto-generated ID
  String messageText;
  DateTime sentAt;
  String senderName;

  Chat({
    required this.chatId,
    required this.messageText,
    required this.sentAt,
    required this.senderName,
  });

  // Convertir un DocumentSnapshot Firestore en instance de Message
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Chat(
      chatId: data['chat_id'] ?? '',
      messageText: data['message_text'] ?? '',
      sentAt: (data['sent_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderName: data['sender_name'] ?? '',
    );
  }

  /// Méthode pour créer une instance de Message à partir d'une Map (généralement extraite de Firestore)
  factory Chat.fromMap(Map<String, dynamic> data) {
    return Chat(
      chatId: data['chat_id'] ?? '',
      messageText: data['message_text'] ?? '',
      sentAt: (data['sent_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      senderName: data['sender_name'] ?? '',
    );
  }

  // Convertir une instance de Message en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'chat_id': chatId,
      'message_text': messageText,
      'sent_at': sentAt,
      'sender_name': senderName,
    };
  }
}