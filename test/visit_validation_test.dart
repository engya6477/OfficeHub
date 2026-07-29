import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/data/repositories/visit_repository.dart';
import 'package:officehub/data/repositories/visit_validation.dart';

void main() {
  final now = DateTime(2026, 8, 2, 9, 0);

  group('VisitValidation.assertNotInPast', () {
    test('accepts a future arrival', () {
      expect(
        () => VisitValidation.assertNotInPast(
          visitDate: DateTime(2026, 8, 2),
          arrivalTime: const TimeOfDay(hour: 10, minute: 0),
          now: now,
        ),
        returnsNormally,
      );
    });

    test('rejects an arrival earlier today', () {
      expect(
        () => VisitValidation.assertNotInPast(
          visitDate: DateTime(2026, 8, 2),
          arrivalTime: const TimeOfDay(hour: 8, minute: 0),
          now: now,
        ),
        throwsA(isA<VisitException>()),
      );
    });

    test('rejects a past date', () {
      expect(
        () => VisitValidation.assertNotInPast(
          visitDate: DateTime(2026, 8, 1),
          arrivalTime: const TimeOfDay(hour: 10, minute: 0),
          now: now,
        ),
        throwsA(isA<VisitException>()),
      );
    });
  });

  group('VisitValidation.assertRequiredFieldsCompleted', () {
    test('accepts fully completed information', () {
      expect(
        () => VisitValidation.assertRequiredFieldsCompleted(
          visitorName: 'Sarah Ahmed',
          visitorPhone: '+966501234567',
          meetingLocation: 'Main Lobby',
        ),
        returnsNormally,
      );
    });

    test('rejects a missing visitor name', () {
      expect(
        () => VisitValidation.assertRequiredFieldsCompleted(
          visitorName: '',
          visitorPhone: '+966501234567',
          meetingLocation: 'Main Lobby',
        ),
        throwsA(isA<VisitException>()),
      );
    });

    test('rejects a missing meeting location', () {
      expect(
        () => VisitValidation.assertRequiredFieldsCompleted(
          visitorName: 'Sarah Ahmed',
          visitorPhone: '+966501234567',
          meetingLocation: '',
        ),
        throwsA(isA<VisitException>()),
      );
    });
  });
}
