import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/auth_service.dart'; // Assurez-vous d'importer AuthService

class ReponseTicketScreen extends StatelessWidget {
  final String ticketId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService(); // Utilisation d'AuthService pour obtenir userId

  ReponseTicketScreen({required this.ticketId});

  void _updateStatus(String status) async {
    final userId = _authService.getCurrentUserId(); // Récupérer l'ID de l'utilisateur actuel

    await _firestore.collection('tickets').doc(ticketId).update({
      'status': status,
      'assigned_to': userId, // Assigner le ticket à l'utilisateur actuel
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Enregistrer l'historique de la modification du statut
    await _firestore.collection('tickets').doc(ticketId).collection('history').add({
      'status': status,
      'changed_by': userId,
      'changed_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réponse au ticket'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('tickets').doc(ticketId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement du ticket'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Ticket non trouvé'));
          }

          final ticket = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(ticket['description']),
                SizedBox(height: 16),
                Text('Statut actuel: ${ticket['status']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                if (ticket['status'] == 'Attente') ...[
                  ElevatedButton(
                    onPressed: () => _updateStatus('En cours'),
                    child: Text('Prise en charge'),
                  ),
                ],
                if (ticket['status'] == 'En cours') ...[
                  ElevatedButton(
                    onPressed: () => _updateStatus('Résolu'),
                    child: Text('Traiter'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/ticket-reply', arguments: ticketId);
                    },
                    child: Text('Répondre'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: 0, // Assurez-vous de mettre à jour cet index pour les autres pages
        onTap: (index) {
          // Gérer la navigation entre les différentes pages
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
      ),
    );
  }
}
