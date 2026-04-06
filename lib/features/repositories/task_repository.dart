import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';

import '../../../core/constants/storage_keys.dart';
import '../../core/models/task_model.dart';

class TaskRepository {
  TaskRepository(
    Box<dynamic> box, {
    GetStorage? legacyStorage,
  }) : _box = box,
       _legacyStorage = legacyStorage ?? GetStorage();

  TaskRepository.test(
    Box<dynamic> box, {
    GetStorage? legacyStorage,
  }) : _box = box,
       _legacyStorage = legacyStorage ?? GetStorage();

  final Box<dynamic> _box;
  final GetStorage _legacyStorage;

  List<TaskModel> loadTasks() {
    final rawTasks = _box.get(StorageKeys.tasks) ?? _migrateLegacyTasksIfNeeded();

    if (rawTasks is! List) {
      return <TaskModel>[];
    }

    return rawTasks
        .whereType<Map>()
        .map((task) => TaskModel.fromJson(Map<String, dynamic>.from(task)))
        .toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) {
    final payload = tasks.map((task) => task.toJson()).toList();
    return _box.put(StorageKeys.tasks, payload);
  }

  List<dynamic>? _migrateLegacyTasksIfNeeded() {
    if (_box.containsKey(StorageKeys.tasks)) {
      return null;
    }

    final legacyTasks =
        _legacyStorage.read<List<dynamic>>(StorageKeys.tasks) ?? <dynamic>[];
    if (legacyTasks.isEmpty) {
      return null;
    }

    _box.put(StorageKeys.tasks, legacyTasks);
    return legacyTasks;
  }
}
