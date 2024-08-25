import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/message_repository.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';

class ChatService {
  final ChatRepository _chatRepository = ChatRepository();
  final MessageRepository _messageRepository = MessageRepository();

  // Créer un nouveau chat
  Future<void> createChat(Chat chat) async {
    await _chatRepository.createChat(chat);
  }

  // Récupérer un chat par ID
  Future<Chat?> getChatById(String chatId) async {
    return await _chatRepository.getChatById(chatId);
  }

  // Ajouter un message à un chat
  Future<void> addMessage(String chatId, Message message) async {
    await _messageRepository.createMessage(chatId, message);
  }

  // Récupérer tous les messages d'un chat
  Future<List<Message>> getMessagesByChatId(String chatId) async {
    return await _messageRepository.getMessagesByChatId(chatId);
  }

  // Supprimer un message dans un chat
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _messageRepository.deleteMessage(chatId, messageId);
  }
}
