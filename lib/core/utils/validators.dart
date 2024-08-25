class Validators {
  // Valider une adresse email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Veuillez entrer un email';
    }
    String emailPattern = r'^[^@]+@[^@]+\.[^@]+';
    if (!RegExp(emailPattern).hasMatch(email)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  // Valider un mot de passe (longueur minimale, caractères spéciaux, etc.)
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    }
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  // Valider un champ texte non vide
  static String? validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    return null;
  }

  // Valider un numéro de téléphone
  static String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Veuillez entrer un numéro de téléphone';
    }
    String phonePattern = r'^\+?[0-9]{7,15}$';
    if (!RegExp(phonePattern).hasMatch(phoneNumber)) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }
    return null;
  }
}
