import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryTicketsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets Résolus'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tickets').where('status', isEqualTo: 'Résolu').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des tickets résolus'));
          }

          final tickets = snapshot.data?.docs ?? [];

          if (tickets.isEmpty) {
            return Center(child: Text('Aucun ticket résolu trouvé.'));
          }

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return ListTile(
                title: Text(ticket['title']),
                subtitle: Text(ticket['description']),
                onTap: () {
                  Navigator.pushNamed(context, '/ticket-detail', arguments: ticket.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
