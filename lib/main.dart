import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/constants/storage_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(StorageKeys.tasksBox);
  runApp(const TaskTrackerApp());
}
