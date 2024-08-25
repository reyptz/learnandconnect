import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/activity_log/activity_log_bloc.dart';
import '../../widgets/activity_log_card.dart';

class ActivityLogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journaux d\'activité'),
      ),
      body: BlocBuilder<ActivityLogBloc, ActivityLogState>(
        builder: (context, state) {
          if (state is ActivityLogLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ActivityLogLoaded) {
            return ListView.builder(
              itemCount: state.activityLogs.length,
              itemBuilder: (context, index) {
                final log = state.activityLogs[index];
                return ActivityLogCard(log: log);
              },
            );
          } else if (state is ActivityLogError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucun journal d\'activité disponible.'));
          }
        },
      ),
    );
  }
}
