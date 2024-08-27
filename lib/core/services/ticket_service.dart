import '../../data/repositories/ticket_repository.dart';
import '../../data/models/ticket_model.dart';

class TicketService {
  final TicketRepository _ticketRepository = TicketRepository();

  // Créer un nouveau ticket
  Future<void> createTicket(Ticket ticket) async {
    await _ticketRepository.createTicket(ticket);
  }

  // Récupérer un ticket par ID
  Future<Ticket?> getTicketById(String ticketId) async {
    return await _ticketRepository.getTicketById(ticketId);
  }

  // Mettre à jour un ticket
  Future<void> updateTicket(Ticket ticket) async {
    await _ticketRepository.updateTicket(ticket);
  }

  // Changer le statut d'un ticket et enregistrer dans l'historique
  Future<void> changeTicketStatus(String ticketId, String newStatus, String userId) async {
    Ticket? ticket = await _ticketRepository.getTicketById(ticketId);
    if (ticket != null) {
      // Enregistrer l'ancien statut dans l'historique
      TicketHistory history = TicketHistory(
        status: ticket.status,
        changedBy: userId,
        changedAt: DateTime.now(),
      );
      await _ticketRepository.addTicketHistory(ticketId, history);

      // Mettre à jour le statut du ticket
      ticket.status = newStatus;
      await _ticketRepository.updateTicket(ticket);
    }
  }

  // Récupérer l'historique d'un ticket
  Future<List<TicketHistory>> getTicketHistory(String ticketId) async {
    return await _ticketRepository.getTicketHistory(ticketId);
  }

  // Supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    await _ticketRepository.deleteTicket(ticketId);
  }

  getTicketsByCategory(String categoryId) {}
}