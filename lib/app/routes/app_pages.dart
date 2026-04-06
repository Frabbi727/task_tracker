import 'package:get/get.dart';

import '../../features/tasks/pages/add_task_page.dart';
import '../../features/tasks/pages/task_details_page.dart';
import '../../features/tasks/pages/task_list_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.tasks, page: () => const TaskListPage()),
    GetPage(name: AppRoutes.addTask, page: () => const AddTaskPage()),
    GetPage(name: AppRoutes.taskDetails, page: () => const TaskDetailsPage()),
  ];
}
