import '../mock/mock_seed.dart';
import '../models/meeting_room.dart';
import 'room_repository.dart';

class MockRoomRepository implements RoomRepository {
  @override
  List<MeetingRoom> getAll() => List.unmodifiable(MockSeed.rooms);

  @override
  MeetingRoom? getById(String id) {
    for (final room in MockSeed.rooms) {
      if (room.id == id) return room;
    }
    return null;
  }

  @override
  List<MeetingRoom> search(String query) {
    if (query.trim().isEmpty) return getAll();
    final lower = query.toLowerCase();
    return MockSeed.rooms
        .where((room) => room.name.toLowerCase().contains(lower))
        .toList();
  }
}
