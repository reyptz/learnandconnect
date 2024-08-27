import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Enregistrer un événement analytique personnalisé
  Future<void> logEvent(String eventName, Map<String, Object> parameters) async {
    await _analytics.logEvent(name: eventName, parameters: parameters);
  }

  // Suivre la connexion d'un utilisateur
  Future<void> logLogin(String userId) async {
    await _analytics.logLogin(loginMethod: "email");
  }

  // Suivre l'inscription d'un utilisateur
  Future<void> logSignUp(String userId) async {
    await _analytics.logSignUp(signUpMethod: "email");
  }

  // Suivre la création d'un ticket
  Future<void> logTicketCreation(String ticketId, String categoryId) async {
    await _analytics.logEvent(name: "ticket_creation", parameters: {
      "ticket_id": ticketId,
      "category_id": categoryId,
    });
  }

  // Suivre un changement de statut de ticket
  Future<void> logTicketStatusChange(String ticketId, String status) async {
    await _analytics.logEvent(name: "ticket_status_change", parameters: {
      "ticket_id": ticketId,
      "new_status": status,
    });
  }
}
