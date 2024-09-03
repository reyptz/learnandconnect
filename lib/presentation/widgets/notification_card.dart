import 'package:flutter/material.dart';
import 'package:learnandconnect/data/models/notification_model.dart' as custom;
import '../../../core/constants/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final custom.Notification notification; // Utilisation de l'alias 'custom'
  final VoidCallback onDelete;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor, // Main color for the notification background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.notificationText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _formatDate(notification.createdAt),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String notificationType) {
    switch (notificationType) {
      case "Push":
        return Icon(Icons.notifications, color: AppColors.primaryColor);
      case "Email":
        return Icon(Icons.email, color: AppColors.primaryColor);
      default:
        return Icon(Icons.info, color: AppColors.primaryColor);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
