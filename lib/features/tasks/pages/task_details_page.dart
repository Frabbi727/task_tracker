import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class TaskDetailsPage extends GetView<TaskController> {
  const TaskDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskId = Get.arguments as String?;

    if (taskId == null) {
      return const _MissingTaskView();
    }

    return Obx(() {
      final task = controller.findTaskById(taskId);

      if (task == null) {
        return const _MissingTaskView();
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
          actions: [
            IconButton(
              onPressed: () =>
                  Get.toNamed(AppRoutes.addTask, arguments: task.id),
              icon: const Icon(Icons.edit),
              tooltip: 'Edit task',
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Category', value: task.category.label),
                const SizedBox(height: 8),
                _DetailRow(
                  label: 'Status',
                  value: task.isCompleted ? 'Completed' : 'Pending',
                ),
                const SizedBox(height: 8),
                _DetailRow(label: 'Date', value: _formatDate(task.date)),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  task.description.isEmpty
                      ? 'No description added.'
                      : task.description,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: () => controller.toggleTaskStatus(task.id),
                    child: Text(
                      task.isCompleted
                          ? 'Mark as Pending'
                          : 'Mark as Completed',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text('Delete Task'),
                          content: const Text(
                            'Are you sure you want to delete this task?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Get.back(result: true),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (shouldDelete != true) {
                        return;
                      }

                      await controller.deleteTask(task.id);
                      Get.back();
                      Get.snackbar(
                        'Deleted',
                        'Task removed from local storage.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: const Text('Delete Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text('$label:')),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class _MissingTaskView extends StatelessWidget {
  const _MissingTaskView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: const Center(child: Text('Task not found.')),
    );
  }
}
