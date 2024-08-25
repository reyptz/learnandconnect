import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/utils/date_utils.dart';

enum Role {
  apprenant,
  formateur,
  administrateur,
}

class User {
  String userId; // Firebase UID
  String email;
  String passwordHash; // Utilisé seulement si vous stockez le mot de passe localement
  String Name;
  Role role; // Enum: "apprenant", "formateur", "administrateur"
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

  // Ajout de la méthode copyWith
  User copyWith({
    String? userId,
    String? Name,
    Role? role,
    String? profilePictureUrl,
    String? email,
    String? passwordHash,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastLogin,
  }) {
    return User(
      userId: userId ?? this.userId,
      Name: Name ?? this.Name,
      role: role ?? this.role,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  // Méthode pour convertir un DocumentSnapshot Firestore en instance de User
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      userId: doc.id,
      email: data['email'] ?? '',
      passwordHash: data['password_hash'] ?? '',
      Name: data['name'] ?? '',
      role: _stringToRole(data['role']),
      profilePictureUrl: data['profile_picture_url'] ?? '',
      isActive: data['is_active'] ?? false,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (data['last_login'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Méthode pour convertir une instance de User en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'password_hash': passwordHash,
      'name': Name,
      'role': _roleToString(role),
      'profile_picture_url': profilePictureUrl,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_login': lastLogin,
    };
  }
  static String _roleToString(Role role) {
    return role.toString().split('.').last;
  }

  static Role _stringToRole(String roleString) {
    return Role.values.firstWhere((role) => role.toString().split('.').last == roleString);
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

  // Méthode pour convertir un DocumentSnapshot Firestore en instance de ActivityLog
  factory ActivityLog.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ActivityLog(
      action: data['action'] ?? '',
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Méthode pour convertir une instance de ActivityLog en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'action': action,
      'metadata': metadata,
      'created_at': createdAt,
    };
  }

  String getFormattedDate() {
    return DateUtils.formatDate(createdAt);
  }
}