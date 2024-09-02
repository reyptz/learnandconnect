import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/auth_service.dart'; // Assurez-vous d'importer AuthService
import '../../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class ReponseTicketScreen extends StatefulWidget {
  final String ticketId;

  ReponseTicketScreen({required this.ticketId});

  @override
  _ReponseTicketScreenState createState() => _ReponseTicketScreenState();
}

class _ReponseTicketScreenState extends State<ReponseTicketScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService =
      AuthService(); // Utilisation d'AuthService pour obtenir userId
  int _currentIndex = 0;

  void _updateStatus(String status) async {
    final userId = _authService
        .getCurrentUserId(); // Récupérer l'ID de l'utilisateur actuel

    await _firestore.collection('tickets').doc(widget.ticketId).update({
      'status': status,
      'assigned_to': userId, // Assigner le ticket à l'utilisateur actuel
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Enregistrer l'historique de la modification du statut
    await _firestore
        .collection('tickets')
        .doc(widget.ticketId)
        .collection('history')
        .add({
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
        future: _firestore.collection('tickets').doc(widget.ticketId).get(),
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
                Text(ticket['title']),
                SizedBox(height: 16),
                Text('Description',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(ticket['description']),
                SizedBox(height: 16),
                Text('Priorité: ${ticket['priority']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 16),
                Text('Statut actuel: ${ticket['status']}',
                    style: TextStyle(fontSize: 18)),
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
                      Navigator.pushNamed(context, '/ticket-reply',
                          arguments: widget.ticketId);
                    },
                    child: Text('Répondre'),
                  ),
                ],
                SizedBox(height: 16),
                Text('Réponses précédentes',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('tickets')
                        .doc(widget.ticketId)
                        .collection('responses')
                        .snapshots(),
                    builder: (context, responseSnapshot) {
                      if (responseSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (responseSnapshot.hasError) {
                        return Center(
                            child: Text('Erreur de chargement des réponses'));
                      }

                      final responses = responseSnapshot.data?.docs ?? [];

                      if (responses.isEmpty) {
                        return Center(child: Text('Aucune réponse trouvée.'));
                      }

                      return ListView.builder(
                        itemCount: responses.length,
                        itemBuilder: (context, index) {
                          final response =
                              responses[index].data() as Map<String, dynamic>;
                          return ListTile(
                            subtitle: Text(response['response_text']),
                            trailing: Text(DateFormat('dd/MM/yyyy à HH:mm')
                                .format(response['created_at'].toDate())),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
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

  // Fonction pour formater les timestamps
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
  }
}
