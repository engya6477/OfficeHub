/// Centralized paths for icon assets exported directly from the Figma file
/// (via the Figma REST API's image export endpoint), so the exact vectors
/// are used instead of approximated Material/Iconsax substitutes.
abstract final class AppIcons {
  static const _base = 'assets/icons';

  static const searchNormal = '$_base/search_normal.svg';
  static const microphone2 = '$_base/microphone_2.svg';
  static const filter = '$_base/filter.svg';
  static const arrowLeft = '$_base/arrow_left.svg';
  static const eye = '$_base/eye.svg';
  static const lock = '$_base/lock.svg';
  static const calendar = '$_base/calendar.svg';
  static const clock = '$_base/clock.svg';
  static const documentText = '$_base/document_text.svg';
  static const locationTick = '$_base/location_tick.svg';

  static const navHome = '$_base/nav_home.svg';
  static const navRooms = '$_base/nav_rooms.svg';
  static const navVisitors = '$_base/nav_visitors.svg';

  static const splashLogo = '$_base/splash_logo.svg';
}
