import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:task_tracker/app/controllers/theme_controller.dart';
import 'package:task_tracker/core/models/status_response.dart';
import 'package:task_tracker/core/models/task_model.dart';
import 'package:task_tracker/features/add_task/add_task_controller.dart';
import 'package:task_tracker/features/add_task/add_task_page.dart';
import 'package:task_tracker/features/repositories/task_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  Get.testMode = true;

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
          .setMockMethodCallHandler(channel, (methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              final directory = await Directory.systemTemp.createTemp(
                'task_test',
              );
              return directory.path;
            }
            return null;
          });
    });

    test('saves and loads tasks from local storage', () async {
      final repository = TaskRepositoryTestable();

      final tasks = [
        TaskModel(
          id: '1',
          title: 'Client meeting',
          description: 'Visit client office',
          date: DateTime(2026, 4, 6),
          priority: 'High',
          status: 'PENDING',
          category: TaskCategory.clientVisit,
        ),
      ];

      await repository.saveTasks(tasks);
      final loadedTasks = repository.loadTasks();

      expect(loadedTasks, hasLength(1));
      expect(loadedTasks.first.title, 'Client meeting');
      expect(loadedTasks.first.priority, 'High');
      expect(loadedTasks.first.status, 'PENDING');
      expect(loadedTasks.first.category, TaskCategory.clientVisit);
    });

    test('loads legacy task without priority using default value', () {
      final task = TaskModel.fromJson({
        'id': '2',
        'title': 'Old task',
        'description': 'Saved before priority existed',
        'date': '2026-04-06T00:00:00.000',
        'status': 'PENDING',
        'category': 'general',
      });

      expect(task.priority, 'Medium');
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

  group('AddTaskPage', () {
    late TaskRepositoryTestable repository;

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
      await GetStorage('test_box').erase();
      Get.reset();
      repository = TaskRepositoryTestable();
      Get.put<AddTaskController>(AddTaskController(repository));
    });

    tearDown(() {
      Get.reset();
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
    });

    testWidgets('shows today as the default date for a new task', (
      tester,
    ) async {
      final today = _formatDate(DateTime.now());

      await tester.pumpWidget(const GetMaterialApp(home: AddTaskPage()));

      expect(find.byKey(const Key('task_date_tile')), findsOneWidget);
      expect(find.text(today), findsOneWidget);
    });

    testWidgets('shows validation error when title is empty', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: AddTaskPage()));

      await tester.tap(find.byKey(const Key('task_save_button')));
      await tester.pumpAndSettle();

      expect(find.text('Title is required'), findsOneWidget);
    });

    test('saves with valid title and empty description', () async {
      final controller = Get.find<AddTaskController>();

      await controller.addTask(
        title: 'New task',
        description: '',
        date: DateTime.now(),
        priority: 'Medium',
        category: TaskCategory.general,
      );

      final tasks = repository.loadTasks();
      expect(tasks, hasLength(1));
      expect(tasks.first.title, 'New task');
      expect(tasks.first.description, isEmpty);
      expect(tasks.first.priority, 'Medium');
      expect(tasks.first.category, TaskCategory.general);
    });
  });

  group('ThemeController', () {
    test('defaults to light mode and persists dark mode toggle', () async {
      await GetStorage.init('theme_box');
      final storage = GetStorage('theme_box');
      await storage.erase();

      final controller = ThemeController(storage);
      controller.onInit();

      expect(controller.themeMode.value, ThemeMode.light);

      controller.toggleTheme();

      expect(controller.themeMode.value, ThemeMode.dark);
      expect(storage.read<String>('theme_mode'), ThemeMode.dark.name);
    });
  });
}

class TaskRepositoryTestable extends TaskRepository {
  TaskRepositoryTestable() : super.test(GetStorage('test_box'));
}

String _formatDate(DateTime date) {
  final normalized = DateTime(date.year, date.month, date.day);
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day';
}
