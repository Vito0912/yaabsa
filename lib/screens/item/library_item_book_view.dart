import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';
import 'package:yaabsa/components/app/item/item_delete_actions.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:yaabsa/components/app/item/library_item_view_components.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/components/common/loading_snackbar.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/item_view_navigation.dart';
import 'package:yaabsa/util/server_management_preferences.dart';

class LibraryItemBookView extends ConsumerWidget {
  const LibraryItemBookView({super.key, required this.item, required this.canDownload});

  final LibraryItem item;
  final bool canDownload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final libraryItemApi = api.getLibraryItemApi();
    final coverHeaders = normalizeImageRequestHeaders(api.dio.options.headers);
    final coverWidget = libraryItemApi.getLibraryItemCover(item.id, item: item);
    final topCover = item.hasCover
        ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                openCoverZoomView(
                  context,
                  coverUri: libraryItemApi.getCoverUri(item.id, item: item),
                  requestHeaders: coverHeaders,
                  semanticsLabel: item.title,
                );
              },
              child: coverWidget,
            ),
          )
        : coverWidget;

    final bookMedia = item.media?.bookMedia;
    final metadata = bookMedia?.metadata;
    final hasAudio = item.media?.hasAudio ?? false;
    final hasBook = item.media?.hasBook ?? false;
    final audioFiles = bookMedia?.audioFiles ?? const [];
    final chapters = bookMedia?.chapters ?? const [];
    final ebookFile = bookMedia?.ebookFile;

    final durationSeconds = item.media?.duration() ?? 0;
    final duration = durationSeconds > 0 ? Duration(seconds: durationSeconds.round()) : null;
    final sizeBytes = bookMedia?.size ?? item.size;

    final horizontalPadding = context.isMobile
        ? 8.0
        : context.isTablet
        ? 16.0
        : 24.0;
    final isLargeScreen = !context.isMobile;
    final maxWidth = context.isDesktop
        ? 1120.0
        : context.isTablet
        ? 940.0
        : double.infinity;

    final metadataRows = buildItemMetadataRows(
      context,
      metadata: metadata,
      tags: bookMedia?.tags,
      duration: duration,
      sizeBytes: sizeBytes,
      onFilterTap: (filter) => openLibraryWithFilter(context, ref, filter: filter),
    );
    final progressByKey = ref.watch(mediaProgressProvider).asData?.value;
    final isItemFinished = progressByKey != null && isLibraryItemFinished(item, progressByKey);

    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(userSettingsWatcherProvider);
    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final canEditItems = (currentUser?.permissions.update ?? false) && managementPreferences.editItemsEnabled;
    final filterData = item.libraryId == null ? null : ref.watch(libraryFilterDataProvider(item.libraryId!)).value;
    final canAddToPlaylist = canAddLibraryItemToPlaylist(item, currentUser?.id);
    final canAddToCollection = canAddLibraryItemToCollection(
      item,
      canUpdate: (currentUser?.permissions.update ?? false) && managementPreferences.collectionsEnabled,
    );
    final canDeleteItem = canDeleteAudiobook(
      item: item,
      hasDeletePermission: (currentUser?.permissions.delete ?? false) && managementPreferences.deleteItemsEnabled,
    );
    final appDatabase = ref.watch(appDatabaseProvider);
    final storedDownloadsStream = currentUser == null
        ? Stream<List<InternalDownload>>.value(const <InternalDownload>[])
        : appDatabase.watchStoredDownloadsByUser(currentUser.id);

    return StreamBuilder<List<TaskRecord>>(
      stream: downloadHandler.taskQueueStream,
      initialData: const <TaskRecord>[],
      builder: (context, taskSnapshot) {
        final activeTasks = taskSnapshot.data ?? const <TaskRecord>[];
        final isDownloadInProgress = activeTasks.any((task) => downloadHandler.taskBelongsToItem(task, item.id));

        return StreamBuilder<List<InternalDownload>>(
          stream: storedDownloadsStream,
          initialData: const <InternalDownload>[],
          builder: (context, storedSnapshot) {
            final storedDownloads = storedSnapshot.data ?? const <InternalDownload>[];
            final storedDownload = _findBookDownload(storedDownloads, item.id);
            final isDownloaded = storedDownload?.isComplete ?? false;

            return StreamBuilder<PlayerQueueSnapshot>(
              stream: audioHandler.queueSnapshotStream,
              initialData: audioHandler.queueSnapshot,
              builder: (context, queueSnapshot) {
                final isQueued = queueSnapshot.data?.entries.any((entry) => entry.item.itemId == item.id) ?? false;
                return StreamBuilder<PlayerState>(
                  stream: audioHandler.playerControlStateStream,
                  initialData: audioHandler.playerControlState,
                  builder: (context, playerStateSnapshot) {
                    final isCurrentItem = audioHandler.currentMediaItem?.itemId == item.id;

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LibraryItemTopContent(
                                isLargeScreen: isLargeScreen,
                                title: item.title,
                                subtitle: item.subtitle,
                                cover: topCover,
                                actionButtons: buildItemActionButtons(
                                  hasAudio: hasAudio,
                                  hasBook: hasBook,
                                  canDownload: canDownload,
                                  isDownloadInProgress: isDownloadInProgress,
                                  isDownloaded: isDownloaded,
                                  isQueued: isQueued,
                                  queueEnabled: !isCurrentItem,
                                  onPlay: () {
                                    audioHandler.playLibraryItem(item);
                                  },
                                  onRead: () {
                                    context.push('/ebook/${item.id}');
                                  },
                                  onDownload: () async {
                                    try {
                                      await downloadHandler.downloadFile(item.id);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(const SnackBar(content: Text('Download added to queue.')));
                                    } catch (e) {
                                      if (!context.mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text('Could not start download: $e')));
                                    }
                                  },
                                  onDeleteDownload: () async {
                                    if (currentUser == null || storedDownload == null) {
                                      return;
                                    }
                                    try {
                                      final result = await runWithLoadingSnackBar(
                                        context: context,
                                        message: 'Deleting downloaded files...',
                                        action: () => downloadHandler.deleteDownloadedItem(
                                          storedDownload,
                                          userId: currentUser.id,
                                        ),
                                      );
                                      if (!context.mounted) {
                                        return;
                                      }
                                      final failedSuffix = result.failedFiles > 0
                                          ? ' ${result.failedFiles} file(s) could not be removed.'
                                          : '';
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Deleted ${result.deletedFiles} file(s).$failedSuffix')),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) {
                                        return;
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(SnackBar(content: Text('Could not delete download: $e')));
                                    }
                                  },
                                  onQueueToggle: () {
                                    if (isQueued) {
                                      audioHandler.removeFromQueueByItemId(item.id);
                                      return;
                                    }

                                    audioHandler.addLibraryItemToQueue(item);
                                  },
                                  showMarkAsUnfinished: isItemFinished,
                                  showEditItem: canEditItems,
                                  showAddToPlaylist: canAddToPlaylist,
                                  showAddToCollection: canAddToCollection,
                                  showDeleteItem: canDeleteItem,
                                  onMoreActionSelected: (action) async {
                                    switch (action) {
                                      case ItemMoreAction.editItem:
                                        await _openSingleItemEditor(context, ref, item: item, filterData: filterData);
                                        return;
                                      case ItemMoreAction.markAsFinished:
                                        await markLibraryItemAsFinished(context: context, ref: ref, item: item);
                                        return;
                                      case ItemMoreAction.markAsUnfinished:
                                        await markLibraryItemAsUnfinished(context: context, ref: ref, item: item);
                                        return;
                                      case ItemMoreAction.addToPlaylist:
                                        await addLibraryItemToPlaylist(
                                          context: context,
                                          ref: ref,
                                          item: item,
                                          currentUserId: currentUser?.id,
                                        );
                                        return;
                                      case ItemMoreAction.addToCollection:
                                        await addLibraryItemToCollection(
                                          context: context,
                                          ref: ref,
                                          item: item,
                                          canUpdate: currentUser?.permissions.update ?? false,
                                        );
                                        return;
                                      case ItemMoreAction.deleteItem:
                                        await deleteAudiobookWithConfirmation(
                                          context: context,
                                          ref: ref,
                                          item: item,
                                          popOnSuccess: true,
                                        );
                                        return;
                                      case ItemMoreAction.playHistory:
                                        if (!context.mounted) {
                                          return;
                                        }
                                        context.push(PlayHistoryView.routeName);
                                        return;
                                    }
                                  },
                                ),
                                metadataRows: metadataRows,
                                item: item,
                                onBack: () => context.pop(),
                              ),
                              LibraryItemMediaSections(
                                itemId: item.id,
                                chapters: chapters,
                                audioFiles: audioFiles,
                                ebookFile: ebookFile,
                                onChapterTap: (chapter) {
                                  audioHandler.playItemFromPosition(
                                    itemId: item.id,
                                    position: Duration(seconds: chapter.start.round()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _openSingleItemEditor(
    BuildContext context,
    WidgetRef ref, {
    required LibraryItem item,
    required LibraryFilterData? filterData,
  }) async {
    await showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Edit item',
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              LibraryItemEditOverlay(
                orderedItemIds: [item.id],
                currentItemId: item.id,
                filterData: filterData,
                onSelectItem: (_) {},
                onClose: () {
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                onItemSaved: (_, _) async {},
              ),
            ],
          ),
        );
      },
    );
  }

  InternalDownload? _findBookDownload(List<InternalDownload> downloads, String itemId) {
    for (final download in downloads) {
      final targetId = download.item?.id ?? download.episode?.libraryItemId;
      if (targetId == itemId && download.episode == null) {
        return download;
      }
    }
    return null;
  }
}
