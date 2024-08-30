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
  String password; // Utilisé seulement si vous stockez le mot de passe localement
  String Name;
  Role role; // Enum: "apprenant", "formateur", "administrateur"
  DateTime createdAt;
  DateTime lastLogin;

  User({
    required this.userId,
    required this.email,
    required this.password,
    required this.Name,
    required this.role,
    required this.createdAt,
    required this.lastLogin,
  });

  // Ajout de la méthode copyWith
  User copyWith({
    String? userId,
    String? Name,
    Role? role,
    String? email,
    String? password,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      userId: userId ?? this.userId,
      Name: Name ?? this.Name,
      role: role ?? this.role,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  // Méthode pour convertir un DocumentSnapshot Firestore en instance de User
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      userId: doc.id,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      Name: data['name'] ?? '',
      role: _stringToRole(data['role']),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (data['last_login'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Méthode pour convertir une instance de User en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'password': password,
      'name': Name,
      'role': _roleToString(role),
      'created_at': createdAt,
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