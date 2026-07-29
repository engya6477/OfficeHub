import 'package:flutter/material.dart';

import '../../../data/models/visit.dart';

/// In-progress visitor registration data carried through the two-step flow
/// (visitor information -> review) and reused when editing an existing visit.
class VisitDraft {
  const VisitDraft({
    this.visitorName = '',
    this.visitorPhone = '',
    this.visitDate,
    this.arrivalTime,
    this.purpose,
    this.meetingLocation,
  });

  factory VisitDraft.fromVisit(Visit visit) => VisitDraft(
        visitorName: visit.visitorName,
        visitorPhone: visit.visitorPhone,
        visitDate: visit.visitDate,
        arrivalTime: visit.arrivalTime,
        purpose: visit.purpose,
        meetingLocation: visit.meetingLocation,
      );

  final String visitorName;
  final String visitorPhone;
  final DateTime? visitDate;
  final TimeOfDay? arrivalTime;
  final VisitPurpose? purpose;
  final String? meetingLocation;

  bool get isComplete =>
      visitorName.trim().isNotEmpty &&
      visitorPhone.trim().isNotEmpty &&
      visitDate != null &&
      arrivalTime != null &&
      purpose != null &&
      meetingLocation != null;

  VisitDraft copyWith({
    String? visitorName,
    String? visitorPhone,
    DateTime? visitDate,
    TimeOfDay? arrivalTime,
    VisitPurpose? purpose,
    String? meetingLocation,
  }) {
    return VisitDraft(
      visitorName: visitorName ?? this.visitorName,
      visitorPhone: visitorPhone ?? this.visitorPhone,
      visitDate: visitDate ?? this.visitDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      purpose: purpose ?? this.purpose,
      meetingLocation: meetingLocation ?? this.meetingLocation,
    );
  }
}
