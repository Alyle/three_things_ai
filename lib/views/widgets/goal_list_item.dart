import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../models/goal.dart';

class GoalListItem extends StatelessWidget {
  final Goal goal;
  final int index;
  final void Function(String) onDelete;
  final void Function(String) onStatusChange;
  final Function() onTap;

  const GoalListItem({
    required this.goal,
    required this.index,
    required this.onDelete,
    required this.onStatusChange,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
      key: Key(goal.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.15,
        children: [
          CustomSlidableAction(
            backgroundColor: Colors.red[100]!,
            onPressed: (_) => onDelete(goal.id),
            child: Icon(Icons.delete, color: Colors.red[900]),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.surface,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(goal.title),
          subtitle: Text(goal.description),
          trailing: Checkbox(
            value: goal.isCompleted,
            onChanged: (_) => onStatusChange(goal.id),
            activeColor: theme.colorScheme.primary,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
} 