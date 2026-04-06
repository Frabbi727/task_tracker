import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../features/repositories/status_repository.dart';
import '../../features/repositories/task_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(ApiClient.create, fenix: true);
    Get.lazyPut<TaskRepository>(() => TaskRepository(), fenix: true);
    Get.lazyPut<StatusRepository>(
      () => StatusRepository(Get.find<Dio>()),
      fenix: true,
    );
  }
}
