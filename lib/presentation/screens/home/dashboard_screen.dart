import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;

  Future<int> _getResolvedTicketsCount() async {
    final snapshot = await _firestore.collection('tickets').where('status', isEqualTo: 'Résolu').get();
    return snapshot.size;
  }

  Future<int> _getInProgressTicketsCount() async {
    final snapshot = await _firestore.collection('tickets').where('status', isEqualTo: 'En cours').get();
    return snapshot.size;
  }

  Future<int> _getPendingTicketsCount() async {
    final snapshot = await _firestore.collection('tickets').where('status', isEqualTo: 'Attente').get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _getResolvedTicketsCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement des statistiques'));
                }

                return _buildStatCard('Tickets résolus', '${snapshot.data} tickets');
              },
            ),
            FutureBuilder<int>(
              future: _getInProgressTicketsCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement des statistiques'));
                }

                return _buildStatCard('Tickets en cours', '${snapshot.data} tickets');
              },
            ),
            FutureBuilder<int>(
              future: _getPendingTicketsCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur de chargement des statistiques'));
                }

                return _buildStatCard('Tickets en attente', '${snapshot.data} tickets');
              },
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Utilisateur', () {
                  Navigator.pushNamed(context, '/users');
                }),
                _buildActionButton('Rapport', () {
                  Navigator.pushNamed(context, '/report');
                }),
              ],
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

  // Construire une carte de statistique
  Widget _buildStatCard(String title, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Text(count),
          ],
        ),
      ),
    );
  }

  // Construire un bouton d'action
  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
