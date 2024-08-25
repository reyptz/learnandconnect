import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class RoleService {
  final CollectionReference roleCollection =
  FirebaseFirestore.instance.collection('roles');

  Future<List<Role>> getRoles() async {
    try {
      QuerySnapshot snapshot = await roleCollection.get();
      return snapshot.docs
          .map((doc) => _stringToRole(doc['role']))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des rôles: $e');
    }
  }

  Future<void> addRole(Role role) async {
    try {
      await roleCollection.add({'role': _roleToString(role)});
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du rôle: $e');
    }
  }

  Future<void> updateRole(Role oldRole, Role newRole) async {
    try {
      QuerySnapshot snapshot = await roleCollection
          .where('role', isEqualTo: _roleToString(oldRole))
          .get();
      if (snapshot.docs.isNotEmpty) {
        await roleCollection
            .doc(snapshot.docs.first.id)
            .update({'role': _roleToString(newRole)});
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du rôle: $e');
    }
  }

  Future<void> deleteRole(Role role) async {
    try {
      QuerySnapshot snapshot =
      await roleCollection.where('role', isEqualTo: _roleToString(role)).get();
      if (snapshot.docs.isNotEmpty) {
        await roleCollection.doc(snapshot.docs.first.id).delete();
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression du rôle: $e');
    }
  }

  String _roleToString(Role role) {
    return role.toString().split('.').last;
  }

  Role _stringToRole(String roleString) {
    return Role.values.firstWhere((role) => role.toString().split('.').last == roleString);
  }
}
