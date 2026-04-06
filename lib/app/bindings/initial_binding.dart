import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../../core/network/api_client.dart';
import '../../features/repositories/status_repository.dart';
import '../../features/repositories/task_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }
    Get.lazyPut<Dio>(ApiClient.create, fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<StatusRepository>(
      () => StatusRepository(Get.find<Dio>()),
      fenix: true,
    );
  }
}
