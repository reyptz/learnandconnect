import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/chat/chat_state.dart';
import '../../../data/models/chat_model.dart';

class ChatScreen extends StatelessWidget {
  final String chatId; // L'identifiant du chat auquel cet écran est associé
  final String currentUserId; // L'ID de l'utilisateur actuel (pour différencier les messages)

  ChatScreen({
    Key? key,
    required this.chatId,
    required this.currentUserId,
  }) : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Charger à nouveau les messages
              BlocProvider.of<ChatBloc>(context).add(LoadMessages(chatId: chatId));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    reverse: true,
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
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageTile(Message message) {
    final isCurrentUser = message.senderId == currentUserId;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue[200] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(12),
            child: Text(
              message.messageText,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 5),
          Text(
            _formatTimestamp(message.sentAt),
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
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
            onPressed: () => _sendMessage(context),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final message = Message(
        senderId: currentUserId,
        messageText: messageText,
        sentAt: DateTime.now(),
        attachments: [],
      );
      BlocProvider.of<ChatBloc>(context).add(SendMessage(chatId: chatId, message: message));
      _messageController.clear();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}"; // Simple format HH:mm
  }
}
