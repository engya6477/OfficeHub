import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../data/mock/mock_seed.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/mock_booking_repository.dart';
import '../data/repositories/mock_room_repository.dart';
import '../data/repositories/mock_session_repository.dart';
import '../data/repositories/mock_visit_repository.dart';
import '../data/repositories/room_repository.dart';
import '../data/repositories/session_repository.dart';
import '../data/repositories/visit_repository.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/rooms/application/bookings_controller.dart';
import '../features/visitors/application/visits_controller.dart';
import 'app_root.dart';

class OfficeHubApp extends StatelessWidget {
  const OfficeHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RoomRepository>(create: (_) => MockRoomRepository()),
        Provider<SessionRepository>(create: (_) => MockSessionRepository()),
        Provider<BookingRepository>(
          create: (ctx) => MockBookingRepository(ctx.read<RoomRepository>()),
        ),
        Provider<VisitRepository>(create: (_) => MockVisitRepository()),
        ChangeNotifierProvider<AuthController>(
          create: (ctx) => AuthController(ctx.read<SessionRepository>()),
        ),
        ChangeNotifierProvider<BookingsController>(
          create: (ctx) => BookingsController(
            ctx.read<BookingRepository>(),
            MockSeed.currentEmployee.id,
          ),
        ),
        ChangeNotifierProvider<VisitsController>(
          create: (ctx) => VisitsController(
            ctx.read<VisitRepository>(),
            MockSeed.currentEmployee.id,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'OfficeHub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AppRoot(),
      ),
    );
  }
}
