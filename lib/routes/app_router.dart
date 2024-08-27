import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'route_paths.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/tickets/ticket_list_screen.dart';
import '../presentation/screens/tickets/ticket_detail_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/profile/settings_screen.dart';
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
        return _redirectBasedOnAuth(currentUser, HomeScreen());
      case RoutePaths.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutePaths.signUp:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case RoutePaths.tickets:
        return _authGuard(currentUser, TicketListScreen());
      case RoutePaths.ticketDetail:
        final ticketId = settings.arguments as String;
        return _authGuard(currentUser, TicketDetailScreen(ticketId: ticketId));
      case RoutePaths.profile:
        return _authGuard(currentUser, ProfileScreen());
      case RoutePaths.notifications:
        return _authGuard(currentUser, NotificationsScreen());
      case RoutePaths.settings:
        return _authGuard(currentUser, SettingsScreen());
      default:
        return _errorRoute();
    }
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

  Route<dynamic> _redirectBasedOnAuth(firebase_auth.User? currentUser, Widget screen) {
    if (currentUser != null) {
      return MaterialPageRoute(builder: (_) => screen);
    } else {
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
