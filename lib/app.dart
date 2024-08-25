import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './routes/app_router.dart';
import './core/constants/app_themes.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_state.dart';

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          // Gérer la déconnexion ou les erreurs d'authentification globales
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      },
      child: MaterialApp(
        title: 'Gestion de Tickets',
        theme: AppThemes.lightTheme,  // Utilise le thème clair défini dans app_themes.dart
        darkTheme: AppThemes.darkTheme,  // Utilise le thème sombre
        themeMode: ThemeMode.system,  // Change automatiquement entre clair et sombre
        initialRoute: '/login',  // Définit la route initiale de l'application
        onGenerateRoute: _appRouter.generateRoute,  // Utilise AppRouter pour générer les routes
      ),
    );
  }
}
