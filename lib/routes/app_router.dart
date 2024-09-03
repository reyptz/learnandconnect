import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnandconnect/presentation/screens/tickets/ticket_chat_screen.dart';
import '../presentation/screens/auth/password_reset_confirmation_screen.dart';
import '../presentation/screens/auth/forgot_password_screen.dart';
import '../presentation/screens/home/dashboard_screen.dart';
import '../presentation/screens/users/report_generation_screen.dart';
import '../presentation/screens/tickets/ticket_create_screen.dart';
import '../presentation/screens/tickets/ticket_edit_screen.dart';
import '../presentation/screens/tickets/ticket_history_screen.dart';
import '../presentation/screens/tickets/ticket_reply_screen.dart';
import '../presentation/screens/tickets/ticket_reponse_screen.dart';
import '../presentation/screens/users/users_screen.dart';
import 'route_paths.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/tickets/ticket_list_screen.dart';
import '../presentation/screens/tickets/ticket_detail_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AppRouter {
  final AuthService _authService = AuthService();

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Récupération de l'utilisateur Firebase actuellement connecté
    final firebase_auth.User? currentUser = _authService.getCurrentUser();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<String?>(
            future: _getUserRole(currentUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return LoginScreen();
              }

              final role = snapshot.data ?? '';

              if (role == 'Admin') {
                return DashboardScreen();
              } else {
                return HomeScreen();
              }
            },
          ),
        );
      case RoutePaths.login:
        // Rediriger les utilisateurs authentifiés vers la page d'accueil
        return _redirectIfAuthenticated(currentUser);
      case RoutePaths.signUp:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RoutePaths.forgot:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case RoutePaths.resetpassword:
        return MaterialPageRoute(builder: (_) => PasswordResetConfirmationScreen());
      case RoutePaths.tickets:
        return _authGuard(currentUser, TicketListScreen());
      case RoutePaths.ticketCreate:
        return _authGuard(currentUser, CreateTicketScreen());
      case RoutePaths.ticketDetail:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, TicketDetailScreen(ticketId: ticketId));
      case RoutePaths.ticketEdit:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, EditTicketScreen(ticketId: ticketId));
      case RoutePaths.ticketReponse:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, ReponseTicketScreen(ticketId: ticketId));
      case RoutePaths.ticketHistory:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, HistoryTicketsScreen(ticketId: ticketId));
      case RoutePaths.ticketReply:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, TicketReplyScreen(ticketId: ticketId));
      case RoutePaths.chat:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, ChatScreen(ticketId: ticketId));
      case RoutePaths.profile:
        return _authGuard(currentUser, ProfileScreen());
      case RoutePaths.report:
        return _authGuard(currentUser, ReportsScreen());
      case RoutePaths.dashboard:
        return _authGuard(currentUser, DashboardScreen());
      case RoutePaths.users:
        return _authGuard(currentUser, UsersScreen());
      case RoutePaths.notifications:
        return _authGuard(currentUser, NotificationsScreen());
      default:
        return _errorRoute();
    }
  }

  //Méthode pour obtenir le rôle de l'utilisateur actuel depuis Firestore.
  Future<String?> _getUserRole(firebase_auth.User? user) async {
    if (user == null) {
      print("Aucun utilisateur connecté");
      return null;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      print("Document utilisateur introuvable pour l'ID: ${user.uid}");
      return null;
    }

    final role = doc.data()?['role'] ?? 'User';
    print("Rôle récupéré: $role");
    return role;
  }

  // Vérification de l'authentification pour protéger les routes
  Route<dynamic> _authGuard(firebase_auth.User? currentUser, Widget screen) {
    if (currentUser != null) {
      return MaterialPageRoute(builder: (_) => screen);
    } else {
      // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }

  // Rediriger les utilisateurs authentifiés
  Route<dynamic> _redirectIfAuthenticated(firebase_auth.User? currentUser) {
    if (currentUser != null) {
      // Rediriger vers la page d'accueil si l'utilisateur est authentifié
      return MaterialPageRoute(builder: (_) => HomeScreen());
    } else {
      // Si l'utilisateur n'est pas connecté, permettre l'accès à la page de connexion
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: Text('Erreur')),
        body: Center(child: Text('Page non trouvée')),
      ),
    );
  }
}
