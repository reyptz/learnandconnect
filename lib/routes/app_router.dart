import 'package:flutter/material.dart';
import 'route_paths.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/tickets/ticket_list_screen.dart';
import '../presentation/screens/tickets/ticket_detail_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/notifications/notifications_screen.dart';
import '../presentation/screens/profile/settings_screen.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/tickets':
        return MaterialPageRoute(builder: (_) => TicketListScreen());
      case '/ticket-detail':
        final ticketId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => TicketDetailScreen(ticketId: ticketId));
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => NotificationsScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return _errorRoute();
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
