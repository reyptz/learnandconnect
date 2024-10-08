import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      int id,
      String title,
      String body) async {

    var androidDetails = AndroidNotificationDetails(
      'channelId', // Premier argument positionnel
      'channelName', // Deuxième argument positionnel
      channelDescription: 'channelDescription', // Argument nommé
      importance: Importance.high, // Autres paramètres comme des arguments nommés
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      generalNotificationDetails,
    );
  }

  // Configurer les paramètres initiaux des notifications
  static Future<void> initializeNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
    AndroidInitializationSettings('app_icon'); // Icône de notification
    var initializationSettings =
    InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
