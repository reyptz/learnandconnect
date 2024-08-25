import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart'; // Importez le modèle Chat

class ChatRepository {
  final CollectionReference chatCollection =
  FirebaseFirestore.instance.collection('chats');

  // Récupérer un chat par son ID
  Future<Chat?> getChatById(String chatId) async {
    try {
      DocumentSnapshot doc = await chatCollection.doc(chatId).get();
      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting chat: $e');
    }
    return null;
  }

  // Créer un nouveau chat
  Future<void> createChat(Chat chat) async {
    try {
      await chatCollection.add(chat.toFirestore());
    } catch (e) {
      print('Error creating chat: $e');
    }
  }

  // Mettre à jour un chat
  Future<void> updateChat(Chat chat) async {
    try {
      await chatCollection.doc(chat.chatId).update(chat.toFirestore());
    } catch (e) {
      print('Error updating chat: $e');
    }
  }

  // Supprimer un chat
  Future<void> deleteChat(String chatId) async {
    try {
      await chatCollection.doc(chatId).delete();
    } catch (e) {
      print('Error deleting chat: $e');
    }
  }

  // Récupérer tous les chats pour un utilisateur
  Future<List<Chat>> getChatsByUserId(String userId) async {
    try {
      QuerySnapshot snapshot = await chatCollection
          .where('participants', arrayContains: userId)
          .get();
      return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting chats: $e');
      return [];
    }
  }
}
