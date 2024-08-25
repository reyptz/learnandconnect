/*class Role {
  String roleId; // Firestore Auto-generated ID
  String roleName;
  String description;
  DateTime createdAt;

  Role({
    required this.roleId,
    required this.roleName,
    required this.description,
    required this.createdAt,
  });

  factory Role.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Role(
      roleId: doc.id,
      roleName: data['role_name'],
      description: data['description'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role_name': roleName,
      'description': description,
      'created_at': createdAt,
    };
  }
}
*/