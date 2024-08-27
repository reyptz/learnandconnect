import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthSignIn>(_onSignIn);
  }

  // Gestionnaire d'événement pour AuthSignIn
  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final firebase_auth.User? user = await _authService.signIn(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess(user: user));
      } else {
        emit(AuthFailure(message: 'Connexion échouée. Veuillez vérifier vos identifiants.'));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
