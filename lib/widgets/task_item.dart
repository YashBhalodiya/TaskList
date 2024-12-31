import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem(
      {super.key,
      required this.task,
      required this.onToggleComplete,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.title), //unique key
      direction: DismissDirection.horizontal, // in both direction
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: task.isCompleted ? Colors.green : null,
            ),
            onPressed: onToggleComplete,
          ),
          onTap: onEdit,
        ),
      ),
    );
  }
}
