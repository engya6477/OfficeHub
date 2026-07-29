import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/widgets/floating_bottom_nav.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/rooms/presentation/rooms_tab_screen.dart';
import '../features/visitors/presentation/visitors_tab_screen.dart';

/// Bottom-nav shell hosting the three top-level destinations. Deeper flows
/// (search, booking, visitor registration, details, profile) are pushed on
/// top via [Navigator.push] and hide this bar, matching the Figma frames.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      HomeScreen(),
      RoomsTabScreen(),
      VisitorsTabScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: FloatingBottomNav(
        items: const [
          BottomNavItem(icon: Iconsax.home_2, label: 'Home'),
          BottomNavItem(icon: Iconsax.calendar_1, label: 'Rooms'),
          BottomNavItem(icon: Iconsax.profile_2user, label: 'Visitors'),
        ],
        currentIndex: _index,
        onTap: _goToTab,
      ),
    );
  }
}
