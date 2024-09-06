import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class MyFirebaseMessagingService {
  // Instance de FlutterLocalNotificationsPlugin pour gérer les notifications locales
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialiser les paramètres de notifications locales
  static Future<void> initLocalNotification() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon'); // Utiliser une icône personnalisée

      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      print('Notification locale initialisée avec succès.');
    } catch (e) {
      print('Erreur lors de l\'initialisation des notifications locales: $e');
    }
  }

  // Gérer les messages lorsque l'application est au premier plan
  Future<void> handleForegroundMessage(RemoteMessage message) async {
    print("Message reçu en premier plan: ${message.notification?.title}");
    _showNotification(message.notification?.title, message.notification?.body);
  }

  // Afficher une notification locale
  void _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('channel_id', 'channel_name',
        importance: Importance.max, priority: Priority.high, showWhen: false);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notification
      title, // Titre de la notification
      body, // Corps de la notification
      platformChannelSpecifics, // Paramètres de la notification
    );
  }

  // Gérer les messages reçus en arrière-plan
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
