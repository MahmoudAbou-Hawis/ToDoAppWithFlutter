import 'package:to_do/storage/interfaces/istorage.dart';
import 'package:to_do/task/models/task.dart';
import 'package:to_do/storage/dbFactory.dart';
import 'package:to_do/task/persistant_storage/taskMarsheller.dart';

typedef TaskStorage = IStorage<Task>;

String? getId(final Task task) {
  return task.id;
}

Future<TaskStorage> make_tasks_storage(String name) async {
  return await Dbfactory.createDb(
    name: name,
    marshaller: TaskMarsheller(),
    getId: getId,
  );
}
