import 'package:dio/dio.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/book_media.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/media.dart';
import 'package:yaabsa/api/library_items/media_metadata.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/app/library/library_items_grid.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/common/stored_downloads_provider.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/models/internal_media.dart';

const libraryGridPreviewItemCount = 120;

final libraryGridPreviewItems = List<LibraryItem>.unmodifiable(
  List<LibraryItem>.generate(libraryGridPreviewItemCount, (index) {
    final edition = index + 1;
    final title = switch (index % 4) {
      0 => 'The Distant Shore',
      1 => 'A Map of the Quiet Sea',
      2 => 'The Cartographer’s Promise',
      _ => 'When the Harbor Lights Return',
    };
    final author = switch (index % 5) {
      0 => 'Mira Ellery',
      1 => 'Jonas Vale',
      2 => 'Nadia Rowan',
      3 => 'Elena Mar',
      _ => 'A. Northstar',
    };

    return LibraryItem(
      id: 'ui-lab-library-item-$edition',
      ino: 'ui-lab-library-item-$edition',
      mediaType: 'book',
      media: Media(
        bookMedia: BookMedia(
          id: 'ui-lab-library-media-$edition',
          metadata: MediaMetadata(title: '$title $edition', authorName: author),
          numAudioFiles: 1,
        ),
      ),
      libraryFiles: null,
    );
  }),
);

@Preview(name: 'Library grid / light', size: Size(1280, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Library grid / dark', size: Size(1280, 720), wrapper: yaabsaPreviewDark)
@Preview(name: 'Library grid / AMOLED', size: Size(1280, 720), wrapper: yaabsaPreviewAmoled)
Widget libraryGridPreview() => const LibraryGridLabPreview();

class LibraryGridLabPreview extends StatefulWidget {
  const LibraryGridLabPreview({super.key});

  @override
  State<LibraryGridLabPreview> createState() => _LibraryGridLabPreviewState();
}

class _LibraryGridLabPreviewState extends State<LibraryGridLabPreview> {
  final ScrollController _scrollController = ScrollController();
  final ABSApi _api = ABSApi(
    dio: Dio(BaseOptions(baseUrl: 'https://yaabsa-ui-lab.example.test')),
    interceptors: [],
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        itemDownloadStatusesProvider.overrideWith((ref) => const Stream.empty()),
        downloadAvailabilityProvider.overrideWith((ref) => const Stream.empty()),
        globalSettingByKeyProvider(SettingKeys.libraryGridScale).overrideWith((ref) => const Stream.empty()),
        for (final item in libraryGridPreviewItems) mediaProgressByKeyProvider(item.id).overrideWithValue(null),
      ],
      child: LibraryItemsGrid(
        key: const ValueKey('library-grid-lab.grid'),
        scrollController: _scrollController,
        playbackStateHandler: const _LibraryGridPreviewAudioHandler(),
        items: libraryGridPreviewItems,
        totalItems: libraryGridPreviewItems.length,
        hasNextPage: false,
        api: _api,
        onEnsureLoadedForIndex: (_) {},
        onOpenItem: (_, _) {},
        onPlayItem: (_, _) {},
      ),
    );
  }
}

class _LibraryGridPreviewAudioHandler implements BGAudioHandler {
  const _LibraryGridPreviewAudioHandler();

  static const Stream<PlayerState> _playerStateChanges = Stream<PlayerState>.empty();
  static const Stream<bool> _queueTransitions = Stream<bool>.empty();

  @override
  InternalMedia? get currentMediaItem => null;

  @override
  Stream<PlayerState> get playerControlStateStream => _playerStateChanges;

  @override
  PlayerState get playerControlState => PlayerState(false, ProcessingState.idle);

  @override
  Stream<bool> get queueTransitionLoadingStream => _queueTransitions;

  @override
  bool get queueTransitionLoading => false;

  @override
  bool isQueueTransitionForItem(String itemId, {String? episodeId}) => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
