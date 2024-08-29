import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription avec rôle par défaut
  Future<firebase_auth.User?> signUp(String email, String password, String Name, String role) async {
    try {
      firebase_auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = userCredential.user;

      // Créer un document utilisateur dans Firestore après l'inscription
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': Name,
          'role': role, // Stocke le rôle ici
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Connexion
  Future<firebase_auth.User?> signIn(String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Récupérer l'utilisateur actuellement connecté
  firebase_auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Obtenir l'ID de l'utilisateur actuellement connecté
  String? getCurrentUserId() {
    final user = _firebaseAuth.currentUser;
    return user?.uid;
  }

  // Récupérer les données utilisateur depuis Firestore
  Future<DocumentSnapshot> getUserData() async {
    firebase_auth.User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    throw Exception('Aucun utilisateur connecté');
  }

  // Envoi du lien de réinitialisation du mot de passe
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Impossible d\'envoyer l\'email de réinitialisation. Veuillez réessayer.');
    }
  }
}
