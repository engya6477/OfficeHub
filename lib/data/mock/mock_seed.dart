import '../models/employee.dart';
import '../models/meeting_room.dart';
import '../models/room_facility.dart';

/// Static mock/local data used to demonstrate the full experience without a
/// backend, per the assessment's technical constraints.
abstract final class MockSeed {
  static const currentEmployee = Employee(
    id: 'emp-1',
    name: 'Ahmed Alharbi',
    jobTitle: 'Product Designer',
    company: 'Nova Company',
    email: 'ahmed.alharbi@novacompany.com',
  );

  static const List<MeetingRoom> rooms = [
    MeetingRoom(
      id: 'room-atlas',
      name: 'Atlas Room',
      floor: 'Floor 2',
      wing: 'East Wing',
      capacity: 8,
      facilities: [RoomFacility.display, RoomFacility.whiteboard, RoomFacility.videoConferencing],
      photoCount: 2,
    ),
    MeetingRoom(
      id: 'room-horizon',
      name: 'Horizon Room',
      floor: 'Floor 3',
      wing: 'West Wing',
      capacity: 12,
      facilities: [RoomFacility.display, RoomFacility.videoConferencing],
      photoCount: 1,
    ),
    MeetingRoom(
      id: 'room-lobby',
      name: 'Main Lobby',
      floor: 'Ground Floor',
      wing: 'Reception',
      capacity: 4,
      facilities: [RoomFacility.display],
      photoCount: 1,
    ),
    MeetingRoom(
      id: 'room-summit',
      name: 'Summit Room',
      floor: 'Floor 4',
      wing: 'North Wing',
      capacity: 20,
      facilities: [RoomFacility.display, RoomFacility.whiteboard, RoomFacility.videoConferencing],
      photoCount: 1,
    ),
    MeetingRoom(
      id: 'room-nook',
      name: 'Quiet Nook',
      floor: 'Floor 2',
      wing: 'South Wing',
      capacity: 4,
      facilities: [RoomFacility.whiteboard],
      photoCount: 1,
    ),
  ];

  static const List<String> visitLocations = ['Main Lobby', 'Floor 3 Lounge', 'Atlas Room'];
}
