import 'package:flutter/material.dart';

import '../../../data/models/room_facility.dart';

/// In-progress booking criteria carried through the multi-step booking flow
/// (criteria form -> results -> room details -> review -> confirmation).
class BookingCriteria {
  const BookingCriteria({
    this.date,
    this.startTime,
    this.durationMinutes = 30,
    this.attendees = 1,
    this.facilities = const [],
  });

  final DateTime? date;
  final TimeOfDay? startTime;
  final int durationMinutes;
  final int attendees;
  final List<RoomFacility> facilities;

  bool get isComplete => date != null && startTime != null;

  DateTime get endDateTime {
    final start = startTime!;
    return DateTime(date!.year, date!.month, date!.day, start.hour, start.minute)
        .add(Duration(minutes: durationMinutes));
  }

  TimeOfDay get endTime => TimeOfDay.fromDateTime(endDateTime);

  BookingCriteria copyWith({
    DateTime? date,
    TimeOfDay? startTime,
    int? durationMinutes,
    int? attendees,
    List<RoomFacility>? facilities,
  }) {
    return BookingCriteria(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      attendees: attendees ?? this.attendees,
      facilities: facilities ?? this.facilities,
    );
  }
}
