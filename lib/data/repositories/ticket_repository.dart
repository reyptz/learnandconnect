import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart'; // Importez le modèle Ticket

class TicketRepository {
  final CollectionReference ticketCollection =
  FirebaseFirestore.instance.collection('tickets');

  // Récupérer un ticket par son ID
  Future<Ticket?> getTicketById(String ticketId) async {
    try {
      DocumentSnapshot doc = await ticketCollection.doc(ticketId).get();
      if (doc.exists) {
        return Ticket.fromFirestore(doc);
      }
    } catch (e) {
      print('Error getting ticket: $e');
    }
    return null;
  }

  // Créer un nouveau ticket
  Future<void> createTicket(Ticket ticket) async {
    try {
      await ticketCollection.add(ticket.toFirestore());
    } catch (e) {
      print('Error creating ticket: $e');
    }
  }

  // Mettre à jour un ticket
  Future<void> updateTicket(Ticket ticket) async {
    try {
      await ticketCollection.doc(ticket.ticketId).update(ticket.toFirestore());
    } catch (e) {
      print('Error updating ticket: $e');
    }
  }

  // Supprimer un ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      await ticketCollection.doc(ticketId).delete();
    } catch (e) {
      print('Error deleting ticket: $e');
    }
  }

  // Récupérer les tickets par catégorie
  Future<List<Ticket>> getTicketsByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await ticketCollection
          .where('category_id', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error getting tickets by category: $e');
      return [];
    }
  }
}
