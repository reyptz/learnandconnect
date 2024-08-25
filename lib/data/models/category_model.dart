import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String categoryId; // Firestore Auto-generated ID
  String categoryName;
  String description;
  DateTime createdAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.createdAt,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Category(
      categoryId: doc.id,
      categoryName: data['category_name'],
      description: data['description'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category_name': categoryName,
      'description': description,
      'created_at': createdAt,
    };
  }
}
