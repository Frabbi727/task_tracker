import 'package:flutter/material.dart';

class TaskFilterSection extends StatelessWidget {
  const TaskFilterSection({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return ChoiceChip(
            label: Text(filter),
            selected: selectedFilter == filter,
            onSelected: (_) => onSelected(filter),
          );
        },
      ),
    );
  }
}
