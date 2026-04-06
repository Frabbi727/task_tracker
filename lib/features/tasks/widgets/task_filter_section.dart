import 'package:flutter/material.dart';

import '../controllers/task_controller.dart';

class TaskFilterSection extends StatelessWidget {
  const TaskFilterSection({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  final TaskFilter selectedFilter;
  final ValueChanged<TaskFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: TaskFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = TaskFilter.values[index];
          return ChoiceChip(
            label: Text(filter.label),
            selected: selectedFilter == filter,
            onSelected: (_) => onSelected(filter),
          );
        },
      ),
    );
  }
}
