import 'package:to_do/services/interfaces/abstractcalendar.dart';
import 'package:to_do/task/models/task.dart';

class ConnectionAdapter {
  AbstractCalendar? _calender;
  ConnectionAdapter(this._calender);
  Future<String?> addTask(Task task) async {
    return await _calender?.addEvent(
      EventData(
        description: task.notes,
        startTime: task.start,
        endTime: task.end,
      ),
    );
  }
}
