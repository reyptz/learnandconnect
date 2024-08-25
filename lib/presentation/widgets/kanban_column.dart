import 'package:flutter/material.dart';
import 'kanban_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<KanbanCard> cards;
  final Function(String, KanbanCard) onCardDropped;

  const KanbanColumn({
    Key? key,
    required this.title,
    required this.cards,
    required this.onCardDropped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<KanbanCard>(
      onAccept: (card) {
        onCardDropped(title, card);
      },
      builder: (context, candidateData, rejectedData) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  children: cards.map((card) {
                    return Draggable<KanbanCard>(
                      data: card,
                      child: card,
                      feedback: Material(
                        child: card,
                      ),
                      childWhenDragging: Container(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
