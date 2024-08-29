import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTicketScreen extends StatefulWidget {
  final String ticketId;

  EditTicketScreen({required this.ticketId});

  @override
  _EditTicketScreenState createState() => _EditTicketScreenState();
}

class _EditTicketScreenState extends State<EditTicketScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Moyenne';
  String _selectedCategory = 'Technique';

  @override
  void initState() {
    super.initState();
    _loadTicketData();
  }

  void _loadTicketData() async {
    DocumentSnapshot doc = await _firestore.collection('tickets').doc(widget.ticketId).get();
    Map<String, dynamic> ticket = doc.data() as Map<String, dynamic>;
    setState(() {
      _titleController.text = ticket['title'];
      _descriptionController.text = ticket['description'];
      _selectedPriority = ticket['priority'];
      _selectedCategory = ticket['category'];
    });
  }

  void _updateTicket() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _firestore.collection('tickets').doc(widget.ticketId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'priority': _selectedPriority,
        'category': _selectedCategory,
        'updated_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket mis à jour avec succès!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) => value!.isEmpty ? 'Le titre est requis' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'La description est requise' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                items: ['Haute', 'Moyenne', 'Faible'].map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Priorité'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Technique', 'Pédagogique'].map((category) {
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
                decoration: InputDecoration(labelText: 'Catégorie'),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _updateTicket,
                  child: Text('Mettre à jour'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
