import 'dart:async';

import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/media/audio_browse_icon.dart';
import 'package:yaabsa/screens/wear/components/wear_media_browse_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/provider/wear/wear_browse_feed_provider.dart';
import 'package:yaabsa/provider/wear/wear_sign_in_provider.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/screens/wear/components/wear_cover_grid_row.dart';
import 'package:yaabsa/screens/wear/wear_item_screen.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';
import 'package:yaabsa/util/globals.dart' show BreakpointContextX;

class WearBrowseScreen extends ConsumerStatefulWidget {
  const WearBrowseScreen({required this.title, required this.query, super.key});

  final String title;
  final CompactBrowseQuery query;

  @override
  ConsumerState<WearBrowseScreen> createState() => _WearBrowseScreenState();
}

class _WearBrowseScreenState extends ConsumerState<WearBrowseScreen> {
  void _loadMore() {
    unawaited(ref.read(wearBrowseFeedProvider(widget.query).notifier).loadMore());
  }

  void _refresh() {
    ref.read(wearBrowseFeedProvider(widget.query).notifier).refresh();
  }

  void _open(CompactBrowseEntry entry) {
    final destination = entry.destination;
    final Widget screen;
    if (destination != null) {
      screen = WearBrowseScreen(title: entry.title, query: destination);
    } else {
      screen = WearItemScreen(entry: entry, handler: wearAudioHandler);
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Widget _entryIcon(CompactBrowseEntry entry) {
    final libraryIcon = entry.libraryIcon;
    if (libraryIcon != null) {
      return AudioBrowseIcon.library(libraryIcon);
    }

    final name = switch (entry.destination?.section) {
      CompactBrowseSection.recent || CompactBrowseSection.latestEpisodes => 'recent',
      CompactBrowseSection.authors => 'person',
      CompactBrowseSection.series => 'column',
      CompactBrowseSection.continueListening => 'continue_ic',
      CompactBrowseSection.downloads => 'download',
      _ => 'apps',
    };

    return AudioBrowseIcon(name: name);
  }

  bool _isMediaEntry(CompactBrowseEntry entry) {
    return entry.itemId != null || entry.destination?.section == CompactBrowseSection.episodes;
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(wearBrowseFeedProvider(widget.query));
    final feed = result.value;
    final entries = feed?.entries ?? const <CompactBrowseEntry>[];
    final gridEnabled = ref.watch(wearPreferencesProvider.select((preferences) => preferences.coverGrid));
    final useGrid = gridEnabled && entries.isNotEmpty && entries.every(_isMediaEntry);
    final columns = context.screenWidth >= 185 ? 3 : 2;
    final mediaRowCount = useGrid ? (entries.length + columns - 1) ~/ columns : entries.length;
    final controls = <Widget>[
      if (result.isLoading)
        const Center(child: YaabsaCircularProgressIndicator(strokeWidth: 2, size: 32))
      else if (result.hasError) ...[
        Text(wearRequestError(result.error!), textAlign: TextAlign.center),
        WearBrowseButton(title: 'Retry', icon: Icons.refresh, onPressed: _refresh),
      ] else if (entries.isEmpty)
        const Text('No items', textAlign: TextAlign.center),
      if (!result.isLoading && !result.hasError && feed?.loadingMore == true)
        const Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: SizedBox.square(dimension: 24, child: YaabsaCircularProgressIndicator(strokeWidth: 2, size: 24)),
          ),
        ),
      if (!result.isLoading && !result.hasError && feed?.loadMoreError != null) ...[
        Text(wearRequestError(feed!.loadMoreError!), textAlign: TextAlign.center),
        WearBrowseButton(title: 'Retry', icon: Icons.refresh, onPressed: _loadMore),
      ],
      if (!result.isLoading && !result.hasError)
        WearBrowseButton(title: 'Refresh', icon: Icons.refresh, onPressed: feed?.loadingMore == true ? null : _refresh),
    ];

    return WearBrowseScaffold(
      title: widget.title,
      onLoadMore:
          !result.isLoading &&
              !result.hasError &&
              feed?.hasMore == true &&
              feed?.loadingMore == false &&
              feed?.loadMoreError == null
          ? _loadMore
          : null,
      itemCount: mediaRowCount + controls.length,
      itemBuilder: (context, index) {
        if (index >= mediaRowCount) {
          return controls[index - mediaRowCount];
        }

        if (useGrid) {
          final start = index * columns;
          final rowEntries = entries.skip(start).take(columns).toList(growable: false);
          return WearCoverGridRow(entries: rowEntries, columns: columns, onOpen: _open);
        }

        final entry = entries[index];
        final hasMedia = _isMediaEntry(entry);
        if (hasMedia) {
          return WearMediaBrowseButton(entry: entry, onPressed: () => _open(entry));
        }

        return WearBrowseButton(
          title: entry.title,
          subtitle: entry.subtitle,
          leading: _entryIcon(entry),
          onPressed: () => _open(entry),
        );
      },
    );
  }
}
