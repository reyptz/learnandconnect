import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class UserService {
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await userCollection.get();
      return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des utilisateurs: $e');
    }
  }

  Future<void> addUser(User user) async {
    try {
      await userCollection.add(user.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await userCollection.doc(user.userId).update(user.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await userCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur: $e');
    }
  }
}
