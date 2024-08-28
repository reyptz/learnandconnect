import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

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
        final userData = await _authService.getUserData();
        emit(AuthSuccess(user: user, userData: userData.data()));
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

}
