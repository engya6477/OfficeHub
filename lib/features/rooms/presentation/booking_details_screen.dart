import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/booking.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/room_repository.dart';
import '../application/bookings_controller.dart';
import 'booking_criteria_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  Future<void> _cancel(BuildContext context, Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: const Text(
          'This booking will be cancelled and moved to your history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep booking'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      context.read<BookingsController>().cancelBooking(booking.id);
      if (context.mounted) Navigator.of(context).pop();
    } on BookingException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  void _edit(BuildContext context, Booking booking) {
    context.read<BookingsController>().cancelBooking(booking.id);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BookingCriteriaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingsController>();
    final booking = bookings.getById(bookingId);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found.')));
    }
    final room = context.read<RoomRepository>().getById(booking.roomId);

    final tone = switch (booking.displayStatusLabel) {
      'Cancelled' => StatusTone.error,
      'Past' => StatusTone.neutral,
      _ => StatusTone.info,
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Booking details'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      room?.name ?? 'Room',
                      style: AppTypography.feedbackTitle(),
                    ),
                  ),
                  StatusBadge(label: booking.displayStatusLabel, tone: tone),
                ],
              ),
              const SizedBox(height: 4),
              Text(room?.location ?? '', style: AppTypography.authBody()),
              const SizedBox(height: AppSpacing.xl),
              Container(
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
                    _Row('Date', DateTimeFormat.friendlyDate(booking.date)),
                    _Row(
                      'Time',
                      DateTimeFormat.timeRange(
                        booking.startTime,
                        booking.endTime,
                      ),
                    ),
                    _Row('Attendees', '${booking.attendees} people'),
                    _Row(
                      'Facilities',
                      booking.facilities.isEmpty
                          ? 'None requested'
                          : booking.facilities.map((f) => f.label).join(', '),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (booking.isCancellable) ...[
                AppButton(
                  label: 'Edit booking',
                  variant: AppButtonVariant.outline,
                  onPressed: () => _edit(context, booking),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Cancel',
                  onPressed: () => _cancel(context, booking),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.authBody())),
          Text(value, style: AppTypography.listTitle()),
        ],
      ),
    );
  }
}
