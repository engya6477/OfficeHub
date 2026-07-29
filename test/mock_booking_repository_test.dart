import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/data/repositories/booking_repository.dart';
import 'package:officehub/data/repositories/mock_booking_repository.dart';
import 'package:officehub/data/repositories/mock_room_repository.dart';

/// Finds the next business day (Sunday-Thursday) at least [minDaysAhead] days
/// from now, so tests never fail due to falling on a past/weekend date.
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

void main() {
  late MockBookingRepository repository;
  final date = _nextBusinessDay();
  const employeeId = 'emp-1';
  const otherEmployeeId = 'emp-2';

  setUp(() {
    repository = MockBookingRepository(MockRoomRepository());
  });

  test('creates a booking for an available room', () {
    final booking = repository.createBooking(
      employeeId: employeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 60,
      attendees: 4,
      facilities: const [],
    );

    expect(booking.roomId, 'room-atlas');
    expect(repository.getUpcoming(employeeId), contains(booking));
  });

  test('rejects a booking exceeding room capacity', () {
    expect(
      () => repository.createBooking(
        employeeId: employeeId,
        roomId: 'room-lobby', // capacity 4
        date: date,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        durationMinutes: 30,
        attendees: 10,
        facilities: const [],
      ),
      throwsA(isA<BookingException>()),
    );
  });

  test('prevents double-booking the same room for an overlapping slot', () {
    repository.createBooking(
      employeeId: employeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 60,
      attendees: 4,
      facilities: const [],
    );

    expect(
      () => repository.createBooking(
        employeeId: otherEmployeeId,
        roomId: 'room-atlas',
        date: date,
        startTime: const TimeOfDay(hour: 10, minute: 30),
        durationMinutes: 30,
        attendees: 2,
        facilities: const [],
      ),
      throwsA(isA<BookingException>()),
    );
  });

  test('allows back-to-back bookings that do not overlap', () {
    repository.createBooking(
      employeeId: employeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 60,
      attendees: 4,
      facilities: const [],
    );

    final second = repository.createBooking(
      employeeId: otherEmployeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 11, minute: 0),
      durationMinutes: 30,
      attendees: 2,
      facilities: const [],
    );

    expect(second.roomId, 'room-atlas');
  });

  test('findAvailableRooms excludes rooms with a conflicting booking', () {
    repository.createBooking(
      employeeId: employeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 60,
      attendees: 4,
      facilities: const [],
    );

    final available = repository.findAvailableRooms(
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 30),
      durationMinutes: 30,
      attendees: 2,
    );

    expect(available.map((r) => r.id), isNot(contains('room-atlas')));
  });

  test('cancelling a booking owned by another employee throws', () {
    final booking = repository.createBooking(
      employeeId: employeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 60,
      attendees: 4,
      facilities: const [],
    );

    expect(
      () => repository.cancelBooking(
        bookingId: booking.id,
        employeeId: otherEmployeeId,
      ),
      throwsA(isA<BookingException>()),
    );
  });

  test('cancelled bookings remain visible in history', () {
    final booking = repository.createBooking(
      employeeId: employeeId,
      roomId: 'room-atlas',
      date: date,
      startTime: const TimeOfDay(hour: 10, minute: 0),
      durationMinutes: 60,
      attendees: 4,
      facilities: const [],
    );

    repository.cancelBooking(bookingId: booking.id, employeeId: employeeId);

    expect(
      repository.getUpcoming(employeeId).map((b) => b.id),
      isNot(contains(booking.id)),
    );
    expect(
      repository.getHistory(employeeId).map((b) => b.id),
      contains(booking.id),
    );
  });
}
