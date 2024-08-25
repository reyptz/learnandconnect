class ApiEndpoints {
  static const String baseUrl = 'https://api.monsite.com/v1';

  // Auth endpoints
  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/auth/signup';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // User endpoints
  static const String getUserProfile = '$baseUrl/user/profile';
  static const String updateUserProfile = '$baseUrl/user/update';

  // Ticket endpoints
  static const String getTickets = '$baseUrl/tickets';
  static const String createTicket = '$baseUrl/tickets/create';
  static const String updateTicket = '$baseUrl/tickets/update';
  static const String deleteTicket = '$baseUrl/tickets/delete';

  // Notifications endpoints
  static const String getNotifications = '$baseUrl/notifications';
  static const String markNotificationRead = '$baseUrl/notifications/mark-read';
}
