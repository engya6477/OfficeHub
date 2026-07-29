import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../models/meeting_room.dart';
import '../models/room_facility.dart';

/// Thrown when a booking request violates a business rule (business hours,
/// past date, double-booking, capacity, or ownership).
class BookingException implements Exception {
  const BookingException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Data-layer abstraction for meeting room bookings. Encapsulates the
/// business rules from the assessment so a future API-backed implementation
/// only needs to reproduce the same contract.
abstract class BookingRepository {
  List<Booking> getUpcoming(String employeeId);

  List<Booking> getHistory(String employeeId);

  Booking? getById(String id);

  /// Rooms that fit [attendees] and [facilities] and have no conflicting
  /// booking for the requested [date]/[startTime]/[durationMinutes].
  List<MeetingRoom> findAvailableRooms({
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int attendees,
    List<RoomFacility> facilities = const [],
  });

  /// Creates a booking after revalidating business hours, past-date, room
  /// capacity, and room availability. Throws [BookingException] on failure.
  Booking createBooking({
    required String employeeId,
    required String roomId,
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int attendees,
    required List<RoomFacility> facilities,
    String? title,
  });

  /// Cancels a booking owned by [employeeId]. Throws [BookingException] if
  /// the booking doesn't belong to the employee or is no longer cancellable.
  void cancelBooking({required String bookingId, required String employeeId});
}
