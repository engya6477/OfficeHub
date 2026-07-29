import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter/widgets.dart';

enum RoomFacility {
  display('Display', Iconsax.monitor),
  whiteboard('Whiteboard', Iconsax.book_1),
  videoConferencing('Video Conferencing', Iconsax.video);

  const RoomFacility(this.label, this.icon);

  final String label;
  final IconData icon;
}
