import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_time_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/counter_stepper.dart';
import '../../../core/widgets/date_selection_sheet.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../core/widgets/time_selection_sheet.dart';
import '../../../data/models/room_facility.dart';
import 'available_rooms_screen.dart';
import 'room_details_screen.dart';

const _durationOptions = [30, 60, 90, 120, 180];

String _durationLabel(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes / 60;
  return hours == hours.roundToDouble() ? '${hours.toInt()} hr' : '${hours}h';
}

/// "Find a room" criteria form. When [preselectedRoomId] is provided (user
/// arrived via the quick room-name search), submitting checks that single
/// room's availability instead of listing every matching room.
class BookingCriteriaScreen extends StatefulWidget {
  const BookingCriteriaScreen({super.key, this.preselectedRoomId});

  final String? preselectedRoomId;

  @override
  State<BookingCriteriaScreen> createState() => _BookingCriteriaScreenState();
}

class _BookingCriteriaScreenState extends State<BookingCriteriaScreen> {
  final _titleController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  int _duration = 60;
  int _attendees = 2;
  final Set<RoomFacility> _facilities = {};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDateSelectionSheet(context, initialDate: _date);
    if (date != null) setState(() => _date = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimeSelectionSheet(context, initialTime: _startTime);
    if (time != null) setState(() => _startTime = time);
  }

  void _findRooms() {
    if (_date == null || _startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time.')),
      );
      return;
    }

    final title = _titleController.text.trim().isEmpty
        ? null
        : _titleController.text.trim();

    if (widget.preselectedRoomId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RoomDetailsScreen(
            roomId: widget.preselectedRoomId!,
            date: _date!,
            startTime: _startTime!,
            durationMinutes: _duration,
            attendees: _attendees,
            facilities: _facilities.toList(),
            meetingTitle: title,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AvailableRoomsScreen(
          date: _date!,
          startTime: _startTime!,
          durationMinutes: _duration,
          attendees: _attendees,
          facilities: _facilities.toList(),
          meetingTitle: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Find a room')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tell us what you need.', style: AppTypography.authBody()),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: 'Meeting title',
                controller: _titleController,
                hintText: 'e.g. Product Sync',
              ),
              const SizedBox(height: AppSpacing.lg),
              _FieldTile(
                icon: Iconsax.calendar_1,
                label: 'Date',
                value: _date == null
                    ? 'Select date'
                    : DateTimeFormat.friendlyDate(_date!),
                onTap: _pickDate,
              ),
              const SizedBox(height: AppSpacing.md),
              _FieldTile(
                icon: Iconsax.clock,
                label: 'Time',
                value: _startTime == null
                    ? 'Select time'
                    : DateTimeFormat.time(_startTime!),
                onTap: _pickTime,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Duration', style: AppTypography.sectionTitle()),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _durationOptions
                    .map(
                      (d) => SelectableChip(
                        label: _durationLabel(d),
                        selected: _duration == d,
                        onTap: () => setState(() => _duration = d),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Number of attendees', style: AppTypography.sectionTitle()),
              const SizedBox(height: AppSpacing.sm),
              CounterStepper(
                value: _attendees,
                onChanged: (v) => setState(() => _attendees = v),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Text('Facilities', style: AppTypography.sectionTitle()),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Optional', style: AppTypography.caption()),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: RoomFacility.values
                    .map(
                      (f) => SelectableChip(
                        label: f.label,
                        selected: _facilities.contains(f),
                        onTap: () => setState(
                          () => _facilities.contains(f)
                              ? _facilities.remove(f)
                              : _facilities.add(f),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              AppButton(label: 'Find Rooms', onPressed: _findRooms),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textMutedAlt),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTypography.inputLabel()),
            const Spacer(),
            Text(value, style: AppTypography.body()),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: AppColors.textMutedAlt,
            ),
          ],
        ),
      ),
    );
  }
}
