import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/services/MyFirebaseMessagingService.dart';
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
import 'package:learnandconnect/core/services/MyFirebaseMessagingService.dart';


Future<void> main() async {
  // Assurez-vous que tous les services Flutter sont initialisés correctement
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisez Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialiser Firebase Messaging et le service MyFirebaseMessagingService
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  try {
    await MyFirebaseMessagingService.initLocalNotification();
  } catch (e) {
    print('Erreur lors de l\'initialisation des notifications: $e');
  }

  // Gérer les messages reçus en premier plan
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Message reçu en premier plan');
    MyFirebaseMessagingService().handleForegroundMessage(message);
  });

  // Gérer les messages en arrière-plan
  FirebaseMessaging.onBackgroundMessage(MyFirebaseMessagingService.onBackgroundMessage);

  // Demander les permissions pour recevoir les notifications sur l'appareil
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('L\'utilisateur a autorisé les notifications');
  } else {
    print('Notifications non autorisées');
  }

  // Obtenir le token FCM de l'utilisateur
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Initialiser les notifications locales
  NotificationService.initNotification();

  // Exécuter l'application Flutter
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(      
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(create: (context) => TicketBloc(TicketService())),
        BlocProvider(create: (context) => ProfileBloc(userRepository: FirestoreService())),
        BlocProvider(create: (context) => NotificationBloc(NotificationService())),
      ],
      child: App(),
    );
  }
}
