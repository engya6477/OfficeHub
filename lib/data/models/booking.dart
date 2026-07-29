import 'package:flutter/material.dart';

import 'room_facility.dart';

enum BookingStatus { upcoming, cancelled }

class Booking {
  const Booking({
    required this.id,
    required this.roomId,
    required this.employeeId,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.attendees,
    required this.facilities,
    required this.status,
    required this.createdAt,
    this.title,
  });

  final String id;
  final String roomId;
  final String employeeId;
  final DateTime date;
  final TimeOfDay startTime;
  final int durationMinutes;
  final int attendees;
  final List<RoomFacility> facilities;
  final BookingStatus status;
  final DateTime createdAt;

  /// Optional meeting title/subject (e.g. "Product Sync"), distinct from the
  /// room name.
  final String? title;

  DateTime get startDateTime => DateTime(
    date.year,
    date.month,
    date.day,
    startTime.hour,
    startTime.minute,
  );

  DateTime get endDateTime =>
      startDateTime.add(Duration(minutes: durationMinutes));

  TimeOfDay get endTime => TimeOfDay.fromDateTime(endDateTime);

  bool overlaps(Booking other) =>
      startDateTime.isBefore(other.endDateTime) &&
      other.startDateTime.isBefore(endDateTime);

  bool get isPast => DateTime.now().isAfter(endDateTime);

  /// Booking is eligible for cancellation while it is upcoming and hasn't started.
  bool get isCancellable => status == BookingStatus.upcoming && !isPast;

  String get displayStatusLabel {
    if (status == BookingStatus.cancelled) return 'Cancelled';
    if (isPast) return 'Completed';
    return 'Upcoming';
  }

  Booking copyWith({
    String? roomId,
    DateTime? date,
    TimeOfDay? startTime,
    int? durationMinutes,
    int? attendees,
    List<RoomFacility>? facilities,
    BookingStatus? status,
  }) {
    return Booking(
      id: id,
      roomId: roomId ?? this.roomId,
      employeeId: employeeId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      attendees: attendees ?? this.attendees,
      facilities: facilities ?? this.facilities,
      status: status ?? this.status,
      createdAt: createdAt,
      title: title,
    );
  }
}
