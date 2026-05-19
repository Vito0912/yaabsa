import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';
import 'package:yaabsa/components/app/library/library_multi_select_host.dart';
import 'package:yaabsa/components/common/author_card.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/widget_bridge.dart';

import 'package:yaabsa/generated/l10n.dart';

class PersonalizedView extends HookConsumerWidget {
  const PersonalizedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final editingItemId = useState<String?>(null);
    final selectedLibrary = ref.watch(selectedLibraryProvider);

    if (selectedLibrary == null) {
      return Center(child: Text(S.current.screensMainPersonalizedViewNoLibrarySelectedPleaseSelectA));
    }

    final serverReachable = ref.watch(serverStatusProvider).value ?? false;
    final personalizedLibraryAsyncValue = ref.watch(personalizedLibraryProvider(selectedLibrary.id));
    final showShelfPlayButtonSettingValue = ref.watch(
      globalSettingByKeyProvider(SettingKeys.personalizedShelfShowPlayVisibleButton),
    );
    final showShelfPlayButton = SettingsParser.decodeValue<bool>(
      showShelfPlayButtonSettingValue.value,
      defaultSettings[SettingKeys.personalizedShelfShowPlayVisibleButton] as bool,
    );
    final filterDataAsync = ref.watch(libraryFilterDataProvider(selectedLibrary.id));
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final mediaProgressMap = ref.watch(mediaProgressProvider).asData?.value ?? const <String, MediaProgress>{};
    final personalizedLibraryForWidgets = personalizedLibraryAsyncValue.asData?.value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appLifecycleState = useAppLifecycleState();

    useEffect(
      () {
        final personalizedLibrary = personalizedLibraryForWidgets;
        if (personalizedLibrary == null) {
          return null;
        }

        unawaited(
          Future<void>(() async {
            await WidgetBridge.publishPersonalizedLibrarySnapshots(
              userId: currentUser?.id,
              userName: currentUser?.username,
              libraryId: selectedLibrary.id,
              libraryName: selectedLibrary.name,
              personalizedLibrary: personalizedLibrary,
              isDarkMode: isDarkMode,
            );

            if (appLifecycleState == AppLifecycleState.resumed) {
              final shouldPopulateAll = await WidgetBridge.consumePopulateAllRequest();
              if (shouldPopulateAll) {
                await WidgetBridge.triggerWidgetUpdate();
              }
            }
          }),
        );

        return null;
      },
      [
        selectedLibrary.id,
        selectedLibrary.name,
        personalizedLibraryForWidgets,
        isDarkMode,
        appLifecycleState,
        currentUser?.id,
        currentUser?.username,
        currentUser?.preferredAuthToken,
      ],
    );

    Future<void> refreshPersonalizedLibrary({bool withLoading = false}) {
      return ref
          .read(personalizedLibraryProvider(selectedLibrary.id).notifier)
          .refresh(selectedLibrary.id, withLoading: withLoading);
    }

