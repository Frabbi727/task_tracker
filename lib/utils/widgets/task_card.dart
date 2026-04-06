import 'package:flutter/material.dart';

import '../../core/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onTap});

  final TaskModel task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCompleted = task.status == 'COMPLETED';
    final statusTone = _statusTone(colorScheme, isCompleted);
    final priorityTone = _priorityTone(task.priority);
    final categoryTone = _categoryTone(task.category);
    final dueTone = _neutralTone(colorScheme);
    final description = task.description.trim().isEmpty
        ? 'No description added'
        : task.description.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sectionTitle(task.category),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: categoryTone.foreground,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Pill(
                      icon: isCompleted
                          ? Icons.check_circle_outline
                          : Icons.schedule_outlined,
                      label: task.status,
                      tone: statusTone,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _Pill(
                      icon: Icons.flag_outlined,
                      label: task.priority,
                      tone: priorityTone,
                    ),
                    _Pill(
                      icon: Icons.folder_open_outlined,
                      label: task.category.label,
                      tone: categoryTone,
                    ),
                    _Pill(
                      icon: Icons.calendar_today_outlined,
                      label: _formatDate(task.date),
                      tone: dueTone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _sectionTitle(TaskCategory category) {
    switch (category) {
      case TaskCategory.clientVisit:
        return 'Client Visit';
      case TaskCategory.general:
        return 'General Task';
    }
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  _PillTone _statusTone(ColorScheme colorScheme, bool isCompleted) {
    return isCompleted
        ? const _PillTone(
            background: Color(0xFFE8F5EC),
            border: Color(0xFF8FD0A4),
            foreground: Color(0xFF1D6B3A),
          )
        : const _PillTone(
            background: Color(0xFFFFF2E2),
            border: Color(0xFFF3B56B),
            foreground: Color(0xFF9A5712),
          );
  }

  _PillTone _priorityTone(String priority) {
    switch (priority) {
      case 'High':
        return const _PillTone(
          background: Color(0xFFFDECEC),
          border: Color(0xFFF0A7A7),
          foreground: Color(0xFFB42318),
        );
      case 'Low':
        return const _PillTone(
          background: Color(0xFFEAF7F0),
          border: Color(0xFF9DD3B2),
          foreground: Color(0xFF1F7A4D),
        );
      case 'Medium':
      default:
        return const _PillTone(
          background: Color(0xFFFFF6E5),
          border: Color(0xFFE9C46A),
          foreground: Color(0xFF9A6700),
        );
    }
  }

  _PillTone _categoryTone(TaskCategory category) {
    switch (category) {
      case TaskCategory.clientVisit:
        return const _PillTone(
          background: Color(0xFFEAF2FF),
          border: Color(0xFF9CB9F7),
          foreground: Color(0xFF2557B7),
        );
      case TaskCategory.general:
        return const _PillTone(
          background: Color(0xFFF2EEFF),
          border: Color(0xFFC2B4F8),
          foreground: Color(0xFF5B44B5),
        );
    }
  }

  _PillTone _neutralTone(ColorScheme colorScheme) {
    return _PillTone(
      background: colorScheme.surfaceContainerHighest,
      border: colorScheme.outlineVariant,
      foreground: colorScheme.onSurfaceVariant,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final _PillTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: tone.foreground),
          const SizedBox(width: 7),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: tone.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTone {
  const _PillTone({
    required this.background,
    required this.border,
    required this.foreground,
  });

  final Color background;
  final Color border;
  final Color foreground;
}
