import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Inscription d'un utilisateur avec email et mot de passe
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during sign up: $e');
      return null;
    }
  }

  // Connexion d'un utilisateur avec email et mot de passe
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      throw Exception('Failed to sign out');
    }
  }

  // Récupérer l'utilisateur actuellement connecté
  User? getCurrentUser() {
    try {
      return _firebaseAuth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Réinitialiser le mot de passe d'un utilisateur
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error during password reset: $e');
      throw Exception('Failed to send password reset email');
    }
  }
}
