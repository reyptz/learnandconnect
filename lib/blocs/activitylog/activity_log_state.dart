import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class ActivityLogState extends Equatable {
  const ActivityLogState();

  @override
  List<Object> get props => [];
}

class ActivityLogInitial extends ActivityLogState {}

class ActivityLogLoading extends ActivityLogState {}

class ActivityLogLoaded extends ActivityLogState {
  final List<ActivityLog> activityLogs;

  const ActivityLogLoaded({required this.activityLogs});

  @override
  List<Object> get props => [activityLogs];
}

class ActivityLogError extends ActivityLogState {
  final String message;

  const ActivityLogError({required this.message});

  @override
  List<Object> get props => [message];
}
