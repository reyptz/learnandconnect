import 'package:flutter/material.dart';
import 'package:learnandconnect/data/models/notification_model.dart' as custom;

class NotificationCard extends StatelessWidget {
  final custom.Notification notification; // Utilisation de l'alias 'custom'
  final VoidCallback onMarkAsRead;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onMarkAsRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(notification.notificationType),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.notificationText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              TextButton(
                onPressed: onMarkAsRead,
                child: Text(
                  'Marquer comme lu',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            if (notification.isRead)
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String notificationType) {
    switch (notificationType) {
      case "Push":
        return Icon(Icons.notifications, color: Colors.blue);
      case "Email":
        return Icon(Icons.email, color: Colors.orange);
      default:
        return Icon(Icons.info, color: Colors.grey);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
