import 'package:intl/intl.dart';

class DateUtils {
  // Formater une date en tant que chaîne
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Formater une date et heure en tant que chaîne
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  // Renvoyer le nombre de jours entre deux dates
  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  // Vérifier si une date est dans le passé
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Vérifier si une date est aujourd'hui
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
