import 'package:flutter/material.dart';
import '../../widgets/custom_date_picker.dart';

class ReportGenerationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _endDateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Génération de Rapports'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomDatePicker(
              label: 'Date de début',
              controller: _startDateController,
            ),
            SizedBox(height: 16),
            CustomDatePicker(
              label: 'Date de fin',
              controller: _endDateController,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Logique pour générer un rapport basé sur les dates sélectionnées
              },
              child: Text('Générer le rapport'),
            ),
          ],
        ),
      ),
    );
  }
}
