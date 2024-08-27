import 'package:equatable/equatable.dart';
import '../../data/models/chat_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String chatId;

  const LoadMessages({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final Message message;

  const SendMessage({required this.chatId, required this.message});

  @override
  List<Object> get props => [chatId, message];
}

class ReceiveMessage extends ChatEvent {
  final Message message;

  const ReceiveMessage({required this.message});

  @override
  List<Object> get props => [message];
}

class ListenToMessages extends ChatEvent {
  final String chatId;

  const ListenToMessages({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

class StopListeningToMessages extends ChatEvent {
  const StopListeningToMessages();
}