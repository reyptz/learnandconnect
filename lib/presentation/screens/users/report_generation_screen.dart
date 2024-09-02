import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _selectedDateRange;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;

  Future<List<DocumentSnapshot>> _getTicketsForDateRange(
      DateTimeRange dateRange) async {
    final snapshot = await _firestore
        .collection('tickets')
        .where('created_at', isGreaterThanOrEqualTo: dateRange.start)
        .where('created_at', isLessThanOrEqualTo: dateRange.end)
        .get();

    return snapshot.docs;
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Génération de rapports'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _selectDateRange,
              child: Text('Sélectionnez la période'),
            ),
            if (_selectedDateRange != null)
              Text(
                  'Période sélectionnée: ${DateFormat.yMMMd().format(_selectedDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedDateRange!.end)}'),
            SizedBox(height: 16),
            if (_selectedDateRange != null)
              FutureBuilder<List<DocumentSnapshot>>(
                future: _getTicketsForDateRange(_selectedDateRange!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Erreur de chargement des rapports'));
                  }

                  final tickets = snapshot.data ?? [];

                  if (tickets.isEmpty) {
                    return Center(
                        child: Text('Aucun ticket trouvé pour cette période.'));
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket =
                            tickets[index].data() as Map<String, dynamic>;
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(ticket['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Statut: ${ticket['status']}'),
                                Text(
                                    'Catégorie: ${ticket['category'] ?? 'N/A'}'),
                                Text(
                                    'Créé le: ${_formatTimestamp(ticket['created_at'])}'),
                                if (ticket['updated_at'] != null)
                                  Text(
                                      'Modifié le: ${_formatTimestamp(ticket['updated_at'])}'),
                                if (ticket['resolved_at'] != null)
                                  Text(
                                      'Résolu le: ${_formatTimestamp(ticket['resolved_at'])}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
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

  // Fonction pour formater les timestamps
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
  }
}
