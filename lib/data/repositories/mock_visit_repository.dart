import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/visit.dart';
import 'visit_repository.dart';
import 'visit_validation.dart';

class MockVisitRepository implements VisitRepository {
  MockVisitRepository() {
    _seedInitialVisits();
  }

  final _uuid = const Uuid();
  final List<Visit> _visits = [];

  void _seedInitialVisits() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _visits.add(
      Visit(
        id: _uuid.v4(),
        employeeId: 'emp-1',
        visitorName: 'Sarah Ahmed',
        visitorPhone: '+966 50 123 4567',
        visitDate: today,
        arrivalTime: const TimeOfDay(hour: 14, minute: 0),
        purpose: VisitPurpose.businessMeeting,
        meetingLocation: 'Main Lobby',
        status: VisitStatus.upcoming,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    );
    _visits.add(
      Visit(
        id: _uuid.v4(),
        employeeId: 'emp-1',
        visitorName: 'Omar Nasser',
        visitorPhone: '+966 55 987 6543',
        visitDate: today.subtract(const Duration(days: 3)),
        arrivalTime: const TimeOfDay(hour: 11, minute: 0),
        purpose: VisitPurpose.interview,
        meetingLocation: 'Floor 3 Lounge',
        status: VisitStatus.upcoming,
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    );
    // Cancelled visit, so history shows both a past and a cancelled
    // record out of the box, matching the Figma history frame.
    _visits.add(
      Visit(
        id: _uuid.v4(),
        employeeId: 'emp-1',
        visitorName: 'Layla Fahad',
        visitorPhone: '+966 54 222 1188',
        visitDate: today.subtract(const Duration(days: 5)),
        arrivalTime: const TimeOfDay(hour: 15, minute: 0),
        purpose: VisitPurpose.personalVisit,
        meetingLocation: 'Main Lobby',
        status: VisitStatus.cancelled,
        createdAt: now.subtract(const Duration(days: 7)),
      ),
    );
  }

  @override
  List<Visit> getUpcoming(String employeeId) {
    final list =
        _visits
            .where(
              (v) =>
                  v.employeeId == employeeId &&
                  v.status == VisitStatus.upcoming &&
                  !v.isPast,
            )
            .toList()
          ..sort((a, b) => a.arrivalDateTime.compareTo(b.arrivalDateTime));
    return list;
  }

  @override
  List<Visit> getHistory(String employeeId) {
    final list =
        _visits
            .where(
              (v) =>
                  v.employeeId == employeeId &&
                  (v.status == VisitStatus.cancelled || v.isPast),
            )
            .toList()
          ..sort((a, b) => b.arrivalDateTime.compareTo(a.arrivalDateTime));
    return list;
  }

  @override
  Visit? getById(String id) {
    for (final visit in _visits) {
      if (visit.id == id) return visit;
    }
    return null;
  }

  @override
  Visit createVisit({
    required String employeeId,
    required String visitorName,
    required String visitorPhone,
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    required VisitPurpose purpose,
    required String meetingLocation,
  }) {
    VisitValidation.assertRequiredFieldsCompleted(
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      meetingLocation: meetingLocation,
    );
    VisitValidation.assertNotInPast(
      visitDate: visitDate,
      arrivalTime: arrivalTime,
    );
    VisitValidation.assertBusinessDay(visitDate);

    final visit = Visit(
      id: _uuid.v4(),
      employeeId: employeeId,
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      visitDate: visitDate,
      arrivalTime: arrivalTime,
      purpose: purpose,
      meetingLocation: meetingLocation,
      status: VisitStatus.upcoming,
      createdAt: DateTime.now(),
    );
    _visits.add(visit);
    return visit;
  }

  @override
  Visit updateVisit({
    required String visitId,
    required String employeeId,
    required String visitorName,
    required String visitorPhone,
    required DateTime visitDate,
    required TimeOfDay arrivalTime,
    required VisitPurpose purpose,
    required String meetingLocation,
  }) {
    final index = _visits.indexWhere((v) => v.id == visitId);
    if (index == -1 || _visits[index].employeeId != employeeId) {
      throw const VisitException('You can only manage visitors you created.');
    }
    final existing = _visits[index];
    if (!existing.isEditable) {
      throw const VisitException('This visit can no longer be edited.');
    }
    VisitValidation.assertRequiredFieldsCompleted(
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      meetingLocation: meetingLocation,
    );
    VisitValidation.assertNotInPast(
      visitDate: visitDate,
      arrivalTime: arrivalTime,
    );
    VisitValidation.assertBusinessDay(visitDate);

    final updated = existing.copyWith(
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      visitDate: visitDate,
      arrivalTime: arrivalTime,
      purpose: purpose,
      meetingLocation: meetingLocation,
    );
    _visits[index] = updated;
    return updated;
  }

  @override
  void cancelVisit({required String visitId, required String employeeId}) {
    final index = _visits.indexWhere((v) => v.id == visitId);
    if (index == -1 || _visits[index].employeeId != employeeId) {
      throw const VisitException('You can only manage visitors you created.');
    }
    final visit = _visits[index];
    if (!visit.isEditable) {
      throw const VisitException('This visit can no longer be cancelled.');
    }
    _visits[index] = visit.copyWith(status: VisitStatus.cancelled);
  }
}
