import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryTicketsScreen extends StatelessWidget {
  final String ticketId;

  HistoryTicketsScreen({required this.ticketId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des changements de statut'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tickets')
            .doc(ticketId)
            .collection('history')
            .orderBy('changed_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement de l\'historique'));
          }

          final history = snapshot.data?.docs ?? [];

          if (history.isEmpty) {
            return Center(child: Text('Aucun historique trouvé.'));
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return ListTile(
                title: Text('Statut: ${entry['status']}'),
                subtitle: Text('Modifié par: ${entry['changed_by']}'),
                trailing: Text(
                  _formatTimestamp(entry['changed_at'] as Timestamp),
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}:${dateTime.minute}';
  }
}
