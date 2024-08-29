import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/auth_service.dart';

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _authService.getCurrentUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bouton d'ajout de ticket
            Center(
              child: GestureDetector(
                onTap: () {
                  // Ajoutez ici la navigation vers la page de création de ticket
                  Navigator.pushNamed(context, '/ticket-create');
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: Colors.orange, size: 32),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('tickets')
                    .where('user_id', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Erreur de chargement des tickets'));
                  }

                  final tickets = snapshot.data?.docs ?? [];

                  if (tickets.isEmpty) {
                    return Center(child: Text('Aucun ticket trouvé.'));
                  }

                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return TicketCard(
                        title: ticket['title'],
                        status: ticket['status'],
                        onDetailsPressed: () {
                          Navigator.pushNamed(context, '/ticket-detail',
                              arguments: ticket.id);
                        },
                        onHistoryPressed: () {
                          Navigator.pushNamed(context, '/ticket-history',
                              arguments: ticket.id);
                        },
                        onResponsePressed: () {
                          Navigator.pushNamed(context, '/ticket-reponse',
                              arguments: ticket.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
        currentIndex: 1,
        // Mise à jour de l'index actuel pour la page des tickets
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

class TicketCard extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onDetailsPressed;
  final VoidCallback onHistoryPressed;
  final VoidCallback onResponsePressed;

  const TicketCard({
    Key? key,
    required this.title,
    required this.status,
    required this.onDetailsPressed,
    required this.onHistoryPressed,
    required this.onResponsePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(status, style: TextStyle(fontSize: 16)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDetailsPressed,
              icon: Icon(Icons.details, color: Colors.orange),
              tooltip: 'Voir les détails',
            ),
            IconButton(
              icon: Icon(Icons.history, color: Colors.orange),
              onPressed: onHistoryPressed,
              tooltip: 'Voir l\'historique',
            ),
            IconButton(
              icon: Icon(Icons.reply, color: Colors.orange),
              onPressed: onResponsePressed,
              tooltip: 'Répondre au ticket',
            ),
          ],
        ),
      ),
    );
  }
}
