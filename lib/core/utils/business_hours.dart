import 'package:flutter/material.dart';

/// Business rule: bookings/visits are only available Sunday-Thursday,
/// 8:00 AM - 6:00 PM.
abstract final class BusinessHours {
  static const openingHour = 8;
  static const closingHour = 18;

  static const List<int> businessWeekdays = [
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
  ];

  static bool isBusinessDay(DateTime date) =>
      businessWeekdays.contains(date.weekday);

  static bool isWithinBusinessHours(
    TimeOfDay start, {
    int durationMinutes = 0,
  }) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = startMinutes + durationMinutes;
    return startMinutes >= openingHour * 60 && endMinutes <= closingHour * 60;
  }

  /// Half-hour start times available within business hours.
  static List<TimeOfDay> availableStartTimes() {
    final slots = <TimeOfDay>[];
    for (
      var minutes = openingHour * 60;
      minutes < closingHour * 60;
      minutes += 30
    ) {
      slots.add(TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60));
    }
    return slots;
  }
}
