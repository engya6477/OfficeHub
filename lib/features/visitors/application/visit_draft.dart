import 'package:flutter/material.dart';

import '../../../data/models/visit.dart';

/// In-progress visitor registration data carried through the two-step flow
/// (visitor information -> visit details -> review) and reused when editing
/// an existing visit.
class VisitDraft {
  const VisitDraft({
    this.visitorName = '',
    this.visitorPhone = '',
    this.visitorEmail = '',
    this.visitorCompany = '',
    this.visitDate,
    this.arrivalTime,
    this.purpose,
    this.meetingLocation,
  });

  factory VisitDraft.fromVisit(Visit visit) => VisitDraft(
    visitorName: visit.visitorName,
    visitorPhone: visit.visitorPhone,
    visitorEmail: visit.visitorEmail ?? '',
    visitorCompany: visit.visitorCompany ?? '',
    visitDate: visit.visitDate,
    arrivalTime: visit.arrivalTime,
    purpose: visit.purpose,
    meetingLocation: visit.meetingLocation,
  );

  final String visitorName;
  final String visitorPhone;
  final String visitorEmail;
  final String visitorCompany;
  final DateTime? visitDate;
  final TimeOfDay? arrivalTime;
  final VisitPurpose? purpose;
  final String? meetingLocation;

  /// Step 1 fields: visitor information.
  bool get isStep1Complete =>
      visitorName.trim().isNotEmpty &&
      visitorPhone.trim().isNotEmpty &&
      visitorEmail.trim().isNotEmpty &&
      visitorCompany.trim().isNotEmpty;

  /// Step 2 fields: visit details.
  bool get isStep2Complete =>
      visitDate != null &&
      arrivalTime != null &&
      purpose != null &&
      meetingLocation != null;

  bool get isComplete => isStep1Complete && isStep2Complete;

  VisitDraft copyWith({
    String? visitorName,
    String? visitorPhone,
    String? visitorEmail,
    String? visitorCompany,
    DateTime? visitDate,
    TimeOfDay? arrivalTime,
    VisitPurpose? purpose,
    String? meetingLocation,
  }) {
    return VisitDraft(
      visitorName: visitorName ?? this.visitorName,
      visitorPhone: visitorPhone ?? this.visitorPhone,
      visitorEmail: visitorEmail ?? this.visitorEmail,
      visitorCompany: visitorCompany ?? this.visitorCompany,
      visitDate: visitDate ?? this.visitDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      purpose: purpose ?? this.purpose,
      meetingLocation: meetingLocation ?? this.meetingLocation,
    );
  }
}
