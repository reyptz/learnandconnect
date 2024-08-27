import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';
import '../../data/models/chat_model.dart';

class ChatWidget extends StatefulWidget {
  final String chatId;

  const ChatWidget({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Charger les messages au début
    BlocProvider.of<ChatBloc>(context).add(LoadMessages(chatId: widget.chatId));
    // Écouter les messages en temps réel
    BlocProvider.of<ChatBloc>(context).add(ListenToMessages(chatId: widget.chatId));
  }

  @override
  void dispose() {
    // Arrêter l'écoute des messages lorsqu'on quitte l'écran
    BlocProvider.of<ChatBloc>(context).add(StopListeningToMessages());
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ChatLoaded) {
                return ListView.builder(
                  reverse: true, // Affiche les messages du plus récent au plus ancien
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return _buildMessageTile(message);
                  },
                );
              } else if (state is ChatError) {
                return Center(child: Text('Erreur: ${state.message}'));
              } else {
                return Center(child: Text('Aucun message disponible.'));
              }
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageTile(Message message) {
    return ListTile(
      title: Text(message.senderId), // Remplacez par le nom de l'utilisateur si possible
      subtitle: Text(message.messageText),
      trailing: Text(
        message.sentAt.toLocal().toString(), // Formattez cette date selon vos besoins
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Entrez votre message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final message = Message(
        senderId: 'currentUserId', // Remplacez par l'ID de l'utilisateur actuel
        messageText: messageText,
        sentAt: DateTime.now(),
        attachments: [], // Gérez les pièces jointes si nécessaire
      );
      BlocProvider.of<ChatBloc>(context).add(SendMessage(chatId: widget.chatId, message: message));
      _messageController.clear();
    }
  }
}
