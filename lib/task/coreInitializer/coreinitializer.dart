import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/task/containers/storages.dart';
import 'package:to_do/task/interfaces/abstractcoreinitializer.dart';
import 'package:hive/hive.dart';
import 'package:to_do/task/persistant_storage/taskMarsheller.dart';

class Coreinitializer extends AbstractCoreInitializer {
  @override
  Future<TaskStorage> getTaskStorage() async {
    return await make_tasks_storage('Tasks');
  }

  @override
  Future<void> initDatabases() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskMarsheller());
  }
}
