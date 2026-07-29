import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:officehub/data/repositories/mock_visit_repository.dart';
import 'package:officehub/data/repositories/visit_repository.dart';
import 'package:officehub/data/models/visit.dart';

DateTime _futureDate({int daysAhead = 3}) {
  final date = DateTime.now().add(Duration(days: daysAhead));
  return DateTime(date.year, date.month, date.day);
}

void main() {
  late MockVisitRepository repository;
  const employeeId = 'emp-1';
  const otherEmployeeId = 'emp-2';
  final date = _futureDate();

  setUp(() {
    repository = MockVisitRepository();
  });

  test('registers a visit with complete information', () {
    final visit = repository.createVisit(
      employeeId: employeeId,
      visitorName: 'Sarah Ahmed',
      visitorPhone: '+966501234567',
      visitDate: date,
      arrivalTime: const TimeOfDay(hour: 10, minute: 0),
      purpose: VisitPurpose.businessMeeting,
      meetingLocation: 'Main Lobby',
    );

    expect(repository.getUpcoming(employeeId), contains(visit));
  });

  test('rejects registering a visit in the past', () {
    expect(
      () => repository.createVisit(
        employeeId: employeeId,
        visitorName: 'Sarah Ahmed',
        visitorPhone: '+966501234567',
        visitDate: DateTime.now().subtract(const Duration(days: 1)),
        arrivalTime: const TimeOfDay(hour: 10, minute: 0),
        purpose: VisitPurpose.businessMeeting,
        meetingLocation: 'Main Lobby',
      ),
      throwsA(isA<VisitException>()),
    );
  });

  test('an employee cannot manage a visit created by someone else', () {
    final visit = repository.createVisit(
      employeeId: employeeId,
      visitorName: 'Sarah Ahmed',
      visitorPhone: '+966501234567',
      visitDate: date,
      arrivalTime: const TimeOfDay(hour: 10, minute: 0),
      purpose: VisitPurpose.businessMeeting,
      meetingLocation: 'Main Lobby',
    );

    expect(
      () => repository.cancelVisit(visitId: visit.id, employeeId: otherEmployeeId),
      throwsA(isA<VisitException>()),
    );
    expect(
      () => repository.updateVisit(
        visitId: visit.id,
        employeeId: otherEmployeeId,
        visitorName: 'Someone Else',
        visitorPhone: '+966500000000',
        visitDate: date,
        arrivalTime: const TimeOfDay(hour: 11, minute: 0),
        purpose: VisitPurpose.other,
        meetingLocation: 'Atlas Room',
      ),
      throwsA(isA<VisitException>()),
    );
  });

  test('editing an eligible upcoming visit updates its details', () {
    final visit = repository.createVisit(
      employeeId: employeeId,
      visitorName: 'Sarah Ahmed',
      visitorPhone: '+966501234567',
      visitDate: date,
      arrivalTime: const TimeOfDay(hour: 10, minute: 0),
      purpose: VisitPurpose.businessMeeting,
      meetingLocation: 'Main Lobby',
    );

    final updated = repository.updateVisit(
      visitId: visit.id,
      employeeId: employeeId,
      visitorName: 'Sarah Ahmed',
      visitorPhone: '+966501234567',
      visitDate: date,
      arrivalTime: const TimeOfDay(hour: 14, minute: 0),
      purpose: VisitPurpose.interview,
      meetingLocation: 'Floor 3 Lounge',
    );

    expect(updated.arrivalTime, const TimeOfDay(hour: 14, minute: 0));
    expect(updated.purpose, VisitPurpose.interview);
  });

  test('cancelled visits remain visible in history', () {
    final visit = repository.createVisit(
      employeeId: employeeId,
      visitorName: 'Sarah Ahmed',
      visitorPhone: '+966501234567',
      visitDate: date,
      arrivalTime: const TimeOfDay(hour: 10, minute: 0),
      purpose: VisitPurpose.businessMeeting,
      meetingLocation: 'Main Lobby',
    );

    repository.cancelVisit(visitId: visit.id, employeeId: employeeId);

    expect(repository.getUpcoming(employeeId).map((v) => v.id), isNot(contains(visit.id)));
    expect(repository.getHistory(employeeId).map((v) => v.id), contains(visit.id));
  });
}
