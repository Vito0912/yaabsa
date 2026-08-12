import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/components/settings/admin_library_stats_preview_icons.dart';
import 'package:yaabsa/components/settings/admin_library_stats_ranked_section.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/item_view_navigation.dart';

class AdminServerLibraryStatsView extends ConsumerStatefulWidget {
  const AdminServerLibraryStatsView({super.key});

  @override
  ConsumerState<AdminServerLibraryStatsView> createState() => _AdminServerLibraryStatsViewState();
}

class _AdminServerLibraryStatsViewState extends ConsumerState<AdminServerLibraryStatsView> {
  final Map<String, LibraryStats> _statsByLibraryId = <String, LibraryStats>{};

  String? _activeUserId;
  String? _activeLibraryId;
  String? _loadingLibraryId;
  String? _errorMessage;
  int _requestGeneration = 0;

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  Future<void> _loadStatsForLibrary(String libraryId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _statsByLibraryId.containsKey(libraryId)) return;

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() => _errorMessage = 'No active server connection is available.');
      return;
    }

    final requestGeneration = ++_requestGeneration;
    final requestUserId = _activeUserId;
    setState(() {
      _loadingLibraryId = libraryId;
      _errorMessage = null;
    });

    try {
      final response = await api.getLibraryApi().getLibraryStats(libraryId);
      final stats = response.data ?? const LibraryStats();
      if (!mounted || requestUserId != _activeUserId) return;

      setState(() => _statsByLibraryId[libraryId] = stats);
    } catch (error) {
      if (!mounted ||
          requestUserId != _activeUserId ||
          requestGeneration != _requestGeneration ||
          _activeLibraryId != libraryId) {
        return;
      }
      setState(() => _errorMessage = 'The statistics for this library could not be loaded. $error');
    } finally {
      if (mounted && requestGeneration == _requestGeneration) {
        setState(() => _loadingLibraryId = null);
      }
    }
  }

  List<AdminLibraryStatsRankedEntry> _buildGenreEntries(BuildContext context, LibraryStats stats) {
    final totalItems = stats.totalItems ?? 0;
    return stats.genresWithCount
        .where((genre) => genre.genre.trim().isNotEmpty)
        .map(
          (genre) => AdminLibraryStatsRankedEntry(
            label: genre.genre,
            value: genre.count.toDouble(),
            trailing: '${_percentOfTotal(genre.count, totalItems)}%',
            onTap: () {
              final filter = LibraryFilter.grouped(LibraryFilterGroup.genres, genre.genre).queryValue;
              unawaited(openLibraryWithFilter(context, ref, filter: filter));
            },
          ),
        )
        .toList(growable: false);
  }

  List<AdminLibraryStatsRankedEntry> _buildAuthorEntries(BuildContext context, LibraryStats stats) {
    return stats.authorsWithCount
        .where((author) => author.name.trim().isNotEmpty)
        .map(
          (author) => AdminLibraryStatsRankedEntry(
            label: author.name,
            value: author.count.toDouble(),
            trailing: '${author.count}',
            onTap: author.id.trim().isEmpty ? null : () => context.push('/author/${Uri.encodeComponent(author.id)}'),
          ),
        )
        .toList(growable: false);
  }

  List<AdminLibraryStatsRankedEntry> _buildLongestItemEntries(BuildContext context, LibraryStats stats) {
    return stats.longestItems
        .where((item) => item.title.trim().isNotEmpty)
        .map(
          (item) => AdminLibraryStatsRankedEntry(
            label: item.title,
            value: item.duration,
            trailing: formatDurationLong(Duration(seconds: item.duration.round())),
            onTap: item.id.trim().isEmpty ? null : () => context.push('/item/${item.id}'),
          ),
        )
        .toList(growable: false);
  }

  List<AdminLibraryStatsRankedEntry> _buildLargestItemEntries(BuildContext context, LibraryStats stats) {
    return stats.largestItems
        .where((item) => item.title.trim().isNotEmpty)
        .map(
          (item) => AdminLibraryStatsRankedEntry(
            label: item.title,
            value: item.size.toDouble(),
            trailing: formatBytes(item.size),
            onTap: item.id.trim().isEmpty ? null : () => context.push('/item/${item.id}'),
          ),
        )
        .toList(growable: false);
  }

  int _percentOfTotal(int value, int total) => total <= 0 ? 0 : ((value / total) * 100).round();

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const StatsMessage(
            icon: Icons.person_off_outlined,
            title: 'Sign in to view library statistics',
            message: 'An active admin account is required.',
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return const StatsMessage(
            icon: Icons.admin_panel_settings_outlined,
            title: 'Admin access required',
            message: 'Library-wide statistics are only available to administrators.',
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          _activeLibraryId = null;
          _statsByLibraryId.clear();
          _errorMessage = null;
          _loadingLibraryId = null;
          _requestGeneration++;
        }

        if (selectedLibrary == null) {
          return const StatsMessage(
            icon: Icons.video_library_outlined,
            title: 'Choose a library',
            message: 'Use the library switcher in the app bar to select a library to inspect.',
          );
        }

        final libraryId = selectedLibrary.id;
        if (_activeLibraryId != libraryId) {
          _activeLibraryId = libraryId;
          _errorMessage = null;
        }

        final stats = _statsByLibraryId[libraryId];
        final isLoading = _loadingLibraryId == libraryId;
        if (stats == null && !isLoading && _errorMessage == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _activeLibraryId == libraryId) {
              unawaited(_loadStatsForLibrary(libraryId));
            }
          });
        }

        final isBookLibrary = selectedLibrary.mediaType.toLowerCase() == 'book';
        return Padding(
          padding: EdgeInsets.fromLTRB(context.isMobile ? 12 : 24, 8, context.isMobile ? 12 : 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLoading && stats != null) ...[const SizedBox(height: 8), const LinearProgressIndicator()],
              const SizedBox(height: 8),
              if (_errorMessage case final message?)
                StatsMessage(
                  icon: Icons.cloud_off_rounded,
                  title: 'Unable to load library statistics',
                  message: message,
                  action: FilledButton.tonalIcon(
                    onPressed: () => unawaited(_loadStatsForLibrary(libraryId, forceRefresh: true)),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                )
              else if (stats == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 72),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                StatsSection(
                  title: 'Library overview',
                  icon: Icons.space_dashboard_rounded,
                  trailing: IconButton.filled(
                    tooltip: 'Refresh library statistics',
                    onPressed: isLoading ? null : () => unawaited(_loadStatsForLibrary(libraryId, forceRefresh: true)),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  child: AdminLibraryStatsPreviewIcons(stats: stats, isBookLibrary: isBookLibrary),
                ),
                const SizedBox(height: 16),
                _LibraryRankingsGrid(
                  sections: [
                    AdminLibraryStatsRankedSection(
                      title: 'Top genres',
                      icon: Icons.sell_rounded,
                      entries: _buildGenreEntries(context, stats),
                      emptyMessage: 'No genre information is available.',
                    ),
                    if (isBookLibrary)
                      AdminLibraryStatsRankedSection(
                        title: 'Top authors',
                        icon: Icons.people_alt_rounded,
                        entries: _buildAuthorEntries(context, stats),
                        emptyMessage: 'No author information is available.',
                      ),
                    AdminLibraryStatsRankedSection(
                      title: 'Longest items',
                      icon: Icons.timelapse_rounded,
                      entries: _buildLongestItemEntries(context, stats),
                      emptyMessage: 'No item duration information is available.',
                    ),
                    AdminLibraryStatsRankedSection(
                      title: 'Largest items',
                      icon: Icons.storage_rounded,
                      entries: _buildLargestItemEntries(context, stats),
                      emptyMessage: 'No item size information is available.',
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => StatsMessage(
        icon: Icons.person_off_outlined,
        title: 'Unable to load the active user',
        message: error.toString(),
      ),
    );
  }
}

class _LibraryRankingsGrid extends StatelessWidget {
  const _LibraryRankingsGrid({required this.sections});

  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = !context.isMobile && constraints.maxWidth >= 760;
        const spacing = 16.0;
        final width = useTwoColumns ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [for (final section in sections) SizedBox(width: width, child: section)],
        );
      },
    );
  }
}
