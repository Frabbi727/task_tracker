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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeController = Get.find<ThemeController>();
    final iconColor =
        theme.appBarTheme.foregroundColor ?? colorScheme.onSurface;

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
                color: iconColor,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track work with clearer priorities, categories, and status.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by title or description',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.4,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 18),
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
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 36,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No tasks found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try a different search or add a new task to get started.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
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
