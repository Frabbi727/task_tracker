import 'package:get/get.dart';

import '../repositories/task_repository.dart';
import 'task_details_controller.dart';

class TaskDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskDetailsController>(
      () => TaskDetailsController(Get.find<TaskRepository>()),
    );
  }
}
