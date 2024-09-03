import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Écouter les changements dans le champ de recherche
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Les tickets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher un ticket spécifique',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(color: AppColors.darkGrey), // Couleur du texte saisi
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (_searchQuery.isEmpty)
                    ? _firestore.collection('tickets').snapshots()
                    : _firestore
                    .collection('tickets')
                    .where('title', isGreaterThanOrEqualTo: _searchQuery)
                    .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur de chargement des tickets'));
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
                        ticketId: ticket['ticket_id'],
                        title: ticket['title'],
                        status: ticket['category'],
                        onChatPressed: () {
                          Navigator.pushNamed(context, '/ticket-chat', arguments: ticket.id);
                        },
                        onDetailsPressed: () {
                          Navigator.pushNamed(context, '/ticket-detail', arguments: ticket.id,);
                        },
                        onResponsePressed: () {
                          Navigator.pushNamed(context, '/ticket-reponse', arguments: ticket.id);
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
}

class TicketCard extends StatelessWidget {
  final String ticketId; // Ajout de l'ID du ticket
  final String title;
  final String status;
  final VoidCallback onDetailsPressed;
  final VoidCallback onResponsePressed;
  final VoidCallback onChatPressed;

  const TicketCard({
    Key? key,
    required this.ticketId,
    required this.title,
    required this.status,
    required this.onDetailsPressed,
    required this.onResponsePressed,
    required this.onChatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),      
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
        IconButton(
          onPressed: onChatPressed,
          icon: Icon(Icons.chat, color: Colors.orange),
          tooltip: 'Voir le chat',
        ),
        IconButton(
          onPressed: onDetailsPressed,
          icon: Icon(Icons.details, color: Colors.orange),
          tooltip: 'Voir les détails',
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
