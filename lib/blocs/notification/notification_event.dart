import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;

  const LoadNotifications({required this.userId});

  @override
  List<Object> get props => [userId];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class UpdateNotification extends NotificationEvent {
  final Notification notification;

  const UpdateNotification({required this.notification});

  @override
  List<Object> get props => [notification];
}
