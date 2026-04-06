import 'package:get/get.dart';

import '../models/task_model.dart';
import '../repositories/status_repository.dart';
import '../repositories/task_repository.dart';

class TaskController extends GetxController {
  TaskController(this._repository, this._statusRepository);

  final TaskRepository _repository;
  final StatusRepository _statusRepository;

  final tasks = <TaskModel>[].obs;
  final statuses = <String>[].obs;
  final searchQuery = ''.obs;
  final selectedStatusFilter = 'All'.obs;
  final isStatusLoading = false.obs;
  final statusError = ''.obs;

  List<String> get availableFilters => ['All', ...statuses];

  List<TaskModel> get filteredTasks {
    final query = searchQuery.value.trim().toLowerCase();

    return tasks.where((task) {
      final matchesQuery =
          query.isEmpty ||
          task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query);

      final matchesFilter =
          selectedStatusFilter.value == 'All' ||
          task.status == selectedStatusFilter.value;

      return matchesQuery && matchesFilter;
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    loadStatuses();
  }

  void loadTasks() {
    tasks.assignAll(_repository.loadTasks());
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime date,
    required String priority,
    required TaskCategory category,
  }) async {
    final task = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      date: date,
      priority: priority,
      status: 'PENDING',
      category: category,
    );

    tasks.add(task);
    await _persistTasks();
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
    required DateTime date,
    required String priority,
    required TaskCategory category,
  }) async {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final task = tasks[index];
    tasks[index] = task.copyWith(
      title: title,
      description: description,
      date: date,
      priority: priority,
      category: category,
    );
    tasks.refresh();
    await _persistTasks();
  }

  Future<void> toggleTaskStatus(String taskId) async {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    final task = tasks[index];
    tasks[index] = task.copyWith(
      status: task.status == 'COMPLETED' ? 'PENDING' : 'COMPLETED',
    );
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

  Future<void> loadStatuses() async {
    isStatusLoading.value = true;
    statusError.value = '';

    try {
      final items = await _statusRepository.fetchStatuses();
      statuses.assignAll(items);
    } catch (_) {
      statuses.clear();
      statusError.value = 'Unable to load statuses.';
    } finally {
      isStatusLoading.value = false;
    }
  }

  void updateStatusFilter(String value) {
    selectedStatusFilter.value = value;
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
