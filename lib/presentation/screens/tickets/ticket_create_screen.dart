import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Technique'; // Catégorie par défaut
  final List<String> _categories = ['Technique', 'Pédagogique'];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _submitTicket() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La description ne peut pas être vide.'),
      ));
      return;
    }

    // Création du ticket dans Firestore
    await _firestore.collection('tickets').add({
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'status': 'Attente', // État initial
      'created_at': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ticket soumis avec succès!'),
    ));

    // Réinitialiser les champs
    _descriptionController.clear();
    setState(() {
      _selectedCategory = _categories.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Décrivez votre problème ou demande d\'assistance...',
              ),
            ),
            SizedBox(height: 16),
            Text('Catégorie', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitTicket,
              child: Text('Soumettre le ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
