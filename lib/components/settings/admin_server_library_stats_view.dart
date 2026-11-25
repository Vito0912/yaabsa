import 'dart:async';

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/components/settings/admin_library_stats_preview_icons.dart';
import 'package:yaabsa/components/settings/admin_library_stats_ranked_section.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/item_view_navigation.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
    if (!forceRefresh && _statsByLibraryId.containsKey(libraryId)) {
      return;
    }

    final l10n = currentAppLocalizations();

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() => _errorMessage = l10n.errorConnectionUnavailable);
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
      if (!mounted || requestUserId != _activeUserId) {
        return;
      }

      setState(() => _statsByLibraryId[libraryId] = stats);
    } catch (_) {
      if (!mounted ||
          requestUserId != _activeUserId ||
          requestGeneration != _requestGeneration ||
          _activeLibraryId != libraryId) {
        return;
      }
      setState(() => _errorMessage = l10n.statsLibraryLoadError);
    } finally {
      if (mounted && requestGeneration == _requestGeneration) {
        setState(() => _loadingLibraryId = null);
      }
    }
  }

  List<AdminLibraryStatsRankedEntry> _buildGenreEntries(BuildContext context, LibraryStats stats) {
    final l10n = context.l10n;
    final percentageFormat = NumberFormat.percentPattern(l10n.localeName)..maximumFractionDigits = 0;
    final totalItems = stats.totalItems ?? 0;
    return stats.genresWithCount
        .where((genre) => genre.genre.trim().isNotEmpty)
        .map(
          (genre) => AdminLibraryStatsRankedEntry(
            label: genre.genre,
            value: genre.count.toDouble(),
            trailing: percentageFormat.format(totalItems <= 0 ? 0 : genre.count / totalItems),
            onTap: () {
              final filter = LibraryFilter.grouped(LibraryFilterGroup.genres, genre.genre).queryValue;
              unawaited(openLibraryWithFilter(context, ref, filter: filter));
            },
          ),
        )
        .toList(growable: false);
  }

  List<AdminLibraryStatsRankedEntry> _buildAuthorEntries(BuildContext context, LibraryStats stats) {
    final numberFormat = NumberFormat.decimalPattern(context.l10n.localeName);

    return stats.authorsWithCount
        .where((author) => author.name.trim().isNotEmpty)
        .map(
          (author) => AdminLibraryStatsRankedEntry(
            label: author.name,
            value: author.count.toDouble(),
            trailing: numberFormat.format(author.count),
            onTap: author.id.trim().isEmpty ? null : () => context.push('/author/${Uri.encodeComponent(author.id)}'),
          ),
        )
        .toList(growable: false);
  }

  List<AdminLibraryStatsRankedEntry> _buildLongestItemEntries(BuildContext context, LibraryStats stats) {
    final l10n = context.l10n;

    return stats.longestItems
        .where((item) => item.title.trim().isNotEmpty)
        .map(
          (item) => AdminLibraryStatsRankedEntry(
            label: item.title,
            value: item.duration,
            trailing: formatDurationLong(Duration(seconds: item.duration.round()), localizations: l10n),
            onTap: item.id.trim().isEmpty ? null : () => context.push('/item/${item.id}'),
          ),
        )
        .toList(growable: false);
  }

  List<AdminLibraryStatsRankedEntry> _buildLargestItemEntries(BuildContext context, LibraryStats stats) {
    final l10n = context.l10n;

    return stats.largestItems
        .where((item) => item.title.trim().isNotEmpty)
        .map(
          (item) => AdminLibraryStatsRankedEntry(
            label: item.title,
            value: item.size.toDouble(),
            trailing: formatBytes(item.size, localizations: l10n),
            onTap: item.id.trim().isEmpty ? null : () => context.push('/item/${item.id}'),
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentUserAsync = ref.watch(currentUserProvider);
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return StatsMessage(
            icon: Icons.person_off_outlined,
            title: l10n.navLibraryStats,
            message: l10n.promptSignInToViewLibraryStatistics,
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return StatsMessage(
            icon: Icons.admin_panel_settings_outlined,
            title: l10n.errorAdminRequired,
            message: l10n.errorAdminLibraryStatistics,
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
          return StatsMessage(
            icon: Icons.video_library_outlined,
            title: l10n.navLibraries,
            message: l10n.errorNoLibrarySelected,
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
              if (isLoading && stats != null) ...[const SizedBox(height: 8), const YaabsaLinearProgressIndicator()],
              const SizedBox(height: 8),
              if (_errorMessage case final message?)
                StatsMessage(
                  icon: Icons.cloud_off_rounded,
                  title: l10n.statsLibraryLoadError,
                  message: message,
                  action: FilledButton.tonalIcon(
                    onPressed: () => unawaited(_loadStatsForLibrary(libraryId, forceRefresh: true)),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(l10n.actionRetry),
                  ),
                )
              else if (stats == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 72),
                  child: Center(child: YaabsaCircularProgressIndicator()),
                )
              else ...[
                StatsSection(
                  title: l10n.statsLibraryOverview,
                  icon: Icons.space_dashboard_rounded,
                  trailing: IconButton.filled(
                    tooltip: l10n.actionRefresh,
                    onPressed: isLoading ? null : () => unawaited(_loadStatsForLibrary(libraryId, forceRefresh: true)),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  child: AdminLibraryStatsPreviewIcons(stats: stats, isBookLibrary: isBookLibrary),
                ),
                const SizedBox(height: 16),
                _LibraryRankingsGrid(
                  sections: [
                    AdminLibraryStatsRankedSection(
                      title: l10n.headingTopGenres,
                      icon: Icons.sell_rounded,
                      entries: _buildGenreEntries(context, stats),
                      emptyMessage: l10n.statsNoGenreInformation,
                    ),
                    if (isBookLibrary)
                      AdminLibraryStatsRankedSection(
                        title: l10n.headingTopAuthors,
                        icon: Icons.people_alt_rounded,
                        entries: _buildAuthorEntries(context, stats),
                        emptyMessage: l10n.statsNoAuthorInformation,
                      ),
                    AdminLibraryStatsRankedSection(
                      title: l10n.statsLongestItems,
                      icon: Icons.timelapse_rounded,
                      entries: _buildLongestItemEntries(context, stats),
                      emptyMessage: l10n.statsNoItemDurationInformation,
                    ),
                    AdminLibraryStatsRankedSection(
                      title: l10n.statsLargestItems,
                      icon: Icons.storage_rounded,
                      entries: _buildLargestItemEntries(context, stats),
                      emptyMessage: l10n.statsNoItemSizeInformation,
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
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (error, _) => StatsMessage(
        icon: Icons.person_off_outlined,
        title: l10n.errorOperationFailed(l10n.operationLoadUser, l10n.errorUnknown),
        message: l10n.errorUnknown,
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
