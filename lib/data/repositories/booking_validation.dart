import 'package:flutter/material.dart';

import '../../core/utils/business_hours.dart';
import 'booking_repository.dart';

/// Pure business-rule checks for meeting room bookings, kept separate from
/// [MockBookingRepository] so they can be unit tested in isolation.
abstract final class BookingValidation {
  /// Throws [BookingException] if the requested slot violates business
  /// hours or falls in the past. Pass [now] in tests to control "current time".
  static void assertValidSlot({
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    DateTime? now,
  }) {
    if (!BusinessHours.isBusinessDay(date)) {
      throw const BookingException('Rooms can only be booked Sunday to Thursday.');
    }
    if (!BusinessHours.isWithinBusinessHours(startTime, durationMinutes: durationMinutes)) {
      throw const BookingException('Bookings must fall within business hours (8:00 AM - 6:00 PM).');
    }
    final slotStart = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
    if (slotStart.isBefore(now ?? DateTime.now())) {
      throw const BookingException('Bookings cannot be created in the past.');
    }
  }

  static void assertFitsCapacity({required int capacity, required int attendees}) {
    if (capacity < attendees) {
      throw BookingException('This room only fits up to $capacity attendees.');
    }
  }
}
