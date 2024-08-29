import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/ticket_repository.dart';
import '../../data/models/ticket_model.dart';

class TicketService {
  final TicketRepository _ticketRepository = TicketRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<void> updateTicketStatus(String ticketId, String newStatus, String changedByUserId) async {
    final ticketDocRef = _firestore.collection('tickets').doc(ticketId);

    // Récupérer le ticket actuel pour vérifier son statut actuel
    final DocumentSnapshot ticketSnapshot = await ticketDocRef.get();
    if (!ticketSnapshot.exists) {
      throw Exception('Ticket not found');
    }

    final currentStatus = ticketSnapshot['status'];

    // Mettre à jour le statut du ticket
    await ticketDocRef.update({
      'status': newStatus,
      'updated_at': FieldValue.serverTimestamp(),
    });

    // Enregistrer l'historique de la modification
    final historyDocRef = ticketDocRef.collection('history').doc();
    await historyDocRef.set({
      'status': newStatus,
      'changed_by': changedByUserId,
      'changed_at': FieldValue.serverTimestamp(),
      'previous_status': currentStatus,
    });
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