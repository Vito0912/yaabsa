import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/components/settings/admin_library_stats_preview_icons.dart';
import 'package:yaabsa/components/settings/admin_library_stats_ranked_section.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/item_view_navigation.dart';

import 'package:yaabsa/generated/l10n.dart';

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

  bool _isLoadingStats = false;
  String? _errorMessage;

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  Future<void> _loadStatsForLibrary(String libraryId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _statsByLibraryId.containsKey(libraryId)) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _errorMessage = 'No active API client.';
      });
      return;
    }

    setState(() {
      _isLoadingStats = true;
      _loadingLibraryId = libraryId;
      _errorMessage = null;
    });

    try {
      final response = await api.getLibraryApi().getLibraryStats(libraryId);
      final stats = response.data ?? const LibraryStats();

      if (!mounted) {
        return;
      }

      setState(() {
        _statsByLibraryId[libraryId] = stats;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load library stats: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStats = false;
          _loadingLibraryId = null;
        });
      }
    }
  }

  Future<void> _refreshLibraryStats(String libraryId) async {
    await _loadStatsForLibrary(libraryId, forceRefresh: true);
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
            onTap: author.id.trim().isEmpty
                ? null
                : () {
                    context.push('/author/${Uri.encodeComponent(author.id)}');
                  },
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

  int _percentOfTotal(int value, int total) {
    if (total <= 0) {
      return 0;
    }
    return ((value / total) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(S.current.componentsSettingsAdminServerLibraryStatsViewNoActiveUserSignInTo),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(S.current.componentsSettingsAdminServerLibraryStatsViewThisPageRequiresAnAdminAccount),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          _activeLibraryId = null;
          _statsByLibraryId.clear();
          _errorMessage = null;
          _isLoadingStats = false;
          _loadingLibraryId = null;
        }

        if (selectedLibrary == null) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(S.current.componentsSettingsAdminServerLibraryStatsViewSelectALibraryFromTheMain),
          );
        }

        final selectedLibraryId = selectedLibrary.id;
        if (_activeLibraryId != selectedLibraryId) {
          _activeLibraryId = selectedLibraryId;
          _errorMessage = null;
        }

        final selectedStats = _statsByLibraryId[selectedLibraryId];
        final isSelectedLibraryLoading = _isLoadingStats && _loadingLibraryId == selectedLibraryId;

        if (selectedStats == null && !isSelectedLibraryLoading && _errorMessage == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadStatsForLibrary(selectedLibraryId));
          });
        }

        final isBookLibrary = selectedLibrary.mediaType.toLowerCase() == 'book';

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(selectedLibrary.name, style: Theme.of(context).textTheme.titleMedium)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: S.current.componentsSettingsAdminServerLibraryStatsViewRefreshStats,
                    onPressed: isSelectedLibraryLoading
                        ? null
                        : () => unawaited(_refreshLibraryStats(selectedLibraryId)),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              if (_errorMessage != null && _errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _LibraryStatsErrorCard(
                    message: _errorMessage!,
                    onRetry: () => unawaited(_refreshLibraryStats(selectedLibraryId)),
                  ),
                ),
              if (selectedStats == null && isSelectedLibraryLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (selectedStats == null && _errorMessage == null)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (selectedStats == null)
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text(S.current.componentsSettingsAdminServerLibraryStatsViewNoStatsAvailableForTheSelected),
                )
              else ...[
                const SizedBox(height: 16),
                AdminLibraryStatsPreviewIcons(stats: selectedStats, isBookLibrary: isBookLibrary),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final panelWidth = constraints.maxWidth >= 920
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth;

                    final sections = <Widget>[
                      AdminLibraryStatsRankedSection(
                        title: 'Top 5 Genres',
                        entries: _buildGenreEntries(context, selectedStats),
                        maxItems: 5,
                        emptyMessage: 'No genres available.',
                      ),
                      if (isBookLibrary)
                        AdminLibraryStatsRankedSection(
                          title: 'Top 10 Authors',
                          entries: _buildAuthorEntries(context, selectedStats),
                          maxItems: 10,
                          emptyMessage: 'No authors available.',
                        ),
                      AdminLibraryStatsRankedSection(
                        title: 'Longest Items',
                        entries: _buildLongestItemEntries(context, selectedStats),
                        maxItems: 10,
                        emptyMessage: 'No items available.',
                      ),
                      AdminLibraryStatsRankedSection(
                        title: 'Largest Items',
                        entries: _buildLargestItemEntries(context, selectedStats),
                        maxItems: 10,
                        emptyMessage: 'No items available.',
                      ),
                    ];

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [for (final section in sections) SizedBox(width: panelWidth, child: section)],
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          S.current.componentsSettingsAdminServerLibraryStatsViewFailedToLoadUserData(error),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class _LibraryStatsErrorCard extends StatelessWidget {
  const _LibraryStatsErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
            TextButton(onPressed: onRetry, child: Text(S.current.componentsSettingsAdminServerLibraryStatsViewRetry)),
          ],
        ),
      ),
    );
  }
}
