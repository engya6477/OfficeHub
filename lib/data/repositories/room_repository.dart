import '../models/meeting_room.dart';

/// Data-layer abstraction for meeting rooms. A future API-backed
/// implementation can replace [MockRoomRepository] without changes to the
/// presentation layer, which only ever depends on this interface.
abstract class RoomRepository {
  List<MeetingRoom> getAll();

  MeetingRoom? getById(String id);

  List<MeetingRoom> search(String query);
}
