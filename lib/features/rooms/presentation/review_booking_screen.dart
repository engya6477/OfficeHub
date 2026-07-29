import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/room_facility.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/room_repository.dart';
import '../application/bookings_controller.dart';
import 'booking_confirmation_screen.dart';

class ReviewBookingScreen extends StatefulWidget {
  const ReviewBookingScreen({
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
  State<ReviewBookingScreen> createState() => _ReviewBookingScreenState();
}

class _ReviewBookingScreenState extends State<ReviewBookingScreen> {
  bool _submitting = false;

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    final controller = context.read<BookingsController>();
    try {
      final booking = controller.createBooking(
        roomId: widget.roomId,
        date: widget.date,
        startTime: widget.startTime,
        durationMinutes: widget.durationMinutes,
        attendees: widget.attendees,
        facilities: widget.facilities,
        title: widget.meetingTitle,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(booking: booking),
        ),
      );
    } on BookingException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = context.read<RoomRepository>().getById(widget.roomId)!;
    final endTime = TimeOfDay.fromDateTime(
      DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
        widget.startTime.hour,
        widget.startTime.minute,
      ).add(Duration(minutes: widget.durationMinutes)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Review booking')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Make sure everything looks right before you confirm.',
                style: AppTypography.authBody(),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Room',
                rows: {'Room': room.name, 'Location': room.location},
              ),
              const SizedBox(height: AppSpacing.lg),
              _Section(
                title: 'Schedule',
                rows: {
                  'Date': DateTimeFormat.friendlyDate(widget.date),
                  'Start time': DateTimeFormat.time(widget.startTime),
                  'End time': DateTimeFormat.time(endTime),
                  'Duration': _durationLabel(widget.durationMinutes),
                  'Attendees': '${widget.attendees} people',
                  'Facilities': widget.facilities.isEmpty
                      ? 'None requested'
                      : widget.facilities.map((f) => f.label).join(', '),
                },
              ),
              const Spacer(),
              AppButton(
                label: 'Confirm booking',
                loading: _submitting,
                onPressed: _confirm,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Edit details',
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(context).pop(),
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final Map<String, String> rows;

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
          Text(title, style: AppTypography.sectionTitle()),
          const SizedBox(height: AppSpacing.sm),
          ...rows.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(child: Text(e.key, style: AppTypography.authBody())),
                  Flexible(
                    child: Text(
                      e.value,
                      style: AppTypography.listTitle(),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
