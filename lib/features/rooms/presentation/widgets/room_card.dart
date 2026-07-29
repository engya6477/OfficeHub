import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/meeting_room.dart';

/// Room summary card (Figma "RoomCard" component). When [availabilityLabel]
/// is null (no booking criteria chosen yet) the availability row is hidden.
class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
    this.availabilityLabel,
    this.isAvailable = true,
  });

  final MeetingRoom room;
  final VoidCallback onTap;
  final String? availabilityLabel;
  final bool isAvailable;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(room.name, style: AppTypography.cardTitle()),
                      const SizedBox(height: 2),
                      Text(room.location, style: AppTypography.cardMeta()),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Iconsax.profile_2user,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Up to ${room.capacity}',
                        style: AppTypography.cardMeta(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
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
                        borderRadius: BorderRadius.circular(AppRadius.md),
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
            if (availabilityLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    isAvailable ? Iconsax.tick_circle : Iconsax.close_circle,
                    size: 14,
                    color: isAvailable
                        ? AppColors.successIcon
                        : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      availabilityLabel!,
                      style: AppTypography.cardMeta(
                        color: isAvailable
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ),
                  Text('View', style: AppTypography.link()),
                  const Icon(
                    Iconsax.arrow_right_3,
                    size: 13,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
