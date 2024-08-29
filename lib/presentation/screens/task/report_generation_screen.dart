import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTimeRange? _selectedDateRange;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> _getTicketsForDateRange(DateTimeRange dateRange) async {
    final snapshot = await _firestore.collection('tickets')
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
              Text('Période sélectionnée: ${DateFormat.yMMMd().format(_selectedDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedDateRange!.end)}'),
            SizedBox(height: 16),
            if (_selectedDateRange != null)
              FutureBuilder<List<DocumentSnapshot>>(
                future: _getTicketsForDateRange(_selectedDateRange!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur de chargement des rapports'));
                  }

                  final tickets = snapshot.data ?? [];

                  if (tickets.isEmpty) {
                    return Center(child: Text('Aucun ticket trouvé pour cette période.'));
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(ticket['title']),
                          subtitle: Text(ticket['status']),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 0, // Assurez-vous de mettre à jour cet index pour les autres pages
        onTap: (index) {
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
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
