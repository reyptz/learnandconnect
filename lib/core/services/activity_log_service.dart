import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class ActivityLogService {
  final CollectionReference activityLogCollection =
  FirebaseFirestore.instance.collection('activity_logs');

  Future<List<ActivityLog>> getActivityLogs() async {
    try {
      QuerySnapshot snapshot = await activityLogCollection.get();
      return snapshot.docs.map((doc) => ActivityLog.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des journaux d\'activité: $e');
    }
  }

  Future<void> addActivityLog(ActivityLog activityLog) async {
    try {
      await activityLogCollection.add(activityLog.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du journal d\'activité: $e');
    }
  }
}
