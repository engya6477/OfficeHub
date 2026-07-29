import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract final class DateTimeFormat {
  static String time(TimeOfDay time) {
    final dt = DateTime(2000, 1, 1, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  static String timeRange(TimeOfDay start, TimeOfDay end) =>
      '${time(start)}–${time(end)}';

  /// "Today" / "Tomorrow" / "Wed, Jul 29" depending on how far [date] is.
  static String friendlyDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return DateFormat('EEE, MMM d').format(date);
  }

  static String fullDate(DateTime date) =>
      DateFormat('EEEE, MMM d').format(date);

  static String shortDate(DateTime date) => DateFormat('MMM d').format(date);
}
