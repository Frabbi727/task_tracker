import 'package:get/get.dart';

import '../controllers/task_controller.dart';
import '../repositories/task_repository.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<TaskController>(
      () => TaskController(Get.find<TaskRepository>()),
      fenix: true,
    );
  }
}
