import 'package:flutter/material.dart';

import '../../../data/models/visit.dart';
import '../../../data/repositories/visit_repository.dart';

/// Presentation-facing view-model wrapping [VisitRepository].
class VisitsController extends ChangeNotifier {
  VisitsController(this._repository, this._employeeId);

  final VisitRepository _repository;
  final String _employeeId;

  List<Visit> get upcoming => _repository.getUpcoming(_employeeId);

  List<Visit> get history => _repository.getHistory(_employeeId);

  Visit? getById(String id) => _repository.getById(id);

  /// Throws [VisitException] if the request violates a business rule.
  Visit createVisit({
    required String visitorName,
    required String visitorPhone,
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    required VisitPurpose purpose,
    required String meetingLocation,
  }) {
    final visit = _repository.createVisit(
      employeeId: _employeeId,
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      visitDate: visitDate,
      arrivalTime: arrivalTime,
      purpose: purpose,
      meetingLocation: meetingLocation,
    );
    notifyListeners();
    return visit;
  }

  /// Throws [VisitException] if the visit can no longer be edited.
  Visit updateVisit({
    required String visitId,
    required String visitorName,
    required String visitorPhone,
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    required VisitPurpose purpose,
    required String meetingLocation,
  }) {
    final visit = _repository.updateVisit(
      visitId: visitId,
      employeeId: _employeeId,
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      visitDate: visitDate,
      arrivalTime: arrivalTime,
      purpose: purpose,
      meetingLocation: meetingLocation,
    );
    notifyListeners();
    return visit;
  }

  /// Throws [VisitException] if the visit can no longer be cancelled.
  void cancelVisit(String visitId) {
    _repository.cancelVisit(visitId: visitId, employeeId: _employeeId);
    notifyListeners();
  }
}
