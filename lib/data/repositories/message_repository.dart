import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart'; // Importez le modèle Message

class MessageRepository {
  // La collection des messages se trouve dans les sous-collections des chats
  CollectionReference getMessageCollection(String chatId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');
  }

  // Récupérer un message par son ID
  Future<Message?> getMessageById(String chatId, String messageId) async {
    try {
      DocumentSnapshot doc =
      await getMessageCollection(chatId).doc(messageId).get();
      if (doc.exists) {
        return Message.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting message: $e');
    }
    return null;
  }

  // Créer un nouveau message
  Future<void> createMessage(String chatId, Message message) async {
    try {
      await getMessageCollection(chatId).add(message.toFirestore());
    } catch (e) {
      print('Error creating message: $e');
    }
  }

  // Mettre à jour un message
  Future<void> updateMessage(String chatId, Message message) async {
    try {
      await getMessageCollection(chatId)
          .doc(message.messageId)
          .update(message.toFirestore());
    } catch (e) {
      print('Error updating message: $e');
    }
  }

  // Supprimer un message
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await getMessageCollection(chatId).doc(messageId).delete();
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  // Récupérer tous les messages pour un chat spécifique
  Future<List<Message>> getMessagesByChatId(String chatId) async {
    try {
      QuerySnapshot snapshot =
      await getMessageCollection(chatId).orderBy('sent_at').get();
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting messages: $e');
      return [];
    }
  }
}
