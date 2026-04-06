import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../controllers/task_controller.dart';
import '../repositories/status_repository.dart';
import '../repositories/task_repository.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(ApiClient.create, fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<StatusRepository>(
      () => StatusRepository(Get.find<Dio>()),
      fenix: true,
    );
    Get.lazyPut<TaskController>(
      () => TaskController(
        Get.find<TaskRepository>(),
        Get.find<StatusRepository>(),
      ),
      fenix: true,
    );
  }
}
