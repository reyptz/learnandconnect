import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/notification_service.dart';

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Moyenne'; // Priorité par défaut
  String _selectedCategory = 'Technique'; // Catégorie par défaut

  final List<String> _priorities = ['Haute', 'Moyenne', 'Faible'];
  final List<String> _categories = ['Technique', 'Pédagogique'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final AuthService _authService = AuthService(); // Initialisation de AuthService
  int _currentIndex = 0;

  void _storeUserToken(String userId) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcm_token': fcmToken,
      });
    }
  }

  void _submitTicket() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Titre et description ne peuvent pas être vides.'),
      ));
      return;
    }

    // Supposez que vous avez les IDs des utilisateurs (créateur et assigné)
    String? userId = _authService.getCurrentUserId(); // ID de l'utilisateur actuel
    String? assignedTo = ''; // ID de l'utilisateur assigné (peut être null)

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur : Utilisateur non connecté.'),
      ));
      return;
    }

    // Référence au nouveau document dans Firestore
    DocumentReference docRef = _firestore.collection('tickets').doc();

    // Création du ticket dans Firestore avec les valeurs par défaut
    await docRef.set({
      'ticket_id': docRef.id, // Utilisation de l'ID généré par Firestore
      'title': _titleController.text,
      'description': _descriptionController.text,
      'status': 'Attente', // État initial défini par défaut
      'priority': _selectedPriority, // Priorité sélectionnée
      'category': _selectedCategory, // Catégorie sélectionnée
      'user_id': userId, // ID de l'utilisateur qui a créé le ticket
      'assigned_to': assignedTo, // ID de l'utilisateur assigné (peut être null)
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });

    /*// Stocker la notification pour l'utilisateur (apprenant)
    await FirebaseFirestore.instance.collection('notifications').add({
      'user_id': userId, // ID de l'utilisateur qui a créé le ticket
      'ticket_id': docRef.id,
      'notification_text': 'Vous avez créé un nouveau ticket.', // Le message personnalisé
      'notification_type': 'Push',
      'is_read': false,
      'created_at': FieldValue.serverTimestamp(),
    });

    // Récupérer tous les formateurs
    QuerySnapshot formateursSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Formateur')
        .get();

    // Stocker la notification pour chaque formateur
    for (var doc in formateursSnapshot.docs) {
      await FirebaseFirestore.instance.collection('notifications').add({
        'user_id': doc.id, // ID du formateur
        'ticket_id': docRef.id,
        'notification_text': 'Un nouveau ticket a été créé.', // Le même message pour les formateurs
        'notification_type': 'Push',
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
      });
    }*/

    // Récupérer les formateurs et envoyer des notifications
    QuerySnapshot formateurs = await _firestore.collection('users')
        .where('role', isEqualTo: 'Formateur')
        .get();

    for (var formateur in formateurs.docs) {
      String token = formateur['fcm_token'];
      await NotificationService.sendPushMessage(token, 'Nouveau Ticket', 'Un nouveau ticket a été créé.');

      // Stocker la notification dans Firestore
      await _firestore.collection('notifications').add({
        'user_id': formateur.id,
        'ticket_id': docRef.id,
        'notification_text': 'Un nouveau ticket a été créé.',
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ticket sauvegardé avec succès!'),
    ));

    // Réinitialiser les champs
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedPriority = 'Moyenne'; // Réinitialiser à la priorité par défaut
      _selectedCategory = 'Technique'; // Réinitialiser à la catégorie par défaut
    });

    Navigator.pushReplacementNamed(context, '/tickets');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Ajouter un Ticket'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(_titleController, 'Titre'),
            SizedBox(height: 16),
            _buildTextField(_descriptionController, 'Description', maxLines: 3),
            SizedBox(height: 16),
            _buildDropdownField('Priorité', _selectedPriority, _priorities, (value) {
              setState(() {
                _selectedPriority = value!;
              });
            }),
            SizedBox(height: 16),
            _buildDropdownField('Catégorie', _selectedCategory, _categories, (value) {
              setState(() {
                _selectedCategory = value!;
              });
            }),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('SAUVEGARDER', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _currentIndex == 0 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: _currentIndex == 1 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.primaryColor,
            icon: Icon(Icons.notifications, color: _currentIndex == 2 ? AppColors.backgroundColor : AppColors.Colorabs),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 3 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex, // Utilisez la variable d'état pour l'index actif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mettre à jour l'index sélectionné
          });
          // Gérer la navigation entre les différentes pages
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/tickets');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String labelText, String selectedValue, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
