import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  String ticketId; // Firestore Auto-generated ID
  String userId; // Reference to users/user_id
  String categoryId; // Reference to categories/category_id
  String title;
  String description;
  String status; // Enum: "Attente", "En cours", "Résolu"
  String priority; // Enum: "Basse", "Moyenne", "Haute"
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? resolvedAt; // Nullable
  String? assignedTo; // Reference to users/user_id (nullable)

  Ticket({
    required this.ticketId,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.assignedTo,
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Ticket(
      ticketId: doc.id,
      userId: data['user_id'],
      categoryId: data['category_id'],
      title: data['title'],
      description: data['description'],
      status: data['status'],
      priority: data['priority'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      resolvedAt: data['resolved_at'] != null
          ? (data['resolved_at'] as Timestamp).toDate()
          : null,
      assignedTo: data['assigned_to'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'resolved_at': resolvedAt,
      'assigned_to': assignedTo,
    };
  }
}

class Response {
  String responderId; // Reference to users/user_id
  String responseText;
  DateTime createdAt;
  DateTime updatedAt;

  Response({
    required this.responderId,
    required this.responseText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Response.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Response(
      responderId: data['responder_id'],
      responseText: data['response_text'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'responder_id': responderId,
      'response_text': responseText,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
