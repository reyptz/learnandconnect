import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/chat_repository.dart';
import 'package:learnandconnect/data/models/chat_model.dart';

class ChatService {
  final CollectionReference chatCollection = FirebaseFirestore.instance.collection('chats');

  /// Créer un nouveau chat
  Future<void> createChat(Chat chat) async {
    try {
      await chatCollection.add(chat.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la création du chat: $e');
    }
  }

  /// Récupérer un chat par son ID
  Future<Chat?> getChatById(String chatId) async {
    try {
      DocumentSnapshot doc = await chatCollection.doc(chatId).get();
      return doc.exists ? Chat.fromFirestore(doc) : null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du chat: $e');
    }
  }

  /// Ajouter un message à un chat
  Future<void> addMessage(String chatId, Message message) async {
    try {
      DocumentSnapshot doc = await chatCollection.doc(chatId).get();
      if (doc.exists) {
        Chat chat = Chat.fromFirestore(doc);
        chat.messages.add(message);
        chat.lastMessageAt = message.sentAt;
        await chatCollection.doc(chatId).update(chat.toFirestore());
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du message: $e');
    }
  }

  /// Récupérer tous les messages d'un chat
  Future<List<Message>> getMessagesByChatId(String chatId) async {
    try {
      DocumentSnapshot doc = await chatCollection.doc(chatId).get();
      if (doc.exists) {
        Chat chat = Chat.fromFirestore(doc);
        return chat.messages;
      } else {
        throw Exception('Le chat n\'existe pas.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des messages: $e');
    }
  }

  /// Supprimer un message dans un chat
  Future<void> deleteMessage(String chatId, int messageIndex) async {
    try {
      DocumentSnapshot doc = await chatCollection.doc(chatId).get();
      if (doc.exists) {
        Chat chat = Chat.fromFirestore(doc);
        chat.messages.removeAt(messageIndex);
        await chatCollection.doc(chatId).update(chat.toFirestore());
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression du message: $e');
    }
  }

  /// Écouter les nouveaux messages en temps réel
  Stream<List<Message>> listenToMessages(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection('messages')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
    });
  }
}
