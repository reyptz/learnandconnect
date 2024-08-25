import 'package:flutter/material.dart';
import 'kanban_column.dart';
import 'kanban_card.dart';

class KanbanBoard extends StatefulWidget {
  @override
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard> {
  final List<String> columns = ["À faire", "En cours", "Terminé"];
  final Map<String, List<KanbanCard>> tasks = {
    "À faire": [
      KanbanCard(title: "Tâche 1", description: "Description de la tâche 1"),
      KanbanCard(title: "Tâche 2", description: "Description de la tâche 2"),
    ],
    "En cours": [
      KanbanCard(title: "Tâche 3", description: "Description de la tâche 3"),
    ],
    "Terminé": [
      KanbanCard(title: "Tâche 4", description: "Description de la tâche 4"),
    ],
  };

  void onCardDropped(String column, KanbanCard card) {
    setState(() {
      // Retirer la carte de la colonne précédente
      tasks.forEach((key, value) {
        value.remove(card);
      });

      // Ajouter la carte à la nouvelle colonne
      tasks[column]!.add(card);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau Kanban"),
      ),
      body: Row(
        children: columns.map((column) {
          return Expanded(
            child: KanbanColumn(
              title: column,
              cards: tasks[column]!,
              onCardDropped: onCardDropped,
            ),
          );
        }).toList(),
      ),
    );
  }
}
