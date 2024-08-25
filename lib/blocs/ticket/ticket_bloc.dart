import 'package:flutter_bloc/flutter_bloc.dart';
import 'ticket_event.dart';
import 'ticket_state.dart';
import '../../core/services/ticket_service.dart';
import '../../data/models/ticket_model.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketService _ticketService;

  TicketBloc(this._ticketService) : super(TicketInitial());

  @override
  Stream<TicketState> mapEventToState(TicketEvent event) async* {
    if (event is LoadTickets) {
      yield TicketLoading();
      try {
        final tickets = await _ticketService.getTicketsByCategory(event.categoryId);
        yield TicketLoaded(tickets: tickets);
      } catch (e) {
        yield TicketError(message: e.toString());
      }
    } else if (event is AddTicket) {
      yield TicketLoading();
      try {
        await _ticketService.createTicket(event.ticket);
        yield TicketAdded();
      } catch (e) {
        yield TicketError(message: e.toString());
      }
    }
  }
}
