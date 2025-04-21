import 'package:to_do/services/interfaces/abstractcalendar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;



class GoogleCalender extends AbstractCalendar {
  late final Map<String, String> authHeaders;
  late final GoogleSignInAuthentication googleAuth;
  late final http.Client httpClient;
  late final calendar.CalendarApi calendarApi;
  late final GoogleSignIn googleSignIn;

    calendar.Event _convertToCalendarEvent(EventData event) {
    return calendar.Event()
      ..summary = event.description
      ..description = event.description
      ..start = calendar.EventDateTime(
        dateTime: event.startTime,
        timeZone: event.timeZone,
      )
      ..end = calendar.EventDateTime(
        dateTime: event.endTime,
        timeZone: event.timeZone,
      )
      ..location = event.location
      ..attendees = event.attendeesEmails?.map((email) => 
        calendar.EventAttendee()..email = email
      ).toList();
  }

  @override
  Future<String> addEvent(EventData event) async {
    try {
      final eventToAdd = _convertToCalendarEvent(event);
      final response = await calendarApi.events.insert(eventToAdd, "primary");
      return response.id ?? "";
    } catch (e) {
      print("Error adding event: $e");
      return "";
    }
  }

  @override
  Future<bool> connect() async {
    googleSignIn = GoogleSignIn(
      scopes: const ['email', 'https://www.googleapis.com/auth/calendar'],
    );

    final account =
        await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
    if (account == null) {
      return false;
    }

    authHeaders = await account.authHeaders;
    googleAuth = await account.authentication;

    httpClient = auth.authenticatedClient(
      http.Client(),
      auth.AccessCredentials(
        auth.AccessToken(
          'Bearer',
          authHeaders['Authorization']!.split(' ').last,
          DateTime.now().toUtc().add(const Duration(hours: 1)),
        ),
        googleAuth.idToken,
        ['https://www.googleapis.com/auth/calendar'],
      ),
    );
    calendarApi = calendar.CalendarApi(httpClient);
    return true;
  }

  @override
  void deleteEvent(String eventId) {
    calendarApi.events.delete("primary", eventId);
  }

  @override
  Future<bool> disconnect() async {
    try {
      await googleSignIn.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> updateEvent(EventData event, String id) async {
    final eventToUpdate = null;// = (event as GoogleEvent).toEvent();

    try {
      final updatedEvent = await calendarApi.events.update(
        eventToUpdate,
        "primary",
        id,
      );

      if (updatedEvent.status == "confirmed") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
