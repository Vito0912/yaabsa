import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_rss_feed.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/settings/rss_feeds/admin_rss_feed_details_dialog.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class AdminServerRssFeedsView extends ConsumerStatefulWidget {
  const AdminServerRssFeedsView({super.key});

  @override
  ConsumerState<AdminServerRssFeedsView> createState() => _AdminServerRssFeedsViewState();
}

class _AdminServerRssFeedsViewState extends ConsumerState<AdminServerRssFeedsView> {
  final TextEditingController _searchController = TextEditingController();

  String? _activeUserId;
  bool _isLoading = true;
  String _searchQuery = '';
  String? _errorMessage;

  final Set<String> _busyFeedIds = <String>{};
  List<AdminRssFeed> _feeds = const <AdminRssFeed>[];
  List<AdminRssFeedMinified> _minifiedFeeds = const <AdminRssFeedMinified>[];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Map<String, AdminRssFeedMinified> _minifiedById() {
    return {for (final value in _minifiedFeeds) value.id: value};
  }

  List<AdminRssFeed> _sortedFeeds(List<AdminRssFeed> values) {
    final sorted = List<AdminRssFeed>.from(values);
    final minifiedById = _minifiedById();

    sorted.sort((left, right) {
      final leftUpdated = left.updatedAt ?? 0;
      final rightUpdated = right.updatedAt ?? 0;
      final byUpdate = rightUpdated.compareTo(leftUpdated);
      if (byUpdate != 0) {
        return byUpdate;
      }

      final leftTitle = _resolvedTitle(left, minifiedById).toLowerCase();
      final rightTitle = _resolvedTitle(right, minifiedById).toLowerCase();
      final byTitle = leftTitle.compareTo(rightTitle);
      if (byTitle != 0) {
        return byTitle;
      }

      return left.id.compareTo(right.id);
    });

    return sorted;
  }

