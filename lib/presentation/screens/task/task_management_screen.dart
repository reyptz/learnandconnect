import 'package:flutter/material.dart';
import '../../widgets/kanban_board.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Tâches'),
      ),
      body: KanbanBoard(),
    );
  }
}
