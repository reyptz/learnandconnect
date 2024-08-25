import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../../core/services/notification_service.dart';
import '../../data/models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc(this._notificationService) : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is LoadNotifications) {
      yield NotificationLoading();
      try {
        final notifications = await _notificationService.getNotificationsByUserId(event.userId);
        yield NotificationLoaded(notifications: notifications);
      } catch (e) {
        yield NotificationError(message: e.toString());
      }
    } else if (event is MarkNotificationAsRead) {
      try {
        await _notificationService.markNotificationAsRead(event.notificationId);
        // Optionally reload notifications after marking one as read
        if (state is NotificationLoaded) {
          final userId = (state as NotificationLoaded).notifications.first.userId;
          add(LoadNotifications(userId: userId));
        }
      } catch (e) {
        yield NotificationError(message: e.toString());
      }
    } else if (event is UpdateNotification) {
      try {
        await _notificationService.updateNotification(event.notification);
        // Optionally reload notifications after an update
        if (state is NotificationLoaded) {
          final userId = (state as NotificationLoaded).notifications.first.userId;
          add(LoadNotifications(userId: userId));
        }
      } catch (e) {
        yield NotificationError(message: e.toString());
      }
    }
  }
}
