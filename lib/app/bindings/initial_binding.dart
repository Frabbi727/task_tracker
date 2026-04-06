import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../controllers/theme_controller.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/storage_keys.dart';
import '../../features/repositories/status_repository.dart';
import '../../features/repositories/task_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ThemeController>()) {
      Get.put<ThemeController>(ThemeController(), permanent: true);
    }
    Get.lazyPut<Dio>(ApiClient.create, fenix: true);
    Get.lazyPut<Box<dynamic>>(
      () => Hive.box<dynamic>(StorageKeys.tasksBox),
      fenix: true,
    );
    Get.lazyPut<TaskRepository>(
      () => TaskRepository(Get.find<Box<dynamic>>()),
      fenix: true,
    );
    Get.lazyPut<StatusRepository>(
      () => StatusRepository(Get.find<Dio>()),
      fenix: true,
    );
  }
}
