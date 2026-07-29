import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'room_facility.dart';

class MeetingRoom {
  const MeetingRoom({
    required this.id,
    required this.name,
    required this.floor,
    required this.wing,
    required this.capacity,
    required this.facilities,
    this.photoAssets = const [],
    this.placeholderIcon = Iconsax.building,
  });

  final String id;
  final String name;
  final String floor;
  final String wing;
  final int capacity;
  final List<RoomFacility> facilities;

  /// Real photos for this room, if any were exported from the Figma file.
  final List<String> photoAssets;

  /// Shown instead of a photo when [photoAssets] is empty.
  final IconData placeholderIcon;

  String get location => '$floor · $wing';

  bool get hasPhotos => photoAssets.isNotEmpty;

  bool fitsAttendees(int attendees) => capacity >= attendees;

  bool hasFacilities(List<RoomFacility> requested) =>
      requested.every(facilities.contains);
}
