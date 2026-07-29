import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/room_facility.dart';
import '../../../data/repositories/room_repository.dart';
import '../application/bookings_controller.dart';
import 'review_booking_screen.dart';

class RoomDetailsScreen extends StatelessWidget {
  const RoomDetailsScreen({
    super.key,
    required this.roomId,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.attendees,
    required this.facilities,
    this.meetingTitle,
  });

  final String roomId;
  final DateTime date;
  final TimeOfDay startTime;
  final int durationMinutes;
  final int attendees;
  final List<RoomFacility> facilities;
  final String? meetingTitle;

  @override
  Widget build(BuildContext context) {
    final room = context.read<RoomRepository>().getById(roomId);
    final bookings = context.watch<BookingsController>();

    if (room == null) {
      return const Scaffold(body: Center(child: Text('Room not found.')));
    }

    final fitsCapacity = room.fitsAttendees(attendees);
    final isFree = bookings
        .findAvailableRooms(date: date, startTime: startTime, durationMinutes: durationMinutes, attendees: 0)
        .any((r) => r.id == room.id);
    final isAvailable = fitsCapacity && isFree;
    final endTime = TimeOfDay.fromDateTime(
      DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute)
          .add(Duration(minutes: durationMinutes)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Room details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: const Icon(Iconsax.building, size: 48, color: AppColors.textDisabled),
                  ),
                  if (room.photoCount > 1)
                    Positioned(
                      right: AppSpacing.md,
                      bottom: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text('1/${room.photoCount}', style: AppTypography.cardMeta(color: AppColors.onPrimary)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(room.name, style: AppTypography.heading().copyWith(fontSize: 22)),
              const SizedBox(height: 4),
              Text(room.location, style: AppTypography.cardMeta(color: AppColors.textMuted)),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Iconsax.profile_2user, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Up to ${room.capacity} people', style: AppTypography.cardMeta(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Facilities', style: AppTypography.sectionTitle()),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: room.facilities
                    .map((f) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.chipBackground,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(f.icon, size: 14, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(f.label, style: AppTypography.cardMeta(color: AppColors.textSecondary)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Divider(color: AppColors.border),
              const SizedBox(height: AppSpacing.md),
              Text('Your meeting', style: AppTypography.sectionTitle()),
              const SizedBox(height: AppSpacing.sm),
              _SummaryRow(label: 'Date', value: DateTimeFormat.friendlyDate(date)),
              _SummaryRow(label: 'Time', value: DateTimeFormat.timeRange(startTime, endTime)),
              _SummaryRow(label: 'Duration', value: _durationLabel(durationMinutes)),
              _SummaryRow(label: 'Attendees', value: '$attendees people'),
              _SummaryRow(
                label: 'Facilities',
                value: facilities.isEmpty ? 'None requested' : facilities.map((f) => f.label).join(', '),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!isAvailable)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    fitsCapacity
                        ? 'This room was just booked for the selected time. Please go back and choose another slot.'
                        : 'This room only fits up to ${room.capacity} attendees.',
                    style: AppTypography.cardMeta(color: AppColors.error),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: isAvailable ? 'Continue' : 'Not available',
                onPressed: isAvailable
                    ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ReviewBookingScreen(
                              roomId: roomId,
                              date: date,
                              startTime: startTime,
                              durationMinutes: durationMinutes,
                              attendees: attendees,
                              facilities: facilities,
                              meetingTitle: meetingTitle,
                            ),
                          ),
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _durationLabel(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes / 60;
    return hours == hours.roundToDouble() ? '${hours.toInt()} hr' : '$hours h';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.body(color: AppColors.textMuted))),
          Text(value, style: AppTypography.listTitle()),
        ],
      ),
    );
  }
}
