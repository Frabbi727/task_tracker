import 'package:get/get.dart';

import '../../core/models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskDetailsController extends GetxController {
  TaskDetailsController(this._repository);

  final TaskRepository _repository;

  final task = Rxn<TaskModel>();

  @override
  void onInit() {
    super.onInit();
    final taskId = Get.arguments as String?;
    if (taskId != null) {
      loadTask(taskId);
    }
  }

  void loadTask(String taskId) {
    try {
      task.value = _repository.loadTasks().firstWhere(
        (item) => item.id == taskId,
      );
    } catch (_) {
      task.value = null;
    }
  }

  Future<void> toggleTaskStatus() async {
    final currentTask = task.value;
    if (currentTask == null) {
      return;
    }

    final tasks = _repository.loadTasks();
    final index = tasks.indexWhere((item) => item.id == currentTask.id);
    if (index == -1) {
      return;
    }

    tasks[index] = tasks[index].copyWith(
      status: currentTask.status == 'COMPLETED' ? 'PENDING' : 'COMPLETED',
    );
    await _repository.saveTasks(tasks);
    task.value = tasks[index];
  }

  Future<void> deleteTask() async {
    final currentTask = task.value;
    if (currentTask == null) {
      return;
    }

    final tasks = _repository.loadTasks()
      ..removeWhere((item) => item.id == currentTask.id);
    await _repository.saveTasks(tasks);
    task.value = null;
  }
}
