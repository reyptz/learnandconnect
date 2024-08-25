import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart'; // Importez le modèle Category

class CategoryRepository {
  final CollectionReference categoryCollection =
  FirebaseFirestore.instance.collection('categories');

  // Récupérer une catégorie par son ID
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      DocumentSnapshot doc = await categoryCollection.doc(categoryId).get();
      if (doc.exists) {
        return Category.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting category: $e');
    }
    return null;
  }

  // Créer une nouvelle catégorie
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection.add(category.toFirestore());
    } catch (e) {
      print('Error creating category: $e');
    }
  }

  // Mettre à jour une catégorie
  Future<void> updateCategory(Category category) async {
    try {
      await categoryCollection.doc(category.categoryId).update(category.toFirestore());
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  // Supprimer une catégorie
  Future<void> deleteCategory(String categoryId) async {
    try {
      await categoryCollection.doc(categoryId).delete();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  // Récupérer toutes les catégories
  Future<List<Category>> getAllCategories() async {
    try {
      QuerySnapshot snapshot = await categoryCollection.get();
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }
}
