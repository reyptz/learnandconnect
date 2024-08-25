import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository = AuthRepository();

  // Inscription
  Future<User?> signUp(String email, String password) async {
    return await _authRepository.signUp(email, password);
  }

  // Connexion
  Future<User?> signIn(String email, String password) async {
    return await _authRepository.signIn(email, password);
  }

  // Déconnexion
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  // Récupérer l'utilisateur actuellement connecté
  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  // Réinitialisation du mot de passe
  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }
}
