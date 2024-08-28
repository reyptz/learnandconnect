import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../blocs/ticket/ticket_bloc.dart';
import '../../../blocs/ticket/ticket_state.dart';
import '../../widgets/ticket_card.dart';

class TicketListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('tickets')
            .where('user_id', isEqualTo: 'current_user_id') // Remplacez par l'ID de l'utilisateur actuel
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
              return ListTile(
                title: Text(ticket['description']),
                subtitle: Text('Statut: ${ticket['status']}'),
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
