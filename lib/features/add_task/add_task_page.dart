import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/task_model.dart';
import 'add_task_controller.dart';

class AddTaskPage extends GetView<AddTaskController> {
  const AddTaskPage({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.updateDate(pickedDate);
    }
  }

  Future<void> _saveTask(BuildContext context) async {
    await controller.saveTask();

    if (!context.mounted) {
      return;
    }

    if (!controller.formKey.currentState!.validate()) {
      return;
    }

    final isEditMode = controller.isEditMode;
    Get.back();
    if (!Get.testMode) {
      Get.snackbar(
        'Success',
        isEditMode ? 'Task updated locally.' : 'Task saved locally.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEditMode = controller.isEditMode;
      final selectedDate = controller.selectedDate.value;
      final selectedPriority = controller.selectedPriority.value;
      final selectedCategory = controller.selectedCategory.value;

      return Scaffold(
        appBar: AppBar(title: Text(isEditMode ? 'Edit Task' : 'Add Task')),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    key: const Key('task_title_field'),
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('task_description_field'),
                    controller: controller.descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    key: const Key('task_date_tile'),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Task Date'),
                    subtitle: Text(_formatDate(selectedDate)),
                    trailing: const Icon(Icons.calendar_month),
                    onTap: () => _pickDate(context),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskPriority>(
                    initialValue: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskPriority.values
                        .map(
                          (priority) => DropdownMenuItem<TaskPriority>(
                            value: priority,
                            child: Text(priority.value),
                          ),
                        )
                        .toList(),
                    onChanged: controller.updatePriority,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskCategory>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: TaskCategory.values
                        .map(
                          (category) => DropdownMenuItem<TaskCategory>(
                            value: category,
                            child: Text(category.label),
                          ),
                        )
                        .toList(),
                    onChanged: controller.updateCategory,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('task_save_button'),
                      onPressed: () => _saveTask(context),
                      child: Text(isEditMode ? 'Update Task' : 'Save Task'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
