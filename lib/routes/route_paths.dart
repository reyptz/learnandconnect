class RoutePaths {
  // Routes publiques
  static const String home = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgot = '/forgot-password';
  static const String resetpassword = '/password-reset-confirmation';

  // Routes protégées (requièrent authentification)
  static const String tickets = '/tickets';
  static const String ticketDetail = '/ticket-detail';
  static const String ticketReponse = '/ticket-reponse';
  static const String ticketHistory = '/ticket-history';
  static const String ticketCreate = '/ticket-create';
  static const String ticketEdit = '/ticket-edit';
  static const String ticketReply = '/ticket-reply';
  static const String report = '/report';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String chat = '/ticket-chat';
  static const String notifications = '/notifications';
  static const String users = '/users';

  // Routes d'erreur
  static const String error = '/error';
}
