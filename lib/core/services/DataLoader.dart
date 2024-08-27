import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Pour print uniquement si kDebugMode est vrai

class DataLoaderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadData() async {
    try {
      await _loadUsers();
      await _loadCategories();
      await _loadTickets();
      await _loadTicketsWithResponsesAndHistory();
      await _loadOtherData(); // Si vous avez d'autres collections
      if (kDebugMode) {
        print("Data loaded successfully.");
      }
    } catch (e) {
      print("Failed to load data: $e");
    }
  }

  Future<void> _loadUsers() async {
    CollectionReference users = _firestore.collection('users');
    DocumentReference userref = await users.add({
      'user_id': '1',
      'email': 'admin@admin.com',
      'name': 'admin',
      'passwordHash': 'admin',
      'role': 'admin',
      'profile_picture_url': 'https://example.com/john_doe.jpg',
      'is_active': true,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'last_login': Timestamp.now(),
    });
    await users.add({
      'user_id': '2',
      'email': 'mah@example.com',
      'name': 'mah',
      'passwordHash': 'mah',
      'role': 'formateur',
      'profile_picture_url': 'https://example.com/john_doe.jpg',
      'is_active': true,
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'last_login': Timestamp.now(),
    });

    // Ajouter des activités à cet utilisateur (sous-collection "users")
    CollectionReference user = userref.collection('activity_log');
    await user.add({
      'action': 'Se connecter',
      'metadata': {
        'ip_address': '192.168.1.1', // Exemple de métadonnées
        'device': 'iPhone 12',
        'location': 'Paris, France',
      },
      'created_at': Timestamp.now(),
    });
  }

  Future<void> _loadCategories() async {
    CollectionReference categories = _firestore.collection('categories');
    await categories.add({
      'category_name': 'Technical Support',
      'description': 'Support for technical issues.',
      'created_at': Timestamp.now(),
    });
    await categories.add({
      'category_name': 'Billing Support',
      'description': 'Support for billing and payment issues.',
      'created_at': Timestamp.now(),
    });
  }

  Future<void> _loadTickets() async {
    CollectionReference tickets = _firestore.collection('tickets');
    await tickets.add({
      'ticket_id': '1',
      'user_id': '1',
      'category_id': '1',
      'title': 'Issue with login',
      'description': 'Unable to log in to the system',
      'status': 'En cours',
      'priority': 'Haute',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });
  }

  Future<void> _loadTicketsWithResponsesAndHistory() async {
    CollectionReference tickets = _firestore.collection('tickets');

    // Ajouter un ticket
    DocumentReference ticketRef = await tickets.add({
      'ticket_id': '1',
      'user_id': '1',
      'category_id': '1',
      'title': 'Issue with login',
      'description': 'Unable to log in to the system',
      'status': 'En cours',
      'priority': 'Haute',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });

    // Ajouter des réponses à ce ticket (sous-collection "responses")
    CollectionReference responses = ticketRef.collection('responses');
    await responses.add({
      'responder_id': '2',
      'response_text': 'Please try resetting your password.',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });

    await responses.add({
      'responder_id': '1',
      'response_text': 'I have the same issue.',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
    });

    // Ajouter un historique de changement de statut (sous-collection "history")
    CollectionReference history = ticketRef.collection('history');
    await history.add({
      'status': 'En cours',
      'changed_by': '1',
      'changed_at': Timestamp.now(),
    });

    await history.add({
      'status': 'Résolu',
      'changed_by': '2',
      'changed_at': Timestamp.now(),
    });
  }

  Future<void> _loadOtherData() async {
    // Ajoutez ici la logique pour charger d'autres collections si nécessaire
    CollectionReference Notification = _firestore.collection('notifications');

    // Ajouter une notification
    await Notification.add({
      'notification_id': '1',
      'user_id': '1',
      'ticket_id': '1',
      'notification_text': 'A ɲɛnabɔra',
      'notification_type': 'Urgent',
      'is_read': 'false',
      'created_at': Timestamp.now(),
    });

    CollectionReference chats = _firestore.collection('chats');

    // Ajouter un chat
    DocumentReference chatRef = await chats.add({
      'chat_id': '1',
      'created_at': Timestamp.now(),
      'last_message_at': Timestamp.now(),
    });

    // Ajouter des messages à ce chat (sous-collection "messages")
    CollectionReference messages = chatRef.collection('messages');
    await messages.add({
      'sender_id': '1',
      'message_text': 'Bonjour, ne bɛ se ka aw dɛmɛ cogo di?',
      'sent_at': Timestamp.now(),
      'attachments': [], // Liste vide pour les pièces jointes, à personnaliser si besoin
    });

    await messages.add({
      'sender_id': '2',
      'message_text': 'N ye ko dɔ sɔrɔ n ka jatebɔ la.',
      'sent_at': Timestamp.now(),
      'attachments': [], // Liste vide pour les pièces jointes, à personnaliser si besoin
    });
  }
}