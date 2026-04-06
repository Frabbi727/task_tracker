import 'package:get/get.dart';

import '../../core/models/task_model.dart';
import '../repositories/task_repository.dart';

class AddTaskController extends GetxController {
  AddTaskController(this._repository);

  final TaskRepository _repository;

  TaskModel? findTaskById(String id) {
    try {
      return _repository.loadTasks().firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime date,
    required String priority,
    required TaskCategory category,
  }) async {
    final tasks = _repository.loadTasks();
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
    await _repository.saveTasks(tasks);
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
    required DateTime date,
    required String priority,
    required TaskCategory category,
  }) async {
    final tasks = _repository.loadTasks();
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      return;
    }

    tasks[index] = tasks[index].copyWith(
      title: title,
      description: description,
      date: date,
      priority: priority,
      category: category,
    );
    await _repository.saveTasks(tasks);
  }
}
