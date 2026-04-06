import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Tracker',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.tasks,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
