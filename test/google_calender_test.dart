// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'google_calender_test.mocks.dart';

// @GenerateMocks([
//   GoogleSignIn,
//   GoogleSignInAccount,
//   GoogleSignInAuthentication,
//   calendar.CalendarApi,
//   lendar.EventsResource,
//   auth.AuthClient,
//   http.Client,
// ])
// void main() {
//   late GoogleCalender googleCalendar;
//   late MockGoogleSignIn mockGoogleSignIn;
//   late MockGoogleSignInAccount mockGoogleSignInAccount;
//   late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
//   late MockCalendarApi mockCalendarApi;
//   late MockEventsResource mockEvents;
//   late MockAuthClient mockAuthClient;

//   setUp(() {
         
//               leCalendar = GoogleCalender();c
//               kGoogleSignIn = MockGoogleSignIn();
//     mockGoogleSignInAccount = MockGoogleSignInAccount();
//     mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
//     mockCalendarApi = MockCalendarApi();
//     mockEvents = MockEventsResource();
//     mockAuthClient = MockAuthClient();

//     googleCalendar.googleSignIn = mockGoogleSignIn;
//     googleCalendar.calendarApi = mockCalendarApi;

//     when(mockCalendarApi.events).thenReturn(mockEvents);
//   });

//   test('addEvent returns event ID when insert is successful', () async {
//     final fakeEvent = calendar.Event()..id = 'abc123';
//     final googleEvent = GoogleEvent(
//       summary: 'Test',
//       description: 'Testing event',
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(Duration(hours: 1)),
//     );

//     when(mockEvents.insert(any, any)).thenAnswer((_) async => fakeEvent);

//     final result = await googleCalendar.addEvent(googleEvent);

//     expect(result, 'abc123');
//     verify(mockEvents.insert(any, "primary")).called(1);
//   });

  

//   test('disconnect returns true when sign-out is successful', () async {
//     when(mockGoogleSignIn.signOut()).thenAnswer((_) async => Future.value());

//     final result = await googleCalendar.disconnect();

//     expect(result, true);
//     verify(mockGoogleSignIn.signOut()).called(1);
//   });

//   test('disconnect returns false when sign-out fails', () async {
//     when(mockGoogleSignIn.signOut()).thenThrow(Exception('Sign out failed'));

//     final result = await googleCalendar.disconnect();

//     expect(result, false);
//     verify(mockGoogleSignIn.signOut()).called(1);
//   });

//   test('updateEvent returns true when update is successful', () async {
//     final fakeEvent = calendar.Event()..status = 'confirmed';
//     final googleEvent = GoogleEvent(
//       summary: 'Updated event',
//       description: 'Updated description',
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(Duration(hours: 1)),
//     );

//     when(mockEvents.update(any, any, any)).thenAnswer((_) async => fakeEvent);

//     final result = await googleCalendar.updateEvent(googleEvent, 'eventId');

//     expect(result, true; 
//     verify(mockEvents.update(any, "primary", 'eventId')).called(1);
//   });

//   test('updateEvent returns false when update fails', () async {
//     when(mockEvents.update(any, any, any)).thenThrow(Exception('Update failed'));

//     final googleEvent = GoogleEvent(
//       summary: 'Updated event',
//       description: 'Updated description',
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(Duration(hours: 1)),
//     );

//     final result = await googleCalendar.updateEvent(googleEvent, 'eventId');

//     expect(result, false);
//     verify(mockEvents.update(any, "primary", 'eventId')).called(1);
//   });

//   test('deleteEvent calls delete on events resource', () async {
//     final eventId = 'eventId';

//     googleCalendar.deleteEvent(eventId);

//     verify(mockEvents.delete("primary", eventId)).called(1);
//   });
// }
