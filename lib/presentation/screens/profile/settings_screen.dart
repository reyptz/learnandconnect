import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Activer/Désactiver les notifications push'),
            trailing: Switch(
              value: true, // Exemple: l'état de l'option
              onChanged: (value) {
                // Action pour activer/désactiver les notifications
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Langue'),
            subtitle: Text('Changer la langue de l\'application'),
            trailing: DropdownButton<String>(
              value: 'fr',
              onChanged: (String? newValue) {
                // Action pour changer la langue
              },
              items: <String>['fr', 'en']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'fr' ? 'Français' : 'English'),
                );
              }).toList(),
            ),
          ),
          // Ajoutez d'autres paramètres ici
        ],
      ),
    );
  }
}
