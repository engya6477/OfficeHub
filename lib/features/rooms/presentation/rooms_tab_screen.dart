import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/booking.dart';
import '../../../data/repositories/room_repository.dart';
import '../application/bookings_controller.dart';
import 'booking_criteria_screen.dart';
import 'booking_details_screen.dart';
import 'room_search_screen.dart';

class RoomsTabScreen extends StatefulWidget {
  const RoomsTabScreen({super.key});

  @override
  State<RoomsTabScreen> createState() => _RoomsTabScreenState();
}

class _RoomsTabScreenState extends State<RoomsTabScreen> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsController>();
    final list = _segment == 0 ? bookings.upcoming : bookings.history;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
              child: Text('Rooms', style: AppTypography.heading().copyWith(fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RoomSearchScreen()),
                ),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.search_normal, size: 20, color: AppColors.textMutedAlt),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text('Search any Room', style: AppTypography.bodyPlaceholder())),
                      const Icon(Iconsax.microphone_2, size: 20, color: AppColors.textMutedAlt),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BookingCriteriaScreen()),
                  ),
                  icon: const Icon(Iconsax.calendar_add),
                  label: const Text('Find a room'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text('My bookings', style: AppTypography.sectionTitle()),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: _SegmentToggle(
                value: _segment,
                labels: const ['Upcoming', 'History'],
                onChanged: (v) => setState(() => _segment = v),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: list.isEmpty
                  ? EmptyState(
                      icon: Iconsax.calendar_1,
                      title: _segment == 0 ? 'No upcoming bookings' : 'No booking history yet',
                      message: _segment == 0
                          ? 'Book a meeting room to see it listed here.'
                          : 'Your past and cancelled bookings will appear here.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) => _BookingListTile(booking: list[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({required this.value, required this.labels, required this.onChanged});

  final int value;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = index == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: selected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index],
                  style: AppTypography.listTitle(color: selected ? AppColors.textPrimary : AppColors.textMuted),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BookingListTile extends StatelessWidget {
  const _BookingListTile({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final room = context.read<RoomRepository>().getById(booking.roomId);
    final tone = switch (booking.displayStatusLabel) {
      'Cancelled' => StatusTone.error,
      'Completed' => StatusTone.neutral,
      _ => StatusTone.info,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookingDetailsScreen(bookingId: booking.id)),
      ),
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
              decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: const Icon(Iconsax.calendar_1, size: 20, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room?.name ?? 'Room', style: AppTypography.listTitle()),
                  const SizedBox(height: 2),
                  Text(
                    '${DateTimeFormat.friendlyDate(booking.date)} · ${DateTimeFormat.time(booking.startTime)}',
                    style: AppTypography.cardMeta(),
                  ),
                ],
              ),
            ),
            StatusBadge(label: booking.displayStatusLabel, tone: tone),
          ],
        ),
      ),
    );
  }
}
