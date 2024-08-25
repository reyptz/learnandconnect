import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId; // Firebase UID
  String email;
  String passwordHash; // Utilisé seulement si vous stockez le mot de passe localement
  String Name;
  String role; // Enum: "apprenant", "formateur", "administrateur"
  String profilePictureUrl;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime lastLogin;

  User({
    required this.userId,
    required this.email,
    required this.passwordHash,
    required this.Name,
    required this.role,
    required this.profilePictureUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.lastLogin,
  });

  // Méthodes pour convertir vers et depuis Firestore
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return User(
      userId: doc.id,
      email: data['email'],
      passwordHash: data['password_hash'] ?? '',
      Name: data['name'],
      role: data['role'],
      profilePictureUrl: data['profile_picture_url'] ?? '',
      isActive: data['is_active'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      lastLogin: (data['last_login'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'password_hash': passwordHash,
      'name': Name,
      'role': role,
      'profile_picture_url': profilePictureUrl,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_login': lastLogin,
    };
  }
}

class ActivityLog {
  String action;
  Map<String, dynamic> metadata;
  DateTime createdAt;

  ActivityLog({
    required this.action,
    required this.metadata,
    required this.createdAt,
  });

  factory ActivityLog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ActivityLog(
      action: data['action'],
      metadata: Map<String, dynamic>.from(data['metadata']),
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'action': action,
      'metadata': metadata,
      'created_at': createdAt,
    };
  }
}