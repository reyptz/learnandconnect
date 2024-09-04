import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';

class TicketReplyScreen extends StatelessWidget {
  final String ticketId;
  final TextEditingController _responseController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService(); // Utilisation d'AuthService pour obtenir userId

  TicketReplyScreen({required this.ticketId});

  void _submitResponse(String responderId) async {
    if (_responseController.text.isEmpty) {
      return;
    }

    final response = {
      'responder_id': responderId,
      'response_text': _responseController.text,
      'created_at': FieldValue.serverTimestamp(),
    };

    // Ajouter la réponse à la sous-collection 'responses' du ticket
    await _firestore
        .collection('tickets')
        .doc(ticketId)
        .collection('responses')
        .add(response);

    // Mettre à jour le statut du ticket
    await _firestore.collection('tickets').doc(ticketId).update({
      'status': 'Résolu',
      'assigned_to': responderId,
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Enregistrer l'historique de la modification du statut
    await _firestore
        .collection('tickets')
        .doc(ticketId)
        .collection('history')
        .add({
      'status': 'Résolu',
      'changed_by': responderId,
      'changed_at': FieldValue.serverTimestamp(),
    });

    try {
      final userId = _authService.getCurrentUserId();

      // Récupérer l'apprenant
      DocumentSnapshot ticketSnapshot = await _firestore.collection('tickets').doc(ticketId).get();
      final ticketData = ticketSnapshot.data() as Map<String, dynamic>;
      final apprenantId = ticketData['user_id'];

      // Envoyer une notification push à l'apprenant
      DocumentSnapshot apprenantSnapshot = await _firestore.collection('users').doc(apprenantId).get();
      final apprenantData = apprenantSnapshot.data() as Map<String, dynamic>;
      final apprenantToken = apprenantData['fcm_token'];

      NotificationService.showLocalNotification(
        'Ticket Résolu',
        'Votre ticket a été résolu.',
        ticketId,
      );

      // Enregistrer la notification dans Firestore
      _firestore.collection('notifications').add({
        'user_id': apprenantId,
        'ticket_id': ticketId,
        'notification_text': 'Votre ticket a été résolu.',
        'notification_type': 'Push',
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print('Erreur lors du changement du statut à Résolu: $e');
    }

    _responseController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Répondre au ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _responseController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Votre réponse...',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final responderId = _authService.getCurrentUserId(); // Remplacer par l'ID de l'utilisateur actuel
                _submitResponse(responderId!);
                Navigator.pop(context, '/ticket-reponse'); // Retour à la page précédente après la réponse
              },
              child: Text('Envoyer la réponse'),
            ),
          ],
        ),
      ),
    );
  }
}
