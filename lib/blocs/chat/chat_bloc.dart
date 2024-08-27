import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../../core/services/chat_service.dart';
import '../../data/models/chat_model.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  StreamSubscription<List<Message>>? _messageSubscription;

  ChatBloc(this._chatService) : super(ChatInitial());

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is LoadMessages) {
      yield ChatLoading();
      try {
        final messages = await _chatService.getMessagesByChatId(event.chatId);
        yield ChatLoaded(messages: messages);
      } catch (e) {
        yield ChatError(message: e.toString());
      }
    } else if (event is SendMessage) {
      try {
        await _chatService.addMessage(event.chatId, event.message);
      } catch (e) {
        yield ChatError(message: e.toString());
      }
    } else if (event is ListenToMessages) {
      await _listenToMessages(event.chatId);
    } else if (event is StopListeningToMessages) {
      await _stopListeningToMessages();
    }
  }

  Future<void> _listenToMessages(String chatId) async {
    await _messageSubscription?.cancel(); // Annuler l'abonnement précédent, s'il existe
    _messageSubscription = _chatService.listenToMessages(chatId).listen((messages) {
      add(LoadMessages(chatId: chatId)); // Recharger les messages en cas de nouvelle mise à jour
    });
  }

  Future<void> _stopListeningToMessages() async {
    await _messageSubscription?.cancel(); // Annuler l'abonnement actuel, s'il existe
  }

  @override
  Future<void> close() {
    _stopListeningToMessages(); // Arrêter l'écoute des messages lors de la fermeture du bloc
    return super.close();
  }
}
