import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class ActivityLogEvent extends Equatable {
  const ActivityLogEvent();

  @override
  List<Object> get props => [];
}

class LoadActivityLogs extends ActivityLogEvent {}

class AddActivityLog extends ActivityLogEvent {
  final ActivityLog activityLog;

  const AddActivityLog({required this.activityLog});

  @override
  List<Object> get props => [activityLog];
}
