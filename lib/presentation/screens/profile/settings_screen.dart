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
