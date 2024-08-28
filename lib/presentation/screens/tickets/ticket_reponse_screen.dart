import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReponseTicketScreen extends StatelessWidget {
  final String ticketId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ReponseTicketScreen({required this.ticketId});

  void _updateStatus(String status) async {
    await _firestore.collection('tickets').doc(ticketId).update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion du ticket'),
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
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
