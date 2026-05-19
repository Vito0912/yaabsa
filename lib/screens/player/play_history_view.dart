import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/sessions/library_item_listening_sessions_tab.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/play_history_local_tab.dart';
import 'package:yaabsa/util/globals.dart';

import 'package:yaabsa/generated/l10n.dart';

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
      return Scaffold(
        appBar: AppBar(title: Text(S.current.screensPlayerPlayHistoryViewPlayHistory)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                S.current.screensPlayerPlayHistoryViewNoUserOrMediaItemAvailable,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.screensPlayerPlayHistoryViewPlayHistory),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Local History'),
              Tab(text: 'Sessions'),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (resolvedTitle != null && resolvedTitle.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Text(
                  resolvedTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  PlayHistoryLocalTab(itemId: resolvedItemId, episodeId: resolvedEpisodeId),
                  _PlayHistorySessionsTab(itemId: resolvedItemId, episodeId: resolvedEpisodeId),
                ],
              ),
            ),
          ],
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
      error: (error, _) => Center(child: Text(S.current.screensPlayerPlayHistoryViewFailedToLoadItemSessions(error))),
    );
  }
}
