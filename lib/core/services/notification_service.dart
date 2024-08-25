import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/models/notification_model.dart';

class NotificationService {
  final NotificationRepository _notificationRepository = NotificationRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final CollectionReference notificationCollection = FirebaseFirestore.instance.collection('notifications');

  // Demander la permission pour les notifications push
  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission();
  }

  // Envoyer une notification (Push)
  Future<void> sendPushNotification(Notification notification) async {
    // Logique pour envoyer une notification push via Firebase Cloud Messaging
    // ou utiliser des services tiers comme OneSignal ou Firebase Cloud Functions
    await _notificationRepository.createNotification(notification);
  }

  // Envoyer une notification par email
  Future<void> sendEmailNotification(Notification notification) async {
    // Logique pour envoyer des emails via un service comme SendGrid
    await _notificationRepository.createNotification(notification);
  }

  // Récupérer les notifications d'un utilisateur
  Future<List<Notification>> getNotificationsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await notificationCollection
          .where('user_id', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => Notification.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des notifications: $e');
    }
  }

  // Marquer une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await notificationCollection.doc(notificationId).update({'is_read': true});
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la notification: $e');
    }
  }

  Future<void> updateNotification(Notification notification) async {
    try {
      await notificationCollection
          .doc(notification.notificationId)
          .update(notification.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la notification: $e');
    }
  }
}
