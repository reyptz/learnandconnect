import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/services/firebase_messaging_service.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les services Flutter sont initialisés
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialiser Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Demander les permissions de notification
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Utilisateur autorisé à recevoir des notifications');
  } else {
    print('Notifications non autorisées');
  }

  String? token = await messaging.getToken(
    vapidKey: "21PE-MHbqNpgvJClXVgr-V8QQcnMqz5ttqFC0DKbEfU",
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // Initialiser le service de gestion des notifications
  MyFirebaseMessagingService.configureFirebaseMessaging();



  runApp(MyApp()); // Démarrer l'application après l'initialisation de Firebase
}

// Fonction de rappel pour gérer les notifications reçues en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// Méthode pour stocker le token FCM dans Firestore
void storeUserToken(String userId) async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'fcm_token': token,
    });
  }
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