  Future<void> _loadFeeds({bool showLoading = true}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'No active API client.';
      });
      return;
    }

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await api.getAdminApi().getFeeds();
      final payload = response.data;

      if (!mounted) {
        return;
      }

      setState(() {
        _feeds = _sortedFeeds(payload?.feeds ?? const <AdminRssFeed>[]);
        _minifiedFeeds = payload?.minified ?? const <AdminRssFeedMinified>[];
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(error, fallback: 'Failed to load RSS feeds.');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _resolvedTitle(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) {
    final minifiedTitle = minifiedById[feed.id]?.meta?.title?.trim();
    if (minifiedTitle != null && minifiedTitle.isNotEmpty) {
      return minifiedTitle;
    }
    return feed.resolvedTitle;
  }

  String? _resolvedDescription(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) {
    final primary = feed.meta?.description?.trim();
    if (primary != null && primary.isNotEmpty) {
      return primary;
    }

    final minified = minifiedById[feed.id]?.meta?.description?.trim();
    if (minified != null && minified.isNotEmpty) {
      return minified;
    }

    return null;
  }

  String _entityLabel(String? entityType) {
    final normalized = (entityType ?? '').trim().toLowerCase();
    if (normalized == 'libraryitem') {
      return 'Item';
    }
    if (normalized == 'series') {
      return 'Series';
    }
    if (normalized == 'collection') {
      return 'Collection';
    }
    if (normalized.isEmpty) {
      return 'Unknown';
    }
    return normalized;
  }

  String? _resolveUrl({required String? baseUrl, required String? value}) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(trimmedValue);
    if (parsed != null && parsed.hasScheme) {
      return parsed.toString();
    }

    final trimmedBase = baseUrl?.trim();
    if (trimmedBase == null || trimmedBase.isEmpty) {
      return trimmedValue;
    }

    final parsedBase = Uri.tryParse(trimmedBase);
    if (parsedBase != null) {
      return parsedBase.resolve(trimmedValue).toString();
    }

    final normalizedBase = trimmedBase.endsWith('/') ? trimmedBase.substring(0, trimmedBase.length - 1) : trimmedBase;
    final normalizedPath = trimmedValue.startsWith('/') ? trimmedValue : '/$trimmedValue';
    return '$normalizedBase$normalizedPath';
  }

  String? _resolvedFeedUrl(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) {
    final minified = minifiedById[feed.id];
    final feedUrl =
        feed.feedUrl?.trim() ??
        feed.meta?.feedUrl?.trim() ??
        minified?.feedUrl?.trim() ??
        minified?.meta?.feedUrl?.trim();

    return _resolveUrl(baseUrl: feed.serverAddress, value: feedUrl);
  }

  String? _resolvedCoverImageUrl(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) {
    final minified = minifiedById[feed.id];
    final imageUrl = feed.meta?.imageUrl?.trim() ?? minified?.meta?.imageUrl?.trim();
    final resolvedImage = _resolveUrl(baseUrl: feed.serverAddress, value: imageUrl);
    if (resolvedImage != null && resolvedImage.isNotEmpty) {
      return resolvedImage;
    }

    final feedUrl = _resolvedFeedUrl(feed, minifiedById);
    if (feedUrl == null || feedUrl.isEmpty) {
      return null;
    }

    final normalized = feedUrl.endsWith('/') ? feedUrl.substring(0, feedUrl.length - 1) : feedUrl;
    return '$normalized/cover';
  }

  String _formatTimestamp(int? milliseconds) {
    if (milliseconds == null || milliseconds <= 0) {
      return 'Unknown';
    }

    final local = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  List<AdminRssFeed> _filteredFeeds(Map<String, AdminRssFeedMinified> minifiedById) {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return _feeds;
    }

    return _feeds
        .where((feed) {
          final title = _resolvedTitle(feed, minifiedById);
          final description = _resolvedDescription(feed, minifiedById) ?? '';
          final entityType = _entityLabel(feed.entityType);
          final feedUrl = _resolvedFeedUrl(feed, minifiedById) ?? '';
          final slug = feed.slug ?? '';
          final author = feed.meta?.author ?? minifiedById[feed.id]?.meta?.author ?? '';

          final searchable = '$title $description $entityType $feedUrl $slug $author ${feed.id}'.toLowerCase();
          return searchable.contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  void _setBusy(String feedId, bool busy) {
    setState(() {
      if (busy) {
        _busyFeedIds.add(feedId);
      } else {
        _busyFeedIds.remove(feedId);
      }
    });
  }

  Future<void> _showDetails(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) async {
    await showAdminRssFeedDetailsDialog(
      context: context,
      feed: feed,
      feedUrl: _resolvedFeedUrl(feed, minifiedById),
      coverImageUrl: _resolvedCoverImageUrl(feed, minifiedById),
    );
  }

  Future<void> _closeFeed(AdminRssFeed feed) async {
    if (_busyFeedIds.contains(feed.id)) {
      return;
    }

    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Close RSS feed?',
      message: 'Close "${feed.resolvedTitle}"?',
      confirmLabel: 'Close Feed',
    );

    if (!confirmed) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setBusy(feed.id, true);

    try {
      final success = await api.getAdminApi().closeFeed(feed.id);
      if (!success) {
        _showMessage('Failed to close RSS feed.');
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _feeds = _feeds.where((entry) => entry.id != feed.id).toList(growable: false);
        _minifiedFeeds = _minifiedFeeds.where((entry) => entry.id != feed.id).toList(growable: false);
      });

      _showMessage('RSS feed closed.');
      unawaited(_loadFeeds(showLoading: false));
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to close RSS feed.'));
    } finally {
      if (mounted) {
        _setBusy(feed.id, false);
      }
    }
  }

  Widget _buildFeedCover(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) {
    final imageUrl = _resolvedCoverImageUrl(feed, minifiedById);
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.rss_feed_rounded, color: colorScheme.onSurfaceVariant),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.rss_feed_rounded, color: colorScheme.onSurfaceVariant),
          );
        },
      ),
    );
  }

  Widget _buildFeedTitleCell(AdminRssFeed feed, Map<String, AdminRssFeedMinified> minifiedById) {
    final title = _resolvedTitle(feed, minifiedById);
    final description = _resolvedDescription(feed, minifiedById);

    return Row(
      children: [
        _buildFeedCover(feed, minifiedById),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (description != null && description.isNotEmpty)
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<ExpressiveTableColumn<AdminRssFeed>> _tableColumns(Map<String, AdminRssFeedMinified> minifiedById) {
    return [
      ExpressiveTableColumn<AdminRssFeed>(
        id: 'feed',
        label: 'Feed',
        width: 320,
        cellBuilder: (context, feed) => _buildFeedTitleCell(feed, minifiedById),
        mobileCellBuilder: (context, feed) {
          final title = _resolvedTitle(feed, minifiedById);
          final description = _resolvedDescription(feed, minifiedById);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (description != null && description.isNotEmpty)
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
            ],
          );
        },
        tooltipBuilder: (feed) => _resolvedTitle(feed, minifiedById),
      ),
      ExpressiveTableColumn<AdminRssFeed>(
        id: 'entity',
        label: 'Entity',
        width: 100,
        cellBuilder: (context, feed) =>
            Text(_entityLabel(feed.entityType), maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      ExpressiveTableColumn<AdminRssFeed>(
        id: 'episodes',
        label: 'Episodes',
        width: 92,
        cellBuilder: (context, feed) => Text('${feed.episodes.length}'),
      ),
      ExpressiveTableColumn<AdminRssFeed>(
        id: 'author',
        label: 'Author',
        width: 160,
        cellBuilder: (context, feed) {
          final author = feed.meta?.author?.trim() ?? minifiedById[feed.id]?.meta?.author?.trim();
          final resolved = author == null || author.isEmpty ? 'Unknown' : author;
          return Text(resolved, maxLines: 1, overflow: TextOverflow.ellipsis);
        },
      ),
      ExpressiveTableColumn<AdminRssFeed>(
        id: 'updated',
        label: 'Updated',
        width: 154,
        showOnMobile: false,
        alignment: ExpressiveTableCellAlignment.end,
        cellBuilder: (context, feed) => Text(_formatTimestamp(feed.updatedAt)),
      ),
    ];
  }

  Widget _buildToolbar({required bool compact, required int totalCount, required int filteredCount}) {
    final summaryText = filteredCount == totalCount ? '$totalCount feeds' : '$filteredCount of $totalCount feeds';

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            label: 'Search RSS feeds',
            controller: _searchController,
            hintText: 'Filter by title, URL, or author',
            prefixIcon: const Icon(Icons.search_rounded),
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  summaryText,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Refresh',
                onPressed: _isLoading ? null : () => unawaited(_loadFeeds(showLoading: true)),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: StyledTextField(
            label: 'Search RSS feeds',
            controller: _searchController,
            hintText: 'Filter by title, URL, author, or entity',
            prefixIcon: const Icon(Icons.search_rounded),
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Text(
          summaryText,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 12),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : () => unawaited(_loadFeeds(showLoading: true)),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  Widget _buildErrorCard() {
    final message = _errorMessage;
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
            TextButton(onPressed: () => unawaited(_loadFeeds(showLoading: true)), child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage RSS feeds.'),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('This page requires an admin account.'),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadFeeds(showLoading: true));
          });
        }

        final minifiedById = _minifiedById();
        final filteredFeeds = _filteredFeeds(minifiedById);
        final compact = context.isMobile;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading && _feeds.isNotEmpty) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 10),
              _buildErrorCard(),
              if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _loadFeeds(showLoading: false),
                  child: ExpressiveActionTable<AdminRssFeed>(
                    rows: filteredFeeds,
                    columns: _tableColumns(minifiedById),
                    rowId: (feed) => feed.id,
                    loading: _isLoading,
                    busyRowIds: _busyFeedIds,
                    onRowTap: (feed) => _showDetails(feed, minifiedById),
                    actions: [
                      ExpressiveTableAction<AdminRssFeed>(
                        icon: Icons.delete_outline_rounded,
                        tooltip: 'Close feed',
                        tone: ExpressiveTableActionTone.danger,
                        onPressed: _closeFeed,
                      ),
                    ],
                    emptyTitle: _searchQuery.trim().isEmpty ? 'No RSS feeds found' : 'No matches for your search',
                    emptySubtitle: _searchQuery.trim().isEmpty
                        ? 'Feeds created in Audiobookshelf will appear here.'
                        : 'Try a different title, URL, or author filter.',
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    topActions: _buildToolbar(
                      compact: compact,
                      totalCount: _feeds.length,
                      filteredCount: filteredFeeds.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Failed to load user data: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
