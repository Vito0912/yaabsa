import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/common/expressive_tab_view.dart';
import 'package:yaabsa/components/sessions/library_item_listening_sessions_tab.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/play_history_local_tab.dart';
import 'package:yaabsa/util/globals.dart';

class PlayHistoryView extends ConsumerWidget {
  const PlayHistoryView({super.key, this.itemId, this.episodeId, this.itemTitle});

  static const routeName = '/play-history';

  final String? itemId;
  final String? episodeId;
  final String? itemTitle;

  static String location({required String itemId, String? episodeId, String? itemTitle}) {
    final query = <String, String>{'itemId': itemId};
    if (episodeId != null && episodeId.trim().isNotEmpty) {
      query['episodeId'] = episodeId;
    }
    if (itemTitle != null && itemTitle.trim().isNotEmpty) {
      query['itemTitle'] = itemTitle;
    }

    return Uri(path: routeName, queryParameters: query).toString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final currentMedia = audioHandler.currentMediaItem;
    final resolvedItemId = itemId ?? currentMedia?.itemId;
    final resolvedEpisodeId = episodeId ?? currentMedia?.episodeId;
    final resolvedTitle = (itemTitle?.trim().isNotEmpty ?? false) ? itemTitle!.trim() : currentMedia?.title;

    if (user == null || resolvedItemId == null) {
      return const _PlayHistoryUnavailableView();
    }

    final horizontalPadding = context.isMobile ? 12.0 : 24.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Play history')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (resolvedTitle != null && resolvedTitle.isNotEmpty) ...[
                    Text(
                      resolvedTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Expanded(
                    child: ExpressiveTabView(
                      tabBarScrollable: false,
                      tabBarPadding: EdgeInsets.zero,
                      tabs: [
                        ExpressiveTabViewItem(
                          id: 'activity',
                          label: 'Activity',
                          child: PlayHistoryLocalTab(itemId: resolvedItemId, episodeId: resolvedEpisodeId),
                        ),
                        ExpressiveTabViewItem(
                          id: 'sessions',
                          label: 'Sessions',
                          child: _PlayHistorySessionsTab(itemId: resolvedItemId, episodeId: resolvedEpisodeId),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayHistoryUnavailableView extends StatelessWidget {
  const _PlayHistoryUnavailableView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Play history')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_rounded, size: 40, color: colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text('Nothing to show yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                'Start playing an audiobook or podcast, then open its history again.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayHistorySessionsTab extends ConsumerWidget {
  const _PlayHistorySessionsTab({required this.itemId, required this.episodeId});

  final String itemId;
  final String? episodeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(libraryItemProvider(itemId));

    return itemAsync.when(
      data: (item) => LibraryItemListeningSessionsTab(item: item, initialEpisodeId: episodeId),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _SessionLoadError(error: error),
    );
  }
}

class _SessionLoadError extends StatelessWidget {
  const _SessionLoadError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 36, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text('Could not load sessions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
