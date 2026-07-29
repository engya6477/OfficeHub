import 'package:flutter/material.dart';

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
