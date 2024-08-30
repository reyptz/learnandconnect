import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';
import '../../data/models/chat_model.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatefulWidget {
  final String chatId;

  const ChatWidget({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Charger les messages au début
    BlocProvider.of<ChatBloc>(context).add(LoadMessages(chatId: widget.chatId));
    // Écouter les messages en temps réel
    BlocProvider.of<ChatBloc>(context)
        .add(ListenToMessages(chatId: widget.chatId));
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
                  reverse:
                      true, // Affiche les messages du plus récent au plus ancien
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

  Future<String> _getSenderName(String senderId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(senderId).get();

      // Convertir les données en Map<String, dynamic>
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      // Retourner le nom de l'utilisateur, ou 'Utilisateur' par défaut
      return data?['name'] ?? 'Utilisateur';
    } catch (e) {
      return 'Utilisateur';
    }
  }

  Widget _buildMessageTile(Message message) {
    return FutureBuilder<String>(
      future: _getSenderName(message
          .senderId), // Appel asynchrone pour obtenir le nom de l'expéditeur
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Affichez un indicateur de chargement pendant que le nom est en cours de récupération
          return ListTile(
            title: Text('Chargement...'),
            subtitle: Text(message.messageText),
            trailing: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(message.sentAt.toLocal()),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        } else if (snapshot.hasError) {
          // Gérez l'erreur si le chargement échoue
          return ListTile(
            title: Text('Erreur'),
            subtitle: Text(message.messageText),
            trailing: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(message.sentAt.toLocal()),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        } else {
          // Affichez le nom de l'expéditeur une fois récupéré
          return ListTile(
            title: Text(snapshot.data ?? 'Utilisateur'),
            subtitle: Text(message.messageText),
            trailing: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(message.sentAt.toLocal()),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        }
      },
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
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final message = Message(
          senderId:
              currentUser.uid, // Utilisation de l'ID de l'utilisateur Firebase
          messageText: messageText,
          sentAt: DateTime.now(), // Gérez les pièces jointes si nécessaire
        );
        BlocProvider.of<ChatBloc>(context)
            .add(SendMessage(chatId: widget.chatId, message: message));
        _messageController.clear();
      }
    }
  }
}
