import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../app/controllers/theme_controller.dart';
import '../../utils/widgets/task_card.dart';
import '../../utils/widgets/task_filter_section.dart';
import 'task_list_controller.dart';

class TaskListPage extends GetView<TaskListController> {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        actions: [
          Obx(
            () => IconButton(
              onPressed: themeController.toggleTheme,
              icon: Icon(
                themeController.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              tooltip: themeController.isDarkMode
                  ? 'Switch to light mode'
                  : 'Switch to dark mode',
            ),
          ),
        ],
      ),
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
                filters: controller.availableFilters,
                selectedFilter: controller.selectedStatusFilter.value,
                onSelected: controller.updateStatusFilter,
              ),
            ),
            Obx(() {
              if (controller.isStatusLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Loading status filters...'),
                  ),
                );
              }

              if (controller.statusError.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(controller.statusError.value),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
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
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.taskDetails,
                          arguments: task.id,
                        );
                        controller.loadTasks();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.toNamed(AppRoutes.addTask);
          controller.loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
