import 'room_facility.dart';

class MeetingRoom {
  const MeetingRoom({
    required this.id,
    required this.name,
    required this.floor,
    required this.wing,
    required this.capacity,
    required this.facilities,
    this.photoCount = 1,
  });

  final String id;
  final String name;
  final String floor;
  final String wing;
  final int capacity;
  final List<RoomFacility> facilities;
  final int photoCount;

  String get location => '$floor · $wing';

  bool fitsAttendees(int attendees) => capacity >= attendees;

  bool hasFacilities(List<RoomFacility> requested) => requested.every(facilities.contains);
}