    return personalizedLibraryAsyncValue.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (personalizedLibrary) {
        final api = ref.watch(absApiProvider);
        if (api == null) {
          return _PersonalizedFeedbackView(
            icon: Icons.cloud_off_rounded,
            title: S.current.screensMainPersonalizedViewNoServerConnectionAvailable,
            message: S.current.screensMainPersonalizedViewPullDownToRefreshOnceYourConnectionIs,
            onRefresh: refreshPersonalizedLibrary,
          );
        }

        if (personalizedLibrary == null) {
          return _PersonalizedFeedbackView(
            icon: serverReachable ? Icons.auto_awesome_outlined : Icons.cloud_off_rounded,
            title: serverReachable
                ? S.current.screensMainPersonalizedViewNoPersonalizedItemsFound
                : S.current.screensMainPersonalizedViewPersonalizedShelfIsOffline,
            message: serverReachable
                ? S.current.screensMainPersonalizedViewNoPersonalizedSectionsAreAvailableForThis
                : S.current.screensMainPersonalizedViewUnableToReachTheServerRightNowPull,
            onRefresh: refreshPersonalizedLibrary,
          );
        }

        final sections = _buildSections(personalizedLibrary);
        if (sections.isEmpty) {
          return _PersonalizedFeedbackView(
            icon: Icons.view_carousel_outlined,
            title: S.current.screensMainPersonalizedViewNoPersonalizedSectionsAvailableYet,
            message: S.current.screensMainPersonalizedViewPullDownToRefreshAndTryAgain,
            onRefresh: refreshPersonalizedLibrary,
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width >= 1200
                ? 24.0
                : width >= 700
                ? 18.0
                : 10.0;
            final verticalPadding = width >= 1200 ? 22.0 : 14.0;
            final libraryTileWidth = appGridTileWidth;
            final visibleLibraryItems = _collectVisibleShelfLibraryItems(sections);
            final canManageBooks = selectedLibrary.mediaType == 'book';
            final hasUpdatePermission = currentUser?.permissions.update ?? false;
            final hasDeletePermission = currentUser?.permissions.delete ?? false;
            final canEditItems = hasUpdatePermission && managementPreferences.editItemsEnabled;
            final canQuickMatchItems =
                canManageBooks && canEditItems && managementPreferences.allowMatchesQuickMatchesEnabled;
            final editableItemIds = visibleLibraryItems
                .where((item) => item.collapsedSeries == null)
                .map((item) => item.id)
                .toList(growable: false);

            if (editingItemId.value != null && !editableItemIds.contains(editingItemId.value)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                editingItemId.value = null;
              });
            }

            return LibraryMultiSelectHost(
              scopeKey: 'shelf:${selectedLibrary.id}',
              libraryId: selectedLibrary.id,
              visibleItems: visibleLibraryItems,
              canAddToPlaylist: canManageBooks && currentUser != null,
              canAddToCollection: canManageBooks && hasUpdatePermission && managementPreferences.collectionsEnabled,
              canQuickMatchItems: canQuickMatchItems,
              canDeleteItems: canManageBooks && hasDeletePermission && managementPreferences.deleteItemsEnabled,
              currentUserId: currentUser?.id,
              onAfterDelete: () => refreshPersonalizedLibrary(withLoading: false),
              builder: (context, selection) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: [
                          if (!serverReachable) const _PersonalizedConnectionBanner(),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: refreshPersonalizedLibrary,
                              child: ListView.separated(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  verticalPadding,
                                  horizontalPadding,
                                  verticalPadding,
                                ),
                                itemCount: sections.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final section = sections[index];
                                  return _SectionRow(
                                    section: section,
                                    api: api,
                                    libraryTileWidth: libraryTileWidth,
                                    viewportWidth: width,
                                    showPlayVisibleButton: showShelfPlayButton,
                                    mediaProgressMap: mediaProgressMap,
                                    selectionMode: selection.selectionMode,
                                    selectedItemIds: selection.selectedItemIds,
                                    onToggleSelection: selection.toggleSelectionById,
                                    onEnterSelectionMode: selection.enterSelectionById,
                                    canEditItems: canEditItems,
                                    onEditItem: (item) {
                                      if (selection.selectionMode || item.collapsedSeries != null) {
                                        return;
                                      }
                                      editingItemId.value = item.id;
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ScrollToTopButton(controller: scrollController),
                    if (editingItemId.value != null && editableItemIds.contains(editingItemId.value))
                      LibraryItemEditOverlay(
                        orderedItemIds: editableItemIds,
                        currentItemId: editingItemId.value!,
                        filterData: filterDataAsync.asData?.value,
                        onSelectItem: (itemId) {
                          editingItemId.value = itemId;
                        },
                        onClose: () {
                          editingItemId.value = null;
                        },
                        onItemSaved: (_, _) async {},
                      ),
                  ],
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        final title = serverReachable ? 'Could not load personalized shelf' : 'Server connection unavailable';
        final message = serverReachable
            ? 'Pull down to retry loading personalized sections.'
            : 'You appear to be offline. Pull down to retry after reconnecting.';

        return _PersonalizedFeedbackView(
          icon: serverReachable ? Icons.error_outline_rounded : Icons.cloud_off_rounded,
          title: title,
          message: message,
          detail: error.toString(),
          onRefresh: () => refreshPersonalizedLibrary(withLoading: true),
        );
      },
    );
  }
}

class _PersonalizedConnectionBanner extends StatelessWidget {
  const _PersonalizedConnectionBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 18, color: colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.current.screensMainPersonalizedViewServerConnectionIsUnstableDisplayingThe,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalizedFeedbackView extends StatelessWidget {
  const _PersonalizedFeedbackView({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRefresh,
    this.detail,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? detail;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 36, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      if (detail != null && detail!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          detail!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () async {
                              await onRefresh();
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(S.current.screensMainPersonalizedViewRetry),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.go('/?tab=downloads&intent=downloads');
                            },
                            icon: const Icon(Icons.download_rounded),
                            label: Text(S.current.screensMainPersonalizedViewOpenDownloads),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _ShelfEntityKind { libraryItem, series, author, episode }

const _continueListeningShelfId = 'continue-listening';
const _newestEpisodesShelfId = 'newest-episodes';

class _SectionData {
  _SectionData({required this.id, required this.title, required this.kind, required this.entities});

  final String id;
  final String title;
  final _ShelfEntityKind kind;
  final List<Object> entities;
}

List<_SectionData> _buildSections(PersonalizedLibrary library) {
  final sections = <_SectionData>[];

  void addSection<T>(ShelfEntry<T>? shelf, _ShelfEntityKind kind) {
    if (shelf == null || shelf.entities.isEmpty) return;
    sections.add(_SectionData(id: shelf.id, title: shelf.label, kind: kind, entities: shelf.entities.cast<Object>()));
  }

  ShelfEntry<LibraryItem>? newestEpisodesAsLibraryItems;
  for (final shelf in library.extraLibraryShelves) {
    if (shelf.id == _newestEpisodesShelfId) {
      newestEpisodesAsLibraryItems = shelf;
      break;
    }
  }

  addSection(library.continueListening, _ShelfEntityKind.libraryItem);
  addSection(newestEpisodesAsLibraryItems, _ShelfEntityKind.libraryItem);
  addSection(library.listenAgain, _ShelfEntityKind.libraryItem);

  addSection(library.continueSeries, _ShelfEntityKind.libraryItem);
  addSection(library.recentlyAdded, _ShelfEntityKind.libraryItem);
  addSection(library.discover, _ShelfEntityKind.libraryItem);
  addSection(library.recentSeries, _ShelfEntityKind.series);
  addSection(library.newestAuthors, _ShelfEntityKind.author);

  if (newestEpisodesAsLibraryItems == null) {
    addSection(library.newestEpisodes, _ShelfEntityKind.episode);
  }

  for (final shelf in library.extraLibraryShelves) {
    if (shelf.id == _newestEpisodesShelfId) {
      continue;
    }
    addSection(shelf, _ShelfEntityKind.libraryItem);
  }

  for (final shelf in library.extraEpisodeShelves) {
    addSection(shelf, _ShelfEntityKind.episode);
  }

  return sections;
}

List<LibraryItem> _collectVisibleShelfLibraryItems(List<_SectionData> sections) {
  final items = <LibraryItem>[];
  final seenIds = <String>{};

  for (final section in sections) {
    for (final entity in section.entities) {
      if (entity is! LibraryItem) {
        continue;
      }

      if (!seenIds.add(entity.id)) {
        continue;
      }

      items.add(entity);
    }
  }

  return items;
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.section,
    required this.api,
    required this.libraryTileWidth,
    required this.viewportWidth,
    required this.showPlayVisibleButton,
    required this.mediaProgressMap,
    required this.selectionMode,
    required this.selectedItemIds,
    required this.onToggleSelection,
    required this.onEnterSelectionMode,
    required this.canEditItems,
    required this.onEditItem,
  });

  final _SectionData section;
  final ABSApi api;
  final double libraryTileWidth;
  final double viewportWidth;
  final bool showPlayVisibleButton;
  final Map<String, MediaProgress> mediaProgressMap;
  final bool selectionMode;
  final Set<String> selectedItemIds;
  final ValueChanged<String> onToggleSelection;
  final ValueChanged<String> onEnterSelectionMode;
  final bool canEditItems;
  final ValueChanged<LibraryItem> onEditItem;

  bool get _supportsPlayVisibleButton {
    return section.id == _continueListeningShelfId || section.id == _newestEpisodesShelfId;
  }

  List<_SectionPlayableEntry> _collectPlayableEntries() {
    final playableEntries = <_SectionPlayableEntry>[];

    for (final entity in section.entities) {
      if (entity is! LibraryItem) {
        continue;
      }

      if (entity.mediaType == 'podcast') {
        final playableEpisode = _playablePodcastEpisode(entity);
        if (playableEpisode != null) {
          playableEntries.add(_SectionPlayableEntry.podcastEpisode(entity, playableEpisode));
        }
        continue;
      }

      if (!(entity.media?.hasAudio ?? false)) {
        continue;
      }

      if (_isFinishedProgress(mediaProgressMap[entity.id])) {
        continue;
      }

      playableEntries.add(_SectionPlayableEntry.libraryItem(entity));
    }

    return playableEntries;
  }

  Episode? _playablePodcastEpisode(LibraryItem item) {
    if (item.mediaType != 'podcast') {
      return null;
    }

    final episodes = (item.media?.podcastMedia?.episodes ?? const <Episode>[])
        .where((episode) => episode.audioFile != null)
        .toList(growable: false);
    if (episodes.isEmpty) {
      return null;
    }

    for (final episode in episodes) {
      final episodeProgress = mediaProgressMap[mediaProgressKey(item.id, episode.id)];
      if (_isFinishedProgress(episodeProgress)) {
        continue;
      }

      return episode;
    }

    return null;
  }

  bool _isFinishedProgress(MediaProgress? progress) {
    return progress?.isFinished ?? false;
  }

  Future<void> _playVisibleShelfItems(BuildContext context, List<_SectionPlayableEntry> playableEntries) async {
    if (playableEntries.isEmpty) {
      return;
    }

    try {
      final firstEntry = playableEntries.first;
      if (firstEntry.episode != null) {
        audioHandler.setQueueFromPodcastEpisode(firstEntry.item, firstEntry.episode!);
      } else {
        audioHandler.setQueueFromLibraryItem(firstEntry.item);
      }

      for (final entry in playableEntries.skip(1)) {
        if (entry.episode != null) {
          audioHandler.addPodcastEpisodeToQueue(entry.item, entry.episode!);
        } else {
          audioHandler.addLibraryItemToQueue(entry.item);
        }
      }

      await audioHandler.play();
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.screensMainPersonalizedViewFailedToQueueVisibleItems(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final playableEntries = _collectPlayableEntries();
    final canShowPlayVisibleButton =
        !selectionMode && showPlayVisibleButton && _supportsPlayVisibleButton && playableEntries.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
              child: Text(section.title, style: Theme.of(context).textTheme.titleMedium),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (canShowPlayVisibleButton) ...[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: IconButton(
                      onPressed: () {
                        _playVisibleShelfItems(context, playableEntries);
                      },
                      icon: const Icon(Icons.playlist_play_rounded, size: 18),
                      tooltip: S.current.screensMainPersonalizedViewQueueAllItemsInThisShelf,
                      splashRadius: 1,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.offset - (viewportWidth * 0.8),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                    splashRadius: 1,
                    padding: EdgeInsets.all(0.0),
                  ),
                ),
                SizedBox(width: 4),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.offset + (viewportWidth * 0.8),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    splashRadius: 1,
                    padding: EdgeInsets.all(0.0),
                  ),
                ),
              ],
            ),
          ],
        ),
        _SectionList(
          section: section,
          api: api,
          libraryTileWidth: libraryTileWidth,
          viewportWidth: viewportWidth,
          scrollController: scrollController,
          selectionMode: selectionMode,
          selectedItemIds: selectedItemIds,
          onToggleSelection: onToggleSelection,
          onEnterSelectionMode: onEnterSelectionMode,
          canEditItems: canEditItems,
          onEditItem: onEditItem,
        ),
      ],
    );
  }
}

