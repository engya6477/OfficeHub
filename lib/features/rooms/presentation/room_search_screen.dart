import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
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
  final List<String> _recentSearches = ['Atlas Room', 'Horizon Room', 'Main Lobby'];
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
    final allRooms = context.read<RoomRepository>().search(_searchController.text);
    final rooms = allRooms
        .where((r) => _filters.minAttendees == null || r.capacity >= _filters.minAttendees!)
        .where((r) => _filters.facilities.every(r.facilities.contains))
        .toList();
    final query = _searchController.text.trim();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.setting_4),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search any Room',
                  prefixIcon: const Icon(Iconsax.search_normal, size: 20, color: AppColors.textMutedAlt),
                  suffixIcon: IconButton(
                    icon: Icon(Iconsax.microphone_2, color: _isListening ? AppColors.primary : AppColors.textMutedAlt),
                    onPressed: _startVoiceSearch,
                  ),
                ),
              ),
            ),
            if (query.isEmpty && _recentSearches.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text('Recent Search', style: AppTypography.sectionTitle()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.sm, AppSpacing.xl, 0),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _recentSearches
                      .map((term) => Chip(
                            avatar: const Icon(Iconsax.clock, size: 16, color: AppColors.textMutedAlt),
                            label: Text(term, style: AppTypography.body()),
                            onDeleted: () => setState(() => _recentSearches.remove(term)),
                            backgroundColor: AppColors.surface,
                            side: const BorderSide(color: AppColors.border),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(query.isEmpty ? 'Most Searched' : 'Results', style: AppTypography.sectionTitle()),
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
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                      itemCount: rooms.length,
                      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        return RoomCard(
                          room: room,
                          onTap: () {
                            if (!_recentSearches.contains(room.name)) {
                              setState(() => _recentSearches.insert(0, room.name));
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BookingCriteriaScreen(preselectedRoomId: room.id),
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
              decoration: const BoxDecoration(color: AppColors.primarySurface, shape: BoxShape.circle),
              child: const Icon(Iconsax.microphone_2, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Listening.....', style: AppTypography.body(color: AppColors.textMuted)),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
