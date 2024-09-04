import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static initNotification() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static showLocalNotification(String title, String body, String payload) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      '0', 'general',
      priority: Priority.high,
      importance: Importance.high,
      autoCancel: false,
      fullScreenIntent: true,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification Title
      body, // Notification Body
      platformDetails, // Platform-specific Notification Details
      payload: payload, // Data payload for the notification
    );
  }

  static Future<void> initFCM() async {
    // Demander la permission pour les notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted.');
    } else {
      print('Notification permission denied.');
    }

    // Gérer les notifications reçues en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu alors que l\'app est en premier plan: ${message.notification?.title}');
      if (message.notification != null) {
        NotificationService.showLocalNotification(
          message.notification!.title!,
          message.notification!.body!,
          '',
        );
      }
    });

    // Gérer les notifications lorsque l'app est en arrière-plan ou relancée
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message cliqué! ${message.notification?.title}');
      // Rediriger l'utilisateur vers l'écran approprié
    });

    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
      // Vous pouvez traiter les messages ici et les afficher si nécessaire
      print("Handling a background message: ${message.messageId}");
    }
  }

  static  AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  static Future<void> sendPushMessage(String token, String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AIzaSyCC_EUmLHyx15so3hWiyM5Zj2iSFf4r2Z8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'to': token,
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
            },
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'ticket_id': 'ticket_id',
            },
          },
        ),
      );
      print('FCM request for device sent!');
      print('Response: ${response.body}');
    } catch (e) {
      print('Error sending FCM message: $e');
    }
  }
}
