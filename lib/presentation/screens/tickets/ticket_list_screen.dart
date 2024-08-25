import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/ticket/ticket_bloc.dart';
import '../../../blocs/ticket/ticket_state.dart';
import '../../widgets/ticket_card.dart';

class TicketListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Tickets'),
      ),
      body: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TicketLoaded) {
            return ListView.builder(
              itemCount: state.tickets.length,
              itemBuilder: (context, index) {
                final ticket = state.tickets[index];
                return TicketCard(
                  ticket: ticket,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/ticket-detail',
                      arguments: ticket.ticketId,
                    );
                  },
                );
              },
            );
          } else if (state is TicketError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucun ticket disponible.'));
          }
        },
      ),
    );
  }
}
