import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/core/utils/business_hours.dart';

void main() {
  group('BusinessHours.isBusinessDay', () {
    test('accepts Sunday through Thursday', () {
      // 2026-08-02 is a Sunday.
      for (var i = 0; i < 5; i++) {
        final date = DateTime(2026, 8, 2 + i);
        expect(
          BusinessHours.isBusinessDay(date),
          isTrue,
          reason: '$date should be a business day',
        );
      }
    });

    test('rejects Friday and Saturday', () {
      final friday = DateTime(2026, 8, 7);
      final saturday = DateTime(2026, 8, 8);
      expect(BusinessHours.isBusinessDay(friday), isFalse);
      expect(BusinessHours.isBusinessDay(saturday), isFalse);
    });
  });

  group('BusinessHours.isWithinBusinessHours', () {
    test('accepts a slot fully within 8:00 AM - 6:00 PM', () {
      expect(
        BusinessHours.isWithinBusinessHours(
          const TimeOfDay(hour: 9, minute: 0),
          durationMinutes: 60,
        ),
        isTrue,
      );
    });

    test('rejects a start time before opening', () {
      expect(
        BusinessHours.isWithinBusinessHours(
          const TimeOfDay(hour: 7, minute: 30),
          durationMinutes: 30,
        ),
        isFalse,
      );
    });

    test('rejects a slot that ends after closing', () {
      expect(
        BusinessHours.isWithinBusinessHours(
          const TimeOfDay(hour: 17, minute: 30),
          durationMinutes: 60,
        ),
        isFalse,
      );
    });

    test('accepts a slot ending exactly at closing time', () {
      expect(
        BusinessHours.isWithinBusinessHours(
          const TimeOfDay(hour: 17, minute: 0),
          durationMinutes: 60,
        ),
        isTrue,
      );
    });
  });
}
