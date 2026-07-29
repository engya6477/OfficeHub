import 'package:flutter/material.dart';

import '../../core/utils/business_hours.dart';
import 'visit_repository.dart';

/// Pure business-rule checks for visitor registration, kept separate from
/// [MockVisitRepository] so they can be unit tested in isolation.
abstract final class VisitValidation {
  static void assertNotInPast({
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    DateTime? now,
  }) {
    final arrival = DateTime(
      visitDate.year,
      visitDate.month,
      visitDate.day,
      arrivalTime.hour,
      arrivalTime.minute,
    );
    if (arrival.isBefore(now ?? DateTime.now())) {
      throw const VisitException('Visits cannot be scheduled in the past.');
    }
  }

  /// The office is only staffed Sunday-Thursday, so visits follow the same
  /// business-day rule as meeting room bookings.
  static void assertBusinessDay(DateTime visitDate) {
    if (!BusinessHours.isBusinessDay(visitDate)) {
      throw const VisitException(
        'Visits can only be scheduled Sunday to Thursday.',
      );
    }
  }

  static void assertRequiredFieldsCompleted({
    required String visitorName,
    required String visitorPhone,
    required String meetingLocation,
  }) {
    if (visitorName.trim().isEmpty) {
      throw const VisitException('Visitor name is required.');
    }
    if (visitorPhone.trim().isEmpty) {
      throw const VisitException('Visitor phone number is required.');
    }
    if (meetingLocation.trim().isEmpty) {
      throw const VisitException('Meeting location is required.');
    }
  }
}
