import 'package:get/get.dart';

import '../../features/tasks/bindings/task_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    TaskBinding().dependencies();
  }
}
