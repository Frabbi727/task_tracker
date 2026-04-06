import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/task_model.dart';
import '../repositories/task_repository.dart';

class AddTaskController extends GetxController {
  AddTaskController(this._repository);

  final TaskRepository _repository;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedDate = _dateOnly(DateTime.now()).obs;
  final selectedPriority = TaskPriority.medium.obs;
  final selectedCategory = TaskCategory.general.obs;
  final existingTask = Rxn<TaskModel>();

  bool get isEditMode => existingTask.value != null;

  @override
  void onInit() {
    super.onInit();
    final taskId = Get.arguments as String?;
    if (taskId == null) {
      return;
    }

    final task = findTaskById(taskId);
    if (task == null) {
      return;
    }

    existingTask.value = task;
    titleController.text = task.title;
    descriptionController.text = task.description;
    selectedDate.value = _dateOnly(task.date);
    selectedPriority.value = TaskPriorityX.fromValue(task.priority);
    selectedCategory.value = task.category;
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  TaskModel? findTaskById(String id) {
    try {
      return _repository.loadTasks().firstWhere((task) => task.id == id);
    } catch (_) {
      return null;
    }
  }

  void updatePriority(TaskPriority? value) {
    if (value == null) {
      return;
    }
    selectedPriority.value = value;
  }

  void updateCategory(TaskCategory? value) {
    if (value == null) {
      return;
    }
    selectedCategory.value = value;
  }

  void updateDate(DateTime value) {
    selectedDate.value = _dateOnly(value);
  }

  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (isEditMode) {
      await updateTask(
        taskId: existingTask.value!.id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate.value,
        priority: selectedPriority.value.value,
        category: selectedCategory.value,
      );
    } else {
      await addTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: selectedDate.value,
        priority: selectedPriority.value.value,
        category: selectedCategory.value,
      );
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

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
