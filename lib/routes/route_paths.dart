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
  static const String profile = '/profile';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  // Routes d'erreur
  static const String error = '/error';
}
