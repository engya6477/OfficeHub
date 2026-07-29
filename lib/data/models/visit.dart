import 'package:flutter/material.dart';

enum VisitPurpose {
  businessMeeting('Business Meeting'),
  interview('Interview'),
  delivery('Delivery / Service'),
  personalVisit('Personal Visit'),
  other('Other');

  const VisitPurpose(this.label);

  final String label;
}

enum VisitStatus { upcoming, cancelled }

class Visit {
  const Visit({
    required this.id,
    required this.employeeId,
    required this.visitorName,
    required this.visitorPhone,
    required this.visitDate,
    required this.arrivalTime,
    required this.purpose,
    required this.meetingLocation,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String employeeId;
  final String visitorName;
  final String visitorPhone;
  final DateTime visitDate;
  final TimeOfDay arrivalTime;
  final VisitPurpose purpose;
  final String meetingLocation;
  final VisitStatus status;
  final DateTime createdAt;

  DateTime get arrivalDateTime =>
      DateTime(visitDate.year, visitDate.month, visitDate.day, arrivalTime.hour, arrivalTime.minute);

  bool get isPast => DateTime.now().isAfter(arrivalDateTime);

  /// Visits may only be edited or cancelled before the visitor's arrival time.
  bool get isEditable => status == VisitStatus.upcoming && !isPast;

  String get displayStatusLabel {
    if (status == VisitStatus.cancelled) return 'Cancelled';
    if (isPast) return 'Completed';
    return 'Upcoming';
  }

  Visit copyWith({
    String? visitorName,
    String? visitorPhone,
    DateTime? visitDate,
    TimeOfDay? arrivalTime,
    VisitPurpose? purpose,
    String? meetingLocation,
    VisitStatus? status,
  }) {
    return Visit(
      id: id,
      employeeId: employeeId,
      visitorName: visitorName ?? this.visitorName,
      visitorPhone: visitorPhone ?? this.visitorPhone,
      visitDate: visitDate ?? this.visitDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      purpose: purpose ?? this.purpose,
      meetingLocation: meetingLocation ?? this.meetingLocation,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
