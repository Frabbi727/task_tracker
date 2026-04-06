import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_tracker/features/tasks/models/status_response.dart';
import 'package:task_tracker/features/tasks/models/task_model.dart';
import 'package:task_tracker/features/tasks/repositories/task_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.flutter.io/path_provider');

  group('TaskRepository', () {
    setUp(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              final directory = await Directory.systemTemp.createTemp(
                'task_test',
              );
              return directory.path;
            }
            return null;
          });

      await GetStorage.init('test_box');
      final storage = GetStorage('test_box');
      await storage.erase();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('saves and loads tasks from local storage', () async {
      final repository = TaskRepositoryTestable();

      final tasks = [
        TaskModel(
          id: '1',
          title: 'Client meeting',
          description: 'Visit client office',
          date: DateTime(2026, 4, 6),
          status: 'PENDING',
          category: TaskCategory.clientVisit,
        ),
      ];

      await repository.saveTasks(tasks);
      final loadedTasks = repository.loadTasks();

      expect(loadedTasks, hasLength(1));
      expect(loadedTasks.first.title, 'Client meeting');
      expect(loadedTasks.first.status, 'PENDING');
      expect(loadedTasks.first.category, TaskCategory.clientVisit);
    });

    test('parses status response json', () {
      final response = StatusResponse.fromJson({
        'success': true,
        'code': 'TR200',
        'message': 'Statuses retrieved successfully',
        'data': {
          'statuses': ['PENDING', 'COMPLETED'],
        },
      });

      expect(response.success, isTrue);
      expect(response.data.statuses, ['PENDING', 'COMPLETED']);
    });
  });
}

class TaskRepositoryTestable extends TaskRepository {
  TaskRepositoryTestable() : super.test(GetStorage('test_box'));
}
