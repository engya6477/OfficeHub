import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/room_facility.dart';
import '../application/bookings_controller.dart';
import 'room_details_screen.dart';
import 'widgets/room_card.dart';

class AvailableRoomsScreen extends StatelessWidget {
  const AvailableRoomsScreen({
    super.key,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.attendees,
    required this.facilities,
    this.meetingTitle,
  });

  final DateTime date;
  final TimeOfDay startTime;
  final int durationMinutes;
  final int attendees;
  final List<RoomFacility> facilities;
  final String? meetingTitle;

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsController>();
    final endTime = TimeOfDay.fromDateTime(
      DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute)
          .add(Duration(minutes: durationMinutes)),
    );
    final rooms = bookings.findAvailableRooms(
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      attendees: attendees,
      facilities: facilities,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Available rooms')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, 0),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateTimeFormat.friendlyDate(date)} · ${DateTimeFormat.timeRange(startTime, endTime)}',
                            style: AppTypography.listTitle(),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$attendees ${attendees == 1 ? 'person' : 'people'}'
                            '${facilities.isEmpty ? '' : ' · ${facilities.map((f) => f.label).join(', ')}'}',
                            style: AppTypography.cardMeta(),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Edit', style: AppTypography.link()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                rooms.isEmpty ? '0 rooms available' : '${rooms.length} room${rooms.length == 1 ? '' : 's'} available',
                style: AppTypography.sectionTitle(),
              ),
            ),
            Expanded(
              child: rooms.isEmpty
                  ? EmptyState(
                      icon: Iconsax.calendar_remove,
                      title: 'No rooms available',
                      message:
                          'No rooms fit $attendees ${attendees == 1 ? 'person' : 'people'} for '
                          '${DateTimeFormat.timeRange(startTime, endTime)}.',
                      action: Column(
                        children: [
                          AppButton(
                            label: 'Choose another time',
                            variant: AppButtonVariant.outline,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          AppButton(
                            label: 'Edit requirements',
                            variant: AppButtonVariant.text,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      itemCount: rooms.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return RoomCard(
                          room: room,
                          availabilityLabel: 'Available · ${DateTimeFormat.timeRange(startTime, endTime)}',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RoomDetailsScreen(
                                roomId: room.id,
                                date: date,
                                startTime: startTime,
                                durationMinutes: durationMinutes,
                                attendees: attendees,
                                facilities: facilities,
                                meetingTitle: meetingTitle,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
