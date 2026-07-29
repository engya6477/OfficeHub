import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/meeting_room.dart';
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
        .findAvailableRooms(
          date: date,
          startTime: startTime,
          durationMinutes: durationMinutes,
          attendees: 0,
        )
        .any((r) => r.id == room.id);
    final isAvailable = fitsCapacity && isFree;
    final endTime = TimeOfDay.fromDateTime(
      DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      ).add(Duration(minutes: durationMinutes)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RoomPhotoHeader(room: room),
                  Container(
                    width: double.infinity,
                    color: AppColors.surface,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: AppTypography.listTitle().copyWith(
                            fontSize: 20,
                            height: 28 / 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(room.location, style: AppTypography.authBody()),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            const Icon(
                              Iconsax.profile_2user,
                              size: 15,
                              color: AppColors.textDisabled,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'Up to ${room.capacity} people',
                              style: AppTypography.authBody(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      0,
                    ),
                    child: _InfoCard(
                      title: 'Facilities',
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: room.facilities
                            .map(
                              (f) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.chipBackground,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md,
                                  ),
                                ),
                                child: Text(
                                  f.label,
                                  style: AppTypography.cardMeta(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: _InfoCard(
                      title: 'Your meeting',
                      child: Column(
                        children: [
                          _InfoRow(
                            'Date',
                            DateTimeFormat.friendlyDate(date),
                            showDivider: true,
                          ),
                          _InfoRow(
                            'Time',
                            DateTimeFormat.timeRange(startTime, endTime),
                            showDivider: true,
                          ),
                          _InfoRow(
                            'Duration',
                            _durationLabel(durationMinutes),
                            showDivider: true,
                          ),
                          _InfoRow(
                            'Attendees',
                            '$attendees people',
                            showDivider: true,
                          ),
                          _InfoRow(
                            'Facilities',
                            facilities.isEmpty
                                ? 'None requested'
                                : facilities.map((f) => f.label).join(', '),
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isAvailable)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      child: Container(
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
                    ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.sm,
            ),
            child: SafeArea(
              top: false,
              child: AppButton(
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
            ),
          ),
        ],
      ),
    );
  }

  String _durationLabel(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes / 60;
    return hours == hours.roundToDouble() ? '${hours.toInt()} hr' : '$hours h';
  }
}

/// Full-bleed photo carousel (or themed placeholder) with a floating back
/// button, matching the Figma room-details header exactly.
class _RoomPhotoHeader extends StatefulWidget {
  const _RoomPhotoHeader({required this.room});

  final MeetingRoom room;

  @override
  State<_RoomPhotoHeader> createState() => _RoomPhotoHeaderState();
}

class _RoomPhotoHeaderState extends State<_RoomPhotoHeader> {
  final _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final photoCount = room.hasPhotos ? room.photoAssets.length : 1;

    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (room.hasPhotos)
            PageView.builder(
              controller: _controller,
              itemCount: room.photoAssets.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) =>
                  Image.asset(room.photoAssets[i], fit: BoxFit.cover),
            )
          else
            Container(
              color: AppColors.chipBackground,
              alignment: Alignment.center,
              child: Icon(
                room.placeholderIcon,
                size: 56,
                color: AppColors.textDisabled,
              ),
            ),
          Positioned(
            top: AppSpacing.xxl,
            left: AppSpacing.lg,
            child: SafeArea(
              bottom: false,
              child: _PhotoIconButton(
                icon: Iconsax.arrow_left_2,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          if (photoCount > 1) ...[
            Positioned(
              top: AppSpacing.xxl,
              right: AppSpacing.lg,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '${_page + 1} / $photoCount',
                    style: AppTypography.cardMeta(color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppSpacing.md,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photoCount, (i) {
                  final active = i == _page;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhotoIconButton extends StatelessWidget {
  const _PhotoIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 20, color: AppColors.onPrimary),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.cardMeta(color: AppColors.textDisabled),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {required this.showDivider});

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: showDivider
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF9FAFB))),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.cardMeta(color: AppColors.textDisabled),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.listTitle()),
        ],
      ),
    );
  }
}
