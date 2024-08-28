import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getResolvedTicketsCount() async {
    final snapshot = await _firestore.collection('tickets').where('status', isEqualTo: 'Résolu').get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<int>(
          future: _getResolvedTicketsCount(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur de chargement des statistiques'));
            }

            return Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Tickets résolus'),
                    subtitle: Text('${snapshot.data} tickets'),
                  ),
                ),
                // Ajoutez d'autres statistiques ici
              ],
            );
          },
        ),
      ),
    );
  }
}
