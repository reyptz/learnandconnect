import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart'; // Importez le modèle User

class UserRepository {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // Récupérer un utilisateur par son ID
  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(userId).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  // Créer un nouvel utilisateur
  Future<void> createUser(User user) async {
    try {
      await userCollection.doc(user.userId).set(user.toFirestore());
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  // Mettre à jour un utilisateur
  Future<void> updateUser(User user) async {
    try {
      await userCollection.doc(user.userId).update(user.toFirestore());
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Supprimer un utilisateur
  Future<void> deleteUser(String userId) async {
    try {
      await userCollection.doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
