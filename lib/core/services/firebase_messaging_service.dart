import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class MyFirebaseMessagingService {
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  static void configureFirebaseMessaging() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demander les permissions pour les notifications
    messaging.requestPermission(alert: true, badge: true, sound: true);

    // Gestion des messages en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu en premier plan : ${message.notification?.title}');
      if (message.notification != null) {
        _showNotification(message.notification!.title!, message.notification!.body!);
      }
    });

    // Gestion des messages lorsqu'ils sont cliqués
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification cliquée : ${message.notification?.title}');
    });

    // Gestion des messages en arrière-plan
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  static void _showNotification(String title, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id', 'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecifics, payload: 'data');
  }
}
