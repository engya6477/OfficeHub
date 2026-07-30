import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/repositories/room_repository.dart';
import 'booking_criteria_screen.dart';
import 'room_filters_sheet.dart';
import 'widgets/room_card.dart';

class RoomSearchScreen extends StatefulWidget {
  const RoomSearchScreen({super.key});

  @override
  State<RoomSearchScreen> createState() => _RoomSearchScreenState();
}

class _RoomSearchScreenState extends State<RoomSearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Atlas Room',
    'Horizon Room',
    'Main Lobby',
  ];
  RoomFilters _filters = const RoomFilters();
  bool _isListening = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final result = await showRoomFiltersSheet(context, _filters);
    if (result != null) setState(() => _filters = result);
  }

  void _startVoiceSearch() {
    setState(() => _isListening = true);
    showModalBottomSheet(
      context: context,
      builder: (context) => const _VoiceSearchSheet(),
    ).whenComplete(() => setState(() => _isListening = false));

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      Navigator.of(context).maybePop();
      setState(() => _searchController.text = 'Atlas Room');
    });
  }

  @override
  Widget build(BuildContext context) {
    final allRooms = context.read<RoomRepository>().search(
      _searchController.text,
    );
    final rooms = allRooms
        .where(
          (r) =>
              _filters.minAttendees == null ||
              r.capacity >= _filters.minAttendees!,
        )
        .where((r) => _filters.facilities.every(r.facilities.contains))
        .toList();
    final query = _searchController.text.trim();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                          hintText: 'Search any Room',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(10),
                            child: AppIcon(
                              AppIcons.searchNormal,
                              size: 20,
                              color: AppColors.iconMuted,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: AppIcon(
                              AppIcons.microphone2,
                              size: 20,
                              color: _isListening
                                  ? AppColors.primary
                                  : AppColors.iconMuted,
                            ),
                            onPressed: _startVoiceSearch,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Material(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        onTap: _openFilters,
                        child: const Center(
                          child: AppIcon(
                            AppIcons.filter,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (query.isEmpty && _recentSearches.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  'Recent Search',
                  style: AppTypography.sectionTitle(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  0,
                ),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _recentSearches
                      .map(
                        (term) => Chip(
                          avatar: const AppIcon(
                            AppIcons.clock,
                            size: 16,
                            color: AppColors.iconMuted,
                          ),
                          label: Text(term, style: AppTypography.body()),
                          onDeleted: () =>
                              setState(() => _recentSearches.remove(term)),
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                query.isEmpty ? 'Most Searched' : 'Results',
                style: AppTypography.sectionTitle(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: rooms.isEmpty
                  ? const EmptyState(
                      icon: Iconsax.search_normal,
                      title: 'No rooms found',
                      message: 'Try a different name or adjust your filters.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        0,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      itemCount: rooms.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return RoomCard(
                          room: room,
                          onTap: () {
                            if (!_recentSearches.contains(room.name)) {
                              setState(
                                () => _recentSearches.insert(0, room.name),
                              );
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookingCriteriaScreen(
                                  preselectedRoomId: room.id,
                                ),
                              ),
                            );
                          },
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

class _VoiceSearchSheet extends StatelessWidget {
  const _VoiceSearchSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Voice Search', style: AppTypography.sectionTitle()),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const AppIcon(
                AppIcons.microphone2,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Listening.....', style: AppTypography.authBody()),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
