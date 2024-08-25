import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart'; // Importez le modèle Notification

class NotificationRepository {
  final CollectionReference notificationCollection =
  FirebaseFirestore.instance.collection('notifications');

  // Récupérer une notification par son ID
  Future<Notification?> getNotificationById(String notificationId) async {
    try {
      DocumentSnapshot doc = await notificationCollection.doc(notificationId).get();
      if (doc.exists) {
        return Notification.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting notification: $e');
    }
    return null;
  }

  // Créer une nouvelle notification
  Future<void> createNotification(Notification notification) async {
    try {
      await notificationCollection.add(notification.toFirestore());
    } catch (e) {
      print('Error creating notification: $e');
    }
  }

  // Mettre à jour une notification
  Future<void> updateNotification(Notification notification) async {
    try {
      await notificationCollection
          .doc(notification.notificationId)
          .update(notification.toFirestore());
    } catch (e) {
      print('Error updating notification: $e');
    }
  }

  // Supprimer une notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await notificationCollection.doc(notificationId).delete();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Récupérer toutes les notifications pour un utilisateur
  Future<List<Notification>> getNotificationsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await notificationCollection
          .where('user_id', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => Notification.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting notifications: $e');
      return [];
    }
  }

  // Marquer une notification comme lue
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await notificationCollection.doc(notificationId).update({'is_read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}
