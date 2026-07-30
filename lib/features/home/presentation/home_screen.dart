import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../data/mock/mock_seed.dart';
import '../../../data/repositories/room_repository.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../rooms/application/bookings_controller.dart';
import '../../rooms/presentation/booking_criteria_screen.dart';
import '../../rooms/presentation/booking_details_screen.dart';
import '../../rooms/presentation/room_search_screen.dart';
import '../../visitors/application/visits_controller.dart';
import '../../visitors/presentation/register_visitor_screen.dart';
import '../../visitors/presentation/visit_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final employee = MockSeed.currentEmployee;
    final bookings = context.watch<BookingsController>();
    final visits = context.watch<VisitsController>();
    final roomRepo = context.read<RoomRepository>();

    final todayBookings = bookings.upcoming
        .where((b) => _isToday(b.date))
        .toList();
    final todayVisits = visits.upcoming
        .where((v) => _isToday(v.visitDate))
        .toList();
    final hasToday = todayBookings.isNotEmpty || todayVisits.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RoomSearchScreen()),
              ),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  children: [
                    const AppIcon(
                      AppIcons.searchNormal,
                      color: AppColors.iconMuted,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Search any Room',
                        style: AppTypography.bodyPlaceholder(),
                      ),
                    ),
                    const AppIcon(
                      AppIcons.microphone2,
                      color: AppColors.iconMuted,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Welcome', style: AppTypography.heading()),
                          Text(
                            ' , ${employee.firstName}',
                            style: AppTypography.heading(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Text(employee.company, style: AppTypography.caption()),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  ),
                  child: AppAvatar(initial: employee.initial),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'What would you like to do?',
              style: AppTypography.sectionTitle(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Iconsax.calendar_add,
                    label: 'Book a room',
                    iconBackground: AppColors.primarySurface,
                    iconColor: AppColors.primary,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BookingCriteriaScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _QuickAction(
                    icon: Iconsax.user_add,
                    label: 'Register visitor',
                    iconBackground: AppColors.visitorAccentSurface,
                    iconColor: AppColors.visitorAccent,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegisterVisitorScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text('Today', style: AppTypography.sectionTitle()),
            const SizedBox(height: AppSpacing.sm),
            if (!hasToday)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Text(
                  'Nothing scheduled for today.',
                  style: AppTypography.cardMeta(color: AppColors.textMuted),
                ),
              )
            else ...[
              for (final booking in todayBookings)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ActivityCard(
                    icon: Iconsax.calendar_1,
                    iconBackground: AppColors.primarySurface,
                    iconColor: AppColors.primary,
                    title:
                        booking.title ??
                        roomRepo.getById(booking.roomId)?.name ??
                        'Room',
                    subtitle:
                        '${DateTimeFormat.time(booking.startTime)} · ${roomRepo.getById(booking.roomId)?.name ?? ''}',
                    time: DateTimeFormat.time(booking.startTime),
                    timeColor: AppColors.primary,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            BookingDetailsScreen(bookingId: booking.id),
                      ),
                    ),
                  ),
                ),
              for (final visit in todayVisits)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ActivityCard(
                    icon: Iconsax.profile_2user,
                    iconBackground: AppColors.visitorAccentSurface,
                    iconColor: AppColors.visitorAccent,
                    title: visit.visitorName,
                    subtitle: 'Visitor · ${visit.meetingLocation}',
                    time: DateTimeFormat.time(visit.arrivalTime),
                    timeColor: AppColors.visitorAccent,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VisitDetailsScreen(visitId: visit.id),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(label, style: AppTypography.listTitle()),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String time;
  final Color timeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.listTitle()),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.cardMeta()),
                ],
              ),
            ),
            Text(time, style: AppTypography.cardMeta(color: timeColor)),
          ],
        ),
      ),
    );
  }
}
