import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:learnandconnect/core/services/MyFirebaseMessagingService.dart';

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialiser les notifications locales
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

  /*static Future<void> sendPushNotificationWithV1(String fcmToken, String title, String body) async {
    var serviceAccount = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "learnandconnect-f984c",
      "private_key_id": "a61e531f8c2302797988fc315e9aa5e1d2622f1a",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4SEuTgim82vru\n7W0GREos/A4pf5+AZBJegHKZbCv0a5kNh034LZ8tfjRC3YtT8KGMswPYbgbsse44\nT8HKMMElk0Rfqhb2SxftHJX/cMk+n9H1Xc/aHiTqw/TYMhnWmqvPLq2X4oEgr0RN\nPdnmqNokgBJCBZOemlKekVNzk/5Pj6g37c6lvrPYHuUNE1QUdP8qkv3/+x24fj3C\n1R85532NpHGzbqqgdinVo5jbCrSUQ332SRhMuXY9vzUdUUtDiNUVMFm+HzSbsGZy\nS06Ul9v9IdKWW28Fm2U/4jUKtugopnh86OxscrAFVfq7KllLx6Ekq+sW+ugaiX7Z\n4tRfnbw9AgMBAAECggEAAe+7Nj5Ek1ghvD0BIPMQFyTsPoIOz689hNdeB5VcE4zF\n5knTsetDeZuSj66loNODKb1VKa24+OfDFGhneukZk9GBAxhVzBoXPZtH9Y/egtVJ\nxDBLgi6Vk2SiarCBa6s4aaGYmril7rf+Gb8FTn0xEvfIOVVhqxBSv0PRAq09cOHm\n9SWkinB9EpqThn//0G7N5o1XCiSTznjrKh7My6+o8qcV/5nD1u37lzMo3P4XaSWh\naB2+Nek2iOpeVvD3XtimVEfwufL81Om3IUjZauR0wUOUc6cUC+iyYRHntI6xTL5L\nc92FAlk+Z/oLQoS1l2NClr2m4DlGGfE4gvDnVqKuwQKBgQD6+A7CievTf7i/n+vc\n1PGCYP/8TeJc2dL3wEYUWj5xzFExwzfMeOXwEfQVdUXpr3HO3Gc77JI3zF/j1Sw+\nPG1ep6bAsncCxcbPRP5JnTAx1Ih4X2V2fuZzA8wkNmphfi8+wJ5UliuPdHXf7ZLu\n/hGbDnpjEQQ4hcFfASJ6WMbLtQKBgQC7+gKaFICIdUbfY2sBH89x3+ml8i1XZzJ4\nrNNZQKMcPjcA+/MsNUJ2yNvZlT5SvEjtpXloBybUkzxnWMJNSIZVHyAlmgNZxZnG\nooc+jp+OQj9/rFryNiLfPTg5jEhdvLUbsIe6VVEB4MEptg9R+x4eIARSij6uYrnU\nct29FDbTaQKBgD+hNNzN6ySsdULgYQSUWMcdoMlvVb0E3SBDd4EhgEOJ8ewT+sm0\nvVeotaHbIealvM0dxG7FBC1xe75gBd+honklOHoSxWnGiylx7KbtW5LGt/MM/MSW\nWAdBJzjnMwGU5JWccIgxqsmsVVZ4/Y/qirwtZ4pGfjN2dhiISR2L9JshAoGAOt14\n8R1YfuMS9aOhf7Ghecyf03q6XjOP56BfcwS9z3tgKCu+I+rtzFrsFgAZizkxMVJv\naXdL3qfY85glCKSchI2BuKS5ReSOWljNN3bcWmU+k1G7DTyMwRHfyI24n7oXkPtA\nFcbf3lGuy8wakhasgMyP7fUi2eNKxE/QRoTNAnkCgYEAhHzroeboMlIPadMYnedz\nsBY1HOWMV52RquEMjvV4PPmWPVXlyfQI4anSduZNXFCrBBd1NpQexsYRMTiGA5zi\nZZXgMD1H1GsEIT6UF2SWzhTE59C3W4nLOmrwslR7MMY6Yw0bxLshuFQLOYdjHvEZ\nozEKfq4IdtkJniCrsVMWmpo=\n-----END PRIVATE KEY-----\n",
      "client_email": "learnandconnect-f984c@appspot.gserviceaccount.com",
      "client_id": "581137144396-t0fa9cj0hbpuv9tc7i0kf9t43h76elu8.apps.googleusercontent.com",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/learnandconnect-f984c%40appspot.gserviceaccount.com"
    });

    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    await clientViaServiceAccount(serviceAccount, scopes).then((AuthClient client) async {
      var url = 'https://fcm.googleapis.com/v1/projects/learnandconnect-f984c/messages:send';

      var response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "message": {
            "token": fcmToken,
            "notification": {
              "title": title,
              "body": body,
            },
          }
        }),
      );

      print('FCM request sent! Response: ${response.body}');
    }).catchError((e) {
      print('Error sending FCM message: $e');
    });
  }*/
}
