import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:learnandconnect/presentation/screens/tickets/ticket_edit_screen.dart'; 
import '../../../core/constants/app_colors.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  bool _canEditOrDelete = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final user = _auth.currentUser;
    if (user != null) {
      final ticketSnapshot = await _firestore.collection('tickets').doc(widget.ticketId).get();
      if (ticketSnapshot.exists) {
        final ticketData = ticketSnapshot.data() as Map<String, dynamic>;
        final String ticketOwnerId = ticketData['user_id']; // Assurez-vous que l'ID du créateur du ticket est stocké sous cette clé
        final userSnapshot = await _firestore.collection('users').doc(user.uid).get();
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final String userRole = userData['role'] ?? 'Apprenant';

        setState(() {
          // Autoriser la modification/suppression si l'utilisateur est le créateur ou s'il n'est pas un Apprenant
          _canEditOrDelete = userRole != 'Apprenant' || ticketOwnerId == user.uid;
        });
      }
    }
  }

  void _deleteTicket() async {
    await _firestore.collection('tickets').doc(widget.ticketId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket supprimé avec succès!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du ticket'),
        actions: _canEditOrDelete
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context, _deleteTicket);
            },
          ),
        ]
            : null,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('tickets').doc(widget.ticketId).get(),
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

          // Vérifier si assignedToId est vide ou null avant de tenter de récupérer les détails de l'utilisateur
          if (assignedToId == null || assignedToId.isEmpty) {
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
              final String assignedToName = '${user['name']}';

              return _buildTicketDetails(context, ticket, assignedToName: assignedToName);
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _currentIndex == 0 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: _currentIndex == 1 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.primaryColor,
            icon: Icon(Icons.notifications, color: _currentIndex == 2 ? AppColors.backgroundColor : AppColors.Colorabs),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 3 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex, // Utilisez la variable d'état pour l'index actif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mettre à jour l'index sélectionné
          });
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
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

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
                    builder: (context) => EditTicketScreen(ticketId: widget.ticketId),
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
