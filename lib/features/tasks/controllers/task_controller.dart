import 'package:get/get.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';

enum TaskFilter { all, pending, completed, clientVisit }

extension TaskFilterX on TaskFilter {
  String get label {
    switch (this) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.clientVisit:
        return 'Client Visit';
    }
  }
}

class TaskController extends GetxController {
  TaskController(this._repository);

  final TaskRepository _repository;

  final tasks = <TaskModel>[].obs;
  final searchQuery = ''.obs;
  final selectedFilter = TaskFilter.all.obs;

  List<TaskModel> get filteredTasks {
    final query = searchQuery.value.trim().toLowerCase();

    return tasks.where((task) {
      final matchesQuery =
          query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);

      final matchesFilter = switch (selectedFilter.value) {
        TaskFilter.all => true,
        TaskFilter.pending => !task.isCompleted,
        TaskFilter.completed => task.isCompleted,
        TaskFilter.clientVisit => task.category == TaskCategory.clientVisit,
      };

      return matchesQuery && matchesFilter;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() {
    tasks.assignAll(_repository.loadTasks());
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime date,
    required TaskCategory category,
  }) async {
    final task = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      date: date,
      isCompleted: false,
      category: category,
    );

    tasks.add(task);
    await _persistTasks();
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final task = tasks[index];
    tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    tasks.refresh();
    await _persistTasks();
  }

  Future<void> deleteTask(String taskId) async {
    tasks.removeWhere((task) => task.id == taskId);
    await _persistTasks();
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  void updateFilter(TaskFilter filter) {
    selectedFilter.value = filter;
  }

  TaskModel? findTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistTasks() {
    return _repository.saveTasks(tasks);
  }
}
