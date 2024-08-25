import 'package:equatable/equatable.dart';
import '../../data/models/ticket_model.dart';

abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

class LoadTickets extends TicketEvent {
  final String categoryId;

  const LoadTickets({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class AddTicket extends TicketEvent {
  final Ticket ticket;

  const AddTicket({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}
