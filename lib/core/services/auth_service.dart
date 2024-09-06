import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart'; // Importer Firebase Messaging
import '../../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Instance de Firebase Messaging

  // Méthode pour stocker le token FCM de l'utilisateur
  void storeUserToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _firestore.collection('users').doc(userId).update({
        'fcm_token': token,
      });
    }
  }

  // Inscription avec rôle par défaut
  Future<firebase_auth.User?> signUp(String email, String password, String Name, String role) async {
    try {
      firebase_auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebase_auth.User? user = userCredential.user;

      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
          'fcm_token': token,
        });
      }

      // Créer un document utilisateur dans Firestore après l'inscription
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': Name,
          'role': role, // Stocke le rôle ici
          'created_at': FieldValue.serverTimestamp(),
          'fcm_token': token, // Stocker le token FCM
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
      firebase_auth.User? user = userCredential.user;

      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
          'fcm_token': token,
        });
      }

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

  Future<Map<String, dynamic>> getUserData2(String userId) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
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
