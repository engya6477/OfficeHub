import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/data/repositories/booking_repository.dart';
import 'package:officehub/data/repositories/booking_validation.dart';

void main() {
  // Fixed reference "now": Sunday 2026-08-02, 09:00.
  final now = DateTime(2026, 8, 2, 9, 0);

  group('BookingValidation.assertValidSlot', () {
    test('accepts a valid future business-day slot', () {
      expect(
        () => BookingValidation.assertValidSlot(
          date: DateTime(2026, 8, 2),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          durationMinutes: 60,
          now: now,
        ),
        returnsNormally,
      );
    });

    test('rejects a Friday booking (business days are Sunday-Thursday)', () {
      expect(
        () => BookingValidation.assertValidSlot(
          date: DateTime(2026, 8, 7),
          startTime: const TimeOfDay(hour: 10, minute: 0),
          durationMinutes: 60,
          now: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('rejects a slot outside 8:00 AM - 6:00 PM', () {
      expect(
        () => BookingValidation.assertValidSlot(
          date: DateTime(2026, 8, 2),
          startTime: const TimeOfDay(hour: 19, minute: 0),
          durationMinutes: 30,
          now: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('rejects a slot that has already passed today', () {
      expect(
        () => BookingValidation.assertValidSlot(
          date: DateTime(2026, 8, 2),
          startTime: const TimeOfDay(hour: 8, minute: 0),
          durationMinutes: 30,
          now: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });

    test('rejects a date in the past', () {
      expect(
        () => BookingValidation.assertValidSlot(
          date: DateTime(2026, 7, 26), // previous Sunday
          startTime: const TimeOfDay(hour: 10, minute: 0),
          durationMinutes: 30,
          now: now,
        ),
        throwsA(isA<BookingException>()),
      );
    });
  });

  group('BookingValidation.assertFitsCapacity', () {
    test('accepts attendees within capacity', () {
      expect(
        () => BookingValidation.assertFitsCapacity(capacity: 8, attendees: 8),
        returnsNormally,
      );
    });

    test('rejects attendees exceeding capacity', () {
      expect(
        () => BookingValidation.assertFitsCapacity(capacity: 4, attendees: 5),
        throwsA(isA<BookingException>()),
      );
    });
  });
}
