import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/activitylog/activity_log_bloc.dart';
import '../../../blocs/activitylog/activity_log_state.dart';
import '../../widgets/activity_log_card.dart';

class ActivityLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journaux d\'activité'),
      ),
      body: BlocBuilder<ActivityLogBloc, ActivityLogState>(
        builder: (context, state) {
          if (state is ActivityLogLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ActivityLogLoaded) {
            return ListView.builder(
              itemCount: state.activityLogs.length,
              itemBuilder: (context, index) {
                final activityLog = state.activityLogs[index];
                return ActivityLogCard(activityLog: activityLog);
              },
            );
          } else if (state is ActivityLogError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucun journal d\'activité disponible.'));
          }
        },
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