import 'package:get/get.dart';

import '../repositories/task_repository.dart';
import 'add_task_controller.dart';

class AddTaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTaskController>(
      () => AddTaskController(Get.find<TaskRepository>()),
    );
  }
}
