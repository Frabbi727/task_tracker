import 'package:get/get.dart';

import '../../features/add_task/add_task_binding.dart';
import '../../features/add_task/add_task_page.dart';
import '../../features/task_details/task_details_binding.dart';
import '../../features/task_details/task_details_page.dart';
import '../../features/task_list/task_list_binding.dart';
import '../../features/task_list/task_list_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.tasks,
      page: () => const TaskListPage(),
      binding: TaskListBinding(),
    ),
    GetPage(
      name: AppRoutes.addTask,
      page: () => const AddTaskPage(),
      binding: AddTaskBinding(),
    ),
    GetPage(
      name: AppRoutes.taskDetails,
      page: () => const TaskDetailsPage(),
      binding: TaskDetailsBinding(),
    ),
  ];
}
