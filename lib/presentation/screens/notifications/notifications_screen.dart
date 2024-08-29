import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../blocs/notification/notification_state.dart';
import '../../widgets/notification_card.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onMarkAsRead: () {
                    BlocProvider.of<NotificationBloc>(context).add(
                      MarkNotificationAsRead(notificationId: notification.notificationId),
                    );
                  },
                );
              },
            );
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucune notification disponible.'));
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