class _SectionPlayableEntry {
  const _SectionPlayableEntry.libraryItem(this.item) : episode = null;
  const _SectionPlayableEntry.podcastEpisode(this.item, this.episode);

  final LibraryItem item;
  final Episode? episode;
}

class _SectionList extends StatelessWidget {
  const _SectionList({
    required this.section,
    required this.api,
    required this.libraryTileWidth,
    required this.viewportWidth,
    required this.scrollController,
    required this.selectionMode,
    required this.selectedItemIds,
    required this.onToggleSelection,
    required this.onEnterSelectionMode,
    required this.canEditItems,
    required this.onEditItem,
  });

  final _SectionData section;
  final ABSApi api;
  final double libraryTileWidth;
  final double viewportWidth;
  final ScrollController scrollController;
  final bool selectionMode;
  final Set<String> selectedItemIds;
  final ValueChanged<String> onToggleSelection;
  final ValueChanged<String> onEnterSelectionMode;
  final bool canEditItems;
  final ValueChanged<LibraryItem> onEditItem;

  @override
  Widget build(BuildContext context) {
    final seriesTileWidth = libraryTileWidth * 1.5;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < section.entities.length; index++) ...[
            _buildEntityTile(context, section.entities[index], seriesTileWidth),
            if (index < section.entities.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildLibraryItemTile(LibraryItem item) {
    return SizedBox(
      width: libraryTileWidth,
      child: LibraryItemWidget(
        item,
        api,
        showProgress: true,
        compact: true,
        squareCover: true,
        enableHoverSelection: true,
        selectionMode: selectionMode,
        isSelected: selectedItemIds.contains(item.id),
        canEdit: canEditItems,
        onEdit: () => onEditItem(item),
        onToggleSelection: () => onToggleSelection(item.id),
        onEnterSelectionMode: () => onEnterSelectionMode(item.id),
      ),
    );
  }

  Widget _buildEntityTile(BuildContext context, Object entity, double seriesTileWidth) {
    switch (section.kind) {
      case _ShelfEntityKind.libraryItem:
        return _buildLibraryItemTile(entity as LibraryItem);
      case _ShelfEntityKind.series:
        final series = entity as Series;
        final seriesEntry = MultiBookEntryData.fromSeries(series);

        return SizedBox(
          width: seriesTileWidth,
          child: MultiBookEntryWidget(
            api: api,
            entry: seriesEntry,
            compact: true,
            squareCover: true,
            coverHeight: libraryTileWidth,
            maxBooksToShow: defaultMultiBookPreviewLimit,
            onTap: () {
              context.push('/series/${series.id}', extra: seriesEntry);
            },
          ),
        );
      case _ShelfEntityKind.author:
        final author = entity as Author;
        return SizedBox(
          width: viewportWidth >= 1100 ? 260 : 220,
          child: AuthorCard(
            authorId: author.id,
            name: author.name,
            compact: true,
            onTap: () {
              context.push('/author/${author.id}');
            },
          ),
        );
      case _ShelfEntityKind.episode:
        if (entity is LibraryItem) {
          return _buildLibraryItemTile(entity);
        }

        final episode = entity as Episode;
        return SizedBox(
          width: viewportWidth >= 1100 ? 320 : 270,
          child: _MetaCard(
            icon: Icons.podcasts_outlined,
            title: episode.title ?? 'Untitled episode',
            subtitle: episode.subtitle,
          ),
        );
    }
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
