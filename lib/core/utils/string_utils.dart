class StringUtils {
  // Convertir une chaîne en majuscules
  static String toUpperCase(String input) {
    return input.toUpperCase();
  }

  // Convertir une chaîne en minuscules
  static String toLowerCase(String input) {
    return input.toLowerCase();
  }

  // Tronquer une chaîne si elle dépasse une certaine longueur
  static String truncate(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    }
    return '${input.substring(0, maxLength)}...';
  }

  // Vérifier si une chaîne est vide ou nulle
  static bool isNullOrEmpty(String? input) {
    return input == null || input.isEmpty;
  }
}
