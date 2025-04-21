import 'package:hive/hive.dart';
import 'package:to_do/task/models/task.dart';

class TaskMarsheller extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task(
      email: reader.readString(),
      name: reader.readString(),
      id: reader.readString(),
      isCompleted: reader.readBool(),
      start: DateTime.parse(reader.readString()),
      end: DateTime.parse(reader.readString()),
      notes: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.email);
    writer.writeString(obj.name);
    writer.writeString(obj.id);
    writer.writeBool(obj.isCompleted);
    writer.writeString(obj.start.toIso8601String());
    writer.writeString(obj.end.toIso8601String());
    writer.writeString(obj.notes);
  }
}
