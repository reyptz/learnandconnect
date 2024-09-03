import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthSignIn>(_onSignIn);
    on<AuthSignUp>(_onSignUp);
    on<AuthForgotPassword>(_onForgotPassword);
  }

  // Gestionnaire d'événement pour AuthSignIn
  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final firebase_auth.User? user = await _authService.signIn(event.email, event.password);
      if (user != null) {
        // Récupérer les données utilisateur depuis Firestore après la connexion
        final userData = await _authService.getUserData2(user.uid);
        final role = userData['role'] ?? 'Apprenant';

        // Redirection basée sur le rôle
        if (role == 'Admin') {
          emit(AuthRedirectToDashboard(user: user));
        } else {
          emit(AuthRedirectToHome(user: user));
        }
      } else {
        emit(AuthFailure(message: 'Connexion échouée. Veuillez vérifier vos identifiants.'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  // Gestionnaire d'événement pour AuthSignUp avec rôle par défaut
  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final firebase_auth.User? user = await _authService.signUp(event.email, event.password, event.name, event.role);
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthFailure(message: 'Inscription échouée. Veuillez réessayer.'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  // Gestionnaire pour AuthForgotPassword
  Future<void> _onForgotPassword(AuthForgotPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.sendPasswordResetEmail(event.email);
      emit(PasswordResetSuccess()); // Utilisez l'état spécifique pour la réinitialisation du mot de passe
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<firebase_auth.User?> signUp(String email, String password, String name, String role) async {
    try {
      // Création de l'utilisateur avec Firebase Authentication
      firebase_auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupérer l'utilisateur
      firebase_auth.User? user = userCredential.user;

      if (user != null) {
        // Ajouter les informations utilisateur à Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': role,
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      return null;
    }
  }

  Future<firebase_auth.User?> signIn(String email, String password) async {
    try {
      firebase_auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Erreur lors de la réinitialisation du mot de passe: $e');
      throw e;
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    firebase_auth.User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      return await _firestore.collection('users').doc(currentUser.uid).get();
    } else {
      throw Exception("Utilisateur non connecté.");
    }
  }

  firebase_auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
