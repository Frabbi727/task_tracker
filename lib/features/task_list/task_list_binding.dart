import 'package:get/get.dart';

import '../repositories/status_repository.dart';
import '../repositories/task_repository.dart';
import 'task_list_controller.dart';

class TaskListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskListController>(
      () => TaskListController(
        Get.find<TaskRepository>(),
        Get.find<StatusRepository>(),
      ),
    );
  }
}
