import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/models/task_model.dart';
import '../repositories/status_repository.dart';
import '../repositories/task_repository.dart';

class TaskListController extends GetxController {
  TaskListController(this._repository, this._statusRepository);

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

  Future<void> loadStatuses() async {
    isStatusLoading.value = true;
    statusError.value = '';

    try {
      final items = await _statusRepository.fetchStatuses();
      statuses.assignAll(items);
    } on DioException {
      statuses.clear();
      statusError.value =
          'Unable to load status filters. Check your connection and try again.';
    } catch (_) {
      statuses.clear();
      statusError.value =
          'Unable to load status filters. Check your connection and try again.';
    } finally {
      isStatusLoading.value = false;
    }
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  void updateStatusFilter(String value) {
    selectedStatusFilter.value = value;
  }
}
