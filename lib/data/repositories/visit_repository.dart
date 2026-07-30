import 'package:flutter/material.dart';

import '../models/visit.dart';

/// Thrown when a visitor registration request violates a business rule.
class VisitException implements Exception {
  const VisitException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Data-layer abstraction for visitor registrations. A future API-backed
/// implementation can replace [MockVisitRepository] without changes to the
/// presentation layer.
abstract class VisitRepository {
  List<Visit> getUpcoming(String employeeId);

  List<Visit> getHistory(String employeeId);

  Visit? getById(String id);

  Visit createVisit({
    required String employeeId,
    required String visitorName,
    required String visitorPhone,
    String? visitorEmail,
    String? visitorCompany,
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    required VisitPurpose purpose,
    required String meetingLocation,
  });

  Visit updateVisit({
    required String visitId,
    required String employeeId,
    required String visitorName,
    required String visitorPhone,
    String? visitorEmail,
    String? visitorCompany,
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    required VisitPurpose purpose,
    required String meetingLocation,
  });

  void cancelVisit({required String visitId, required String employeeId});
}
