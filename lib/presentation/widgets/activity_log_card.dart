import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import 'package:learnandconnect/core/utils/date_utils.dart' as util;


class ActivityLogCard extends StatelessWidget {
  final ActivityLog activityLog;

  const ActivityLogCard({
    Key? key,
    required this.activityLog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activityLog.action,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Utilisateur : ${activityLog.metadata['userId']}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              "Détails : ${activityLog.metadata}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              util.DateUtils.formatDate(activityLog.createdAt), // Utilisation de votre utilitaire de date
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime timestamp) {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year} à ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}
