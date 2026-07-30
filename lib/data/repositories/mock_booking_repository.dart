import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/booking.dart';
import '../models/meeting_room.dart';
import '../models/room_facility.dart';
import 'booking_repository.dart';
import 'booking_validation.dart';
import 'room_repository.dart';

class MockBookingRepository implements BookingRepository {
  MockBookingRepository(this._roomRepository) {
    _seedInitialBookings();
  }

  final RoomRepository _roomRepository;
  final _uuid = const Uuid();
  final List<Booking> _bookings = [];

  void _seedInitialBookings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _bookings.add(
      Booking(
        id: _uuid.v4(),
        roomId: 'room-atlas',
        employeeId: 'emp-1',
        date: today,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        durationMinutes: 60,
        attendees: 4,
        facilities: const [
          RoomFacility.display,
          RoomFacility.videoConferencing,
        ],
        status: BookingStatus.upcoming,
        createdAt: now.subtract(const Duration(days: 1)),
        title: 'Product Sync',
      ),
    );
    _bookings.add(
      Booking(
        id: _uuid.v4(),
        roomId: 'room-horizon',
        employeeId: 'emp-1',
        date: today.subtract(const Duration(days: 2)),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        durationMinutes: 30,
        attendees: 3,
        facilities: const [RoomFacility.display],
        status: BookingStatus.upcoming,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    );
    // Cancelled booking, so history shows both a past and a cancelled
    // record out of the box, matching the Figma history frame.
    _bookings.add(
      Booking(
        id: _uuid.v4(),
        roomId: 'room-summit',
        employeeId: 'emp-1',
        date: today.subtract(const Duration(days: 4)),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        durationMinutes: 60,
        attendees: 5,
        facilities: const [RoomFacility.display],
        status: BookingStatus.cancelled,
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    );
  }

  @override
  List<Booking> getUpcoming(String employeeId) {
    final list =
        _bookings
            .where(
              (b) =>
                  b.employeeId == employeeId &&
                  b.status == BookingStatus.upcoming &&
                  !b.isPast,
            )
            .toList()
          ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    return list;
  }

  @override
  List<Booking> getHistory(String employeeId) {
    final list =
        _bookings
            .where(
              (b) =>
                  b.employeeId == employeeId &&
                  (b.status == BookingStatus.cancelled || b.isPast),
            )
            .toList()
          ..sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
    return list;
  }

  @override
  Booking? getById(String id) {
    for (final booking in _bookings) {
      if (booking.id == id) return booking;
    }
    return null;
  }

  bool _isRoomFree(
    String roomId,
    DateTime date,
    TimeOfDay startTime,
    int durationMinutes, {
    String? excludingBookingId,
  }) {
    final candidate = Booking(
      id: 'candidate',
      roomId: roomId,
      employeeId: '',
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      attendees: 0,
      facilities: const [],
      status: BookingStatus.upcoming,
      createdAt: date,
    );
    return !_bookings.any(
      (b) =>
          b.id != excludingBookingId &&
          b.roomId == roomId &&
          b.status == BookingStatus.upcoming &&
          b.overlaps(candidate),
    );
  }

  @override
  List<MeetingRoom> findAvailableRooms({
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int attendees,
    List<RoomFacility> facilities = const [],
  }) {
    return _roomRepository
        .getAll()
        .where((room) => room.fitsAttendees(attendees))
        .where((room) => room.hasFacilities(facilities))
        .where((room) => _isRoomFree(room.id, date, startTime, durationMinutes))
        .toList();
  }

  @override
  Booking createBooking({
    required String employeeId,
    required String roomId,
    required DateTime date,
    required TimeOfDay startTime,
    required int durationMinutes,
    required int attendees,
    required List<RoomFacility> facilities,
    String? title,
  }) {
    BookingValidation.assertValidSlot(
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
    );

    final room = _roomRepository.getById(roomId);
    if (room == null) {
      throw const BookingException('This room is no longer available.');
    }
    BookingValidation.assertFitsCapacity(
      capacity: room.capacity,
      attendees: attendees,
    );

    // Revalidate availability right before confirming, in case another
    // booking was made for this room/slot since the user started the flow.
    if (!_isRoomFree(roomId, date, startTime, durationMinutes)) {
      throw const BookingException(
        'This room was just booked for the selected time. Please choose another slot.',
      );
    }

    final booking = Booking(
      id: _uuid.v4(),
      roomId: roomId,
      employeeId: employeeId,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      attendees: attendees,
      facilities: facilities,
      status: BookingStatus.upcoming,
      createdAt: DateTime.now(),
      title: title,
    );
    _bookings.add(booking);
    return booking;
  }

  @override
  void cancelBooking({required String bookingId, required String employeeId}) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1 || _bookings[index].employeeId != employeeId) {
      throw const BookingException('You can only manage your own bookings.');
    }
    final booking = _bookings[index];
    if (!booking.isCancellable) {
      throw const BookingException('This booking can no longer be cancelled.');
    }
    _bookings[index] = booking.copyWith(status: BookingStatus.cancelled);
  }
}
