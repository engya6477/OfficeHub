import 'package:flutter/material.dart';

import '../../../data/models/booking.dart';
import '../../../data/models/meeting_room.dart';
import '../../../data/models/room_facility.dart';
import '../../../data/repositories/booking_repository.dart';

/// Presentation-facing view-model wrapping [BookingRepository]. Screens
/// watch this controller so lists refresh reactively after a booking is
/// created or cancelled anywhere in the app.
class BookingsController extends ChangeNotifier {
  BookingsController(this._repository, this._employeeId);

  final BookingRepository _repository;
  final String _employeeId;

  List<Booking> get upcoming => _repository.getUpcoming(_employeeId);

  List<Booking> get history => _repository.getHistory(_employeeId);

  Booking? getById(String id) => _repository.getById(id);

  List<MeetingRoom> findAvailableRooms({
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int attendees,
    List<RoomFacility> facilities = const [],
  }) {
    return _repository.findAvailableRooms(
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      attendees: attendees,
      facilities: facilities,
    );
  }

  /// Throws [BookingException] if the request violates a business rule.
  Booking createBooking({
    required String roomId,
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int attendees,
    required List<RoomFacility> facilities,
    String? title,
  }) {
    final booking = _repository.createBooking(
      employeeId: _employeeId,
      roomId: roomId,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      attendees: attendees,
      facilities: facilities,
      title: title,
    );
    notifyListeners();
    return booking;
  }

  /// Throws [BookingException] if the booking can no longer be cancelled.
  void cancelBooking(String bookingId) {
    _repository.cancelBooking(bookingId: bookingId, employeeId: _employeeId);
    notifyListeners();
  }
}
