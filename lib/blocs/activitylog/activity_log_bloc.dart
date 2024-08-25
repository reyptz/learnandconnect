import 'package:flutter_bloc/flutter_bloc.dart';
import 'activity_log_event.dart';
import 'activity_log_state.dart';
import '../../core/services/activity_log_service.dart';
import '../../data/models/user_model.dart';

class ActivityLogBloc extends Bloc<ActivityLogEvent, ActivityLogState> {
  final ActivityLogService _activityLogService;

  ActivityLogBloc(this._activityLogService) : super(ActivityLogInitial());

  @override
  Stream<ActivityLogState> mapEventToState(ActivityLogEvent event) async* {
    if (event is LoadActivityLogs) {
      yield ActivityLogLoading();
      try {
        final activityLogs = await _activityLogService.getActivityLogs();
        yield ActivityLogLoaded(activityLogs: activityLogs);
      } catch (e) {
        yield ActivityLogError(message: e.toString());
      }
    } else if (event is AddActivityLog) {
      try {
        await _activityLogService.addActivityLog(event.activityLog);
        add(LoadActivityLogs());  // Recharge les journaux après ajout
      } catch (e) {
        yield ActivityLogError(message: e.toString());
      }
    }
  }
}
