import 'package:flutter/material.dart';
import '../../widgets/stat_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de Bord Administratif'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        children: [
          StatCard(
            title: 'Utilisateurs',
            value: '150',
            icon: Icons.people,
          ),
          StatCard(
            title: 'Tickets',
            value: '75',
            icon: Icons.assignment,
          ),
          StatCard(
            title: 'Tâches En Cours',
            value: '30',
            icon: Icons.work,
          ),
          StatCard(
            title: 'Rôles',
            value: '5',
            icon: Icons.security,
          ),
        ],
      ),
    );
  }
}
