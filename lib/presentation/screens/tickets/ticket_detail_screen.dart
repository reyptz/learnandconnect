import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:learnandconnect/presentation/screens/tickets/ticket_edit_screen.dart'; // Assurez-vous d'importer le package intl pour le formatage des dates

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;

  const TicketDetailScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    void _deleteTicket() async {
      await _firestore.collection('tickets').doc(ticketId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket supprimé avec succès!')));
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du ticket'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context, _deleteTicket);
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('tickets').doc(ticketId).get(),
        builder: (context, ticketSnapshot) {
          if (ticketSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (ticketSnapshot.hasError) {
            return Center(child: Text('Erreur de chargement des détails du ticket'));
          }

          if (!ticketSnapshot.hasData || !ticketSnapshot.data!.exists) {
            return Center(child: Text('Ticket non trouvé'));
          }

          final ticket = ticketSnapshot.data!.data() as Map<String, dynamic>;
          final String? assignedToId = ticket['assigned_to'];

          if (assignedToId == null) {
            return _buildTicketDetails(context, ticket, assignedToName: 'Non assigné');
          }

          return FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('users').doc(assignedToId).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasError) {
                return Center(child: Text('Erreur de chargement des détails de l\'utilisateur'));
              }

              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return _buildTicketDetails(context, ticket, assignedToName: 'Utilisateur non trouvé');
              }

              final user = userSnapshot.data!.data() as Map<String, dynamic>;
              final String assignedToName = '${user['first_name']} ${user['last_name']}';

              return _buildTicketDetails(context, ticket, assignedToName: assignedToName);
            },
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

  // Fonction pour construire les détails du ticket avec le nom de l'utilisateur assigné
  Widget _buildTicketDetails(BuildContext context, Map<String, dynamic> ticket, {required String assignedToName}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket['title'],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Statut: ${ticket['status']}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Catégorie: ${ticket['category']}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Priorité: ${ticket['priority']}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Description:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(ticket['description'] ?? 'Pas de description fournie'),
          SizedBox(height: 16),
          Text(
            'Créé le: ${_formatTimestamp(ticket['created_at'])}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Modifié le: ${_formatTimestamp(ticket['updated_at'])}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Assigné à: $assignedToName',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTicketScreen(ticketId: ticketId),
                  ),
                );
              },
              child: Text('Modifier le ticket'),
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour formater les timestamps
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
  }

  void _showDeleteConfirmationDialog(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le ticket'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce ticket ?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Supprimer'),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }
}
