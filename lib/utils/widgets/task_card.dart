import 'package:flutter/material.dart';

import '../../core/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final TaskModel task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'COMPLETED';
    final statusColor = isCompleted ? Colors.green : Colors.orange;
    final priorityColor = _priorityColor(task.priority);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(label: Text(_formatDate(task.date))),
                  Chip(
                    label: Text(task.priority),
                    backgroundColor: priorityColor.withValues(alpha: 0.12),
                    side: BorderSide(color: priorityColor),
                  ),
                  Chip(label: Text(task.status)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Low':
        return Colors.green;
      case 'Medium':
      default:
        return Colors.orange;
    }
  }
}
