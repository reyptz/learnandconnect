import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/ticket/ticket_bloc.dart';
import '../../../blocs/ticket/ticket_state.dart';
import '../../../data/models/ticket_model.dart';

class TicketDetailScreen extends StatelessWidget {
  final String ticketId;

  const TicketDetailScreen({required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Ticket'),
      ),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TicketLoaded) {
            final ticket = state.tickets.firstWhere((t) => t.ticketId == ticketId);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(ticket.description),
                  SizedBox(height: 16),
                  Text('Statut : ${ticket.status}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Action pour changer le statut du ticket
                    },
                    child: Text('Changer le statut'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Impossible de charger les détails du ticket.'));
          }
        },
      ),
    );
  }
}
