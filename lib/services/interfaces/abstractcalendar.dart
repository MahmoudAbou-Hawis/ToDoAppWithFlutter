class EventData {
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String timeZone;
  final String? location;
  final List<String>? attendeesEmails;

  EventData({
    required this.description,
    required this.startTime,
    required this.endTime,
    this.timeZone = 'GMT+02:00',
    this.location ='',
    this.attendeesEmails = const [],
  });
}

abstract class AbstractCalendar {
  Future<String> addEvent(EventData event);
  void deleteEvent(String eventId);
  Future<bool> updateEvent(EventData event, String id);
  Future<bool> connect();
  Future<bool>  disconnect();
}
