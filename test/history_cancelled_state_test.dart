import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/data/mock/mock_seed.dart';
import 'package:officehub/data/repositories/mock_booking_repository.dart';
import 'package:officehub/data/repositories/mock_room_repository.dart';
import 'package:officehub/data/repositories/mock_session_repository.dart';
import 'package:officehub/data/repositories/mock_visit_repository.dart';
import 'package:officehub/data/repositories/room_repository.dart';
import 'package:officehub/data/repositories/session_repository.dart';
import 'package:officehub/data/models/visit.dart';
import 'package:officehub/features/rooms/application/bookings_controller.dart';
import 'package:officehub/features/rooms/presentation/rooms_tab_screen.dart';
import 'package:officehub/features/visitors/application/visits_controller.dart';
import 'package:officehub/features/visitors/presentation/visitors_tab_screen.dart';
import 'package:provider/provider.dart';

/// Verifies the assessment's explicit business rule -- "cancelled
/// bookings/visits remain visible in booking/visit history" -- actually
/// renders in the UI, end to end through the real widget tree (not just at
/// the repository layer, which is already covered elsewhere).
DateTime _nextBusinessDay({int minDaysAhead = 3}) {
  var date = DateTime.now().add(Duration(days: minDaysAhead));
  while (![
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
  ].contains(date.weekday)) {
    date = date.add(const Duration(days: 1));
  }
  return DateTime(date.year, date.month, date.day);
}

Widget _wrap(
  Widget child, {
  required BookingsController bookings,
  required VisitsController visits,
}) {
  return MultiProvider(
    providers: [
      Provider<RoomRepository>(create: (_) => MockRoomRepository()),
      Provider<SessionRepository>(create: (_) => MockSessionRepository()),
      ChangeNotifierProvider<BookingsController>.value(value: bookings),
      ChangeNotifierProvider<VisitsController>.value(value: visits),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  testWidgets(
    'a cancelled booking shows the Cancelled badge in Rooms history',
    (tester) async {
      final roomRepo = MockRoomRepository();
      final bookingRepo = MockBookingRepository(roomRepo);
      final bookings = BookingsController(
        bookingRepo,
        MockSeed.currentEmployee.id,
      );

      final booking = bookings.createBooking(
        roomId: 'room-atlas',
        date: _nextBusinessDay(),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        durationMinutes: 30,
        attendees: 2,
        facilities: const [],
      );
      bookings.cancelBooking(booking.id);

      // Sanity: still present, just no longer upcoming.
      expect(bookings.upcoming.any((b) => b.id == booking.id), isFalse);
      expect(bookings.history.any((b) => b.id == booking.id), isTrue);

      final visitRepo = MockVisitRepository();
      final visits = VisitsController(visitRepo, MockSeed.currentEmployee.id);

      await tester.pumpWidget(
        _wrap(const RoomsTabScreen(), bookings: bookings, visits: visits),
      );
      await tester.pumpAndSettle();

      // Switch to the History segment.
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Atlas Room'), findsOneWidget);
    },
  );

  testWidgets(
    'a cancelled visit shows the Cancelled badge in Visitors history',
    (tester) async {
      final roomRepo = MockRoomRepository();
      final bookingRepo = MockBookingRepository(roomRepo);
      final bookings = BookingsController(
        bookingRepo,
        MockSeed.currentEmployee.id,
      );

      final visitRepo = MockVisitRepository();
      final visits = VisitsController(visitRepo, MockSeed.currentEmployee.id);

      final visit = visits.createVisit(
        visitorName: 'Layla Hassan',
        visitorPhone: '+966501112222',
        visitDate: _nextBusinessDay(),
        arrivalTime: const TimeOfDay(hour: 9, minute: 30),
        purpose: VisitPurpose.other,
        meetingLocation: 'Main Lobby',
      );
      visits.cancelVisit(visit.id);

      expect(visits.upcoming.any((v) => v.id == visit.id), isFalse);
      expect(visits.history.any((v) => v.id == visit.id), isTrue);

      await tester.pumpWidget(
        _wrap(const VisitorsTabScreen(), bookings: bookings, visits: visits),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Layla Hassan'), findsOneWidget);
    },
  );
}
