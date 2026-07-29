import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/selectable_chip.dart';
import '../../../data/models/room_facility.dart';

class RoomFilters {
  const RoomFilters({this.minAttendees, this.facilities = const {}});

  final int? minAttendees;
  final Set<RoomFacility> facilities;

  static const attendeeBrackets = [4, 8, 16, 20];

  RoomFilters copyWith({int? minAttendees, Set<RoomFacility>? facilities}) {
    return RoomFilters(minAttendees: minAttendees ?? this.minAttendees, facilities: facilities ?? this.facilities);
  }
}

Future<RoomFilters?> showRoomFiltersSheet(BuildContext context, RoomFilters current) {
  return showAppBottomSheet<RoomFilters>(
    context: context,
    title: 'Filters',
    builder: (context) => _RoomFiltersBody(initial: current),
  );
}

class _RoomFiltersBody extends StatefulWidget {
  const _RoomFiltersBody({required this.initial});

  final RoomFilters initial;

  @override
  State<_RoomFiltersBody> createState() => _RoomFiltersBodyState();
}

class _RoomFiltersBodyState extends State<_RoomFiltersBody> {
  late int? _minAttendees = widget.initial.minAttendees;
  late final Set<RoomFacility> _facilities = {...widget.initial.facilities};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Number of attendees', style: AppTypography.sectionTitle()),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: RoomFilters.attendeeBrackets
                .map((n) => SelectableChip(
                      label: 'Up to $n',
                      selected: _minAttendees == n,
                      onTap: () => setState(() => _minAttendees = _minAttendees == n ? null : n),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Facilities', style: AppTypography.sectionTitle()),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: RoomFacility.values
                .map((f) => SelectableChip(
                      label: f.label,
                      selected: _facilities.contains(f),
                      onTap: () => setState(() => _facilities.contains(f) ? _facilities.remove(f) : _facilities.add(f)),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Reset All',
                  variant: AppButtonVariant.outline,
                  onPressed: () => Navigator.of(context).pop(const RoomFilters()),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: 'Apply Filters',
                  onPressed: () =>
                      Navigator.of(context).pop(RoomFilters(minAttendees: _minAttendees, facilities: _facilities)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
