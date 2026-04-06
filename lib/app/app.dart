import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/theme_controller.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put<ThemeController>(ThemeController(), permanent: true);

    return Obx(
      () => GetMaterialApp(
        title: 'Task Tracker',
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.tasks,
        getPages: AppPages.pages,
        themeMode: themeController.themeMode.value,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
