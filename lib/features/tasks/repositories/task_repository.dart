import 'package:get_storage/get_storage.dart';

import '../../../core/constants/storage_keys.dart';
import '../models/task_model.dart';

class TaskRepository {
  TaskRepository([GetStorage? storage]) : _storage = storage ?? GetStorage();

  TaskRepository.test(GetStorage storage) : _storage = storage;

  final GetStorage _storage;

  List<TaskModel> loadTasks() {
    final rawTasks =
        _storage.read<List<dynamic>>(StorageKeys.tasks) ?? <dynamic>[];

    return rawTasks
        .whereType<Map<dynamic, dynamic>>()
        .map((task) => TaskModel.fromJson(Map<String, dynamic>.from(task)))
        .toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) {
    final payload = tasks.map((task) => task.toJson()).toList();
    return _storage.write(StorageKeys.tasks, payload);
  }
}
