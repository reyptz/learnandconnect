import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/ticket/ticket_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/notification/notification_bloc.dart';
import './core/services/auth_service.dart';
import './core/services/ticket_service.dart';
import './core/services/firestore_service.dart';
import './core/services/notification_service.dart';
import './core/services/DataLoader.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Un message en arrière-plan a été reçu: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les services Flutter sont initialisés
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /* Créer une instance du DataLoaderService
  final dataLoaderService = DataLoaderService();

  try {
    // Charger les données initiales
    await dataLoaderService.loadData();
  } catch (e) {
    print('Erreur lors du chargement des données: $e');
    // Vous pouvez afficher une alerte ou un écran d'erreur ici si nécessaire
  } */
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp()); // Démarrer l'application après l'initialisation de Firebase
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(create: (context) => TicketBloc(TicketService())),
        BlocProvider(create: (context) => ProfileBloc(FirestoreService())),
        BlocProvider(create: (context) => NotificationBloc(NotificationService())),
      ],
      child: App(),
    );
  }
}
