import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserId;

  ChatListScreen({required this.currentUserId});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _chatNameController = TextEditingController();
  List<String> _selectedUsers = [];

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    String? currentUserId = currentUser?.uid;

    if (currentUserId == null) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showCreateChatDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher une personne',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('chats')
                  .where('participants', arrayContains: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement des discussions'));
                }

                final chats = snapshot.data?.docs ?? [];

                if (chats.isEmpty) {
                  return Center(child: Text('Aucune discussion trouvée.'));
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index].data() as Map<String, dynamic>;
                    final lastMessage = chat['last_message'] ?? 'Aucun message';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                      ),
                      title: Text(chat['chat_name'] ?? 'Discussion'),
                      subtitle: Text(lastMessage),
                      trailing: Text(
                        _formatTimestamp(chat['last_message_at']),
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/chat-message',
                          arguments: {
                            'chatId': chats[index].id,
                            'currentUserId': currentUserId
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  void _showCreateChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Créer un nouveau chat'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _chatNameController,
                    decoration: InputDecoration(hintText: 'Nom du chat'),
                  ),
                  SizedBox(height: 16),
                  Text('Ajouter des participants :',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: FutureBuilder<QuerySnapshot>(
                      future: _firestore.collection('users').get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Erreur de chargement des utilisateurs');
                        }

                        final users = snapshot.data?.docs ?? [];

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index].data() as Map<String, dynamic>;
                            final userId = users[index].id;
                            final userName = user['name'] ?? 'Utilisateur';

                            return CheckboxListTile(
                              title: Text(userName),
                              value: _selectedUsers.contains(userId),
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    _selectedUsers.add(userId);
                                  } else {
                                    _selectedUsers.remove(userId);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Créer'),
                  onPressed: () async {
                    if (_chatNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Le nom du chat ne peut pas être vide')),
                      );
                      return;
                    }

                    if (_selectedUsers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Veuillez sélectionner au moins un participant')),
                      );
                      return;
                    }

                    try {
                      _selectedUsers.add(widget
                          .currentUserId); // Ajouter l'utilisateur actuel aux participants
                      final chatId = _firestore
                          .collection('chats')
                          .doc()
                          .id; // Générer un ID de chat unique

                      await _firestore.collection('chats').doc(chatId).set({
                        'chat_name': _chatNameController.text,
                        'participants': _selectedUsers.toList(),
                        'created_at': FieldValue.serverTimestamp(),
                        'last_message_at': FieldValue.serverTimestamp(),
                      });

                      _chatNameController.clear(); // Nettoyer le contrôleur après la création

                      Navigator.of(context).pop(); // Fermer la boîte de dialogue

                      Navigator.pushNamed(
                        context,
                        '/chat-detail',
                        arguments: {
                          'chatId': chatId,
                          'currentUserId': widget.currentUserId
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Erreur lors de la création du chat: $e')),
                      );
                      print(e.toString());
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: 3, // Index actuel pour l'écran de chat
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/tickets');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/notifications');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/chat');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    final dateTime = timestamp.toDate();
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        now.day - dateTime.day == 1) {
      return 'Hier';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }
}