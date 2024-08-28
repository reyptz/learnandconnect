import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/ticket/ticket_bloc.dart';
import '../../../blocs/ticket/ticket_state.dart';
import '../../../data/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;

  const TicketDetailScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du ticket'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('tickets').doc(ticketId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des détails du ticket'));
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
                  'Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(ticket['description'] ?? 'Pas de description fournie'),
                // Ajoutez d'autres détails si nécessaire
              ],
            ),
          );
        },
      ),
    );
  }
}
