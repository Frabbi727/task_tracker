import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_section.dart';

class TaskListPage extends GetView<TaskController> {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: controller.updateSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Search tasks',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TaskFilterSection(
                selectedFilter: controller.selectedFilter.value,
                onSelected: controller.updateFilter,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final tasks = controller.filteredTasks;

                if (tasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks found. Add a new task to get started.',
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      onTap: () => Get.toNamed(
                        AppRoutes.taskDetails,
                        arguments: task.id,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addTask),
        child: const Icon(Icons.add),
      ),
    );
  }
}
