import 'package:to_do/task/containers/storages.dart';

abstract class AbstractCoreInitializer {
  Future<void> initDatabases();
  Future<TaskStorage> getTaskStorage();
}
