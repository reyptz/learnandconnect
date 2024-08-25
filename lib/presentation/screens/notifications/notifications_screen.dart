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
    );
  }
}
