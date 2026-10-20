import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:background_downloader/background_downloader.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/file_formats.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/reader/reader_speech_playback.dart';
import 'package:yaabsa/models/epub_narration_clip.dart';
import 'package:just_audio/just_audio.dart' show PlayerState, ProcessingState;
import 'package:dio/dio.dart';
import 'package:foliate_reader/foliate_reader.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_annotation.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/screens/player/play_bar.dart';
import 'package:yaabsa/screens/reader/models/pdf_annotation_entry.dart';
import 'package:yaabsa/screens/reader/widgets/reader_epub_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_epub_annotation_sheet.dart';
import 'package:yaabsa/screens/reader/widgets/reader_settings_sheet.dart';
import 'package:yaabsa/screens/reader/widgets/reader_pdf_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_progress_controls.dart';
import 'package:yaabsa/screens/reader/widgets/reader_search_sheet.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/util/server_version.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'reader_annotation_actions.dart';
part 'reader_annotation_sync.dart';
part 'reader_builders.dart';
part 'reader_chrome.dart';
part 'reader_navigation.dart';
part 'reader_core_helpers.dart';
part 'reader_pdf_helpers.dart';
part 'reader_speech.dart';
part 'reader_narration.dart';
part 'reader_surface.dart';
part 'reader_session.dart';
part 'reader_appearance.dart';
part 'reader_file_helpers.dart';

const Duration _kSnackBarDuration = Duration(seconds: 2);

enum _ReaderRenderMode { epub, pdf }

class Reader extends ConsumerStatefulWidget {
  const Reader({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<Reader> createState() => _ReaderState();
}

class _ReaderState extends ConsumerState<Reader> with WidgetsBindingObserver {
  final FoliateViewerController epubController = FoliateViewerController();
  final PdfViewerController _pdfController = PdfViewerController();

  List<FoliateAnnotation> _epubAnnotations = <FoliateAnnotation>[];

  int? _lastSyncedPdfPageNumber;
  List<PdfAnnotationEntry> _pdfAnnotations = const <PdfAnnotationEntry>[];
  List<InternalAnnotation> _pdfBookmarks = [];
  String? _hoveredPdfAnnotationCfi;

  final Color _lastHighlightColor = Colors.yellow;
  final Color _lastUnderlineColor = Colors.blue;
  final double _lastUnderlineThickness = 2.0;

  String? _resolvedEbookLocation;
  InternalDownload? _storedDownload;
  File? _localEbookFile;
  bool _loadingLocalFile = true;
  File? _tempEbookFile;
  int _progressRefreshToken = 0;
  Timer? _annotationsSyncDebounce;
  bool _autoAnnotationLoadStarted = false;
  bool _isApplyingRemoteAnnotations = false;
  bool _annotationSyncInFlight = false;

  List<FoliateTOCItem>? _epubToc;
  List<FoliateTOCItem>? _epubPageList;
  List<PdfOutlineNode>? _pdfToc;
  bool _isSystemUiVisible = true;
  bool _isReaderPanelOpen = false;
  bool _isNavigationOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PdfTextSearcher? _pdfSearcher;
  PdfPageTextRange? _pdfSearchHighlight;
  Timer? _pdfSearchHighlightTimer;
  bool _isBookReady = false;

  FoliateLocation? _currentEpubLocation;
  int? _currentPdfPage;
  PdfDocument? _pdfDocument;

  Timer? _readingSessionTimer;
  DateTime? _lastReadingSessionSyncTime;
  PlaybackSessionBinding? _readingSessionBinding;
  int _readingSessionGeneration = 0;
  int? _openingReadingSessionGeneration;

  bool _isTtsPlaying = false;
  bool _isTtsPaused = false;
  bool _isStartingTts = false;
  int _ttsGeneration = 0;
  Future<void> _ttsTransition = Future<void>.value();
  StreamSubscription<ReaderSpeechPlaybackState?>? _speechStateSubscription;
  String? _lastSpeechCfi;
  String? _pendingSpeechCfi;
  String? _lastSpeechError;
  bool _isHighlightingSpeech = false;
  bool _isPreparingNarration = false;
  StreamSubscription<PlayerState>? _narrationStateSubscription;
  StreamSubscription<Duration>? _narrationPositionSubscription;
  StreamSubscription<InternalMedia?>? _narrationMediaSubscription;
  String? _lastNarrationTarget;
  String? _pendingNarrationTarget;
  bool _isHighlightingNarration = false;
  bool _hasMediaOverlays = false;
  String _mediaOverlayState = 'stopped';

  bool get _isMediaOverlayActive => _mediaOverlayState != 'stopped';
  bool get _isAudioPlaybackActive => _isTtsPlaying || _isMediaOverlayActive;
  bool get _isAudioPlaying => (_isTtsPlaying && !_isTtsPaused) || _mediaOverlayState == 'playing';

  late final SessionRepository _sessionRepository;
  double _currentAudioTime = 0.0;
  bool _canReachServer = true;
  bool _isDisposed = false;

  ABSApi? _api;
  String? _pendingSyncLocation;
  double? _pendingSyncProgress;
  DateTime? _lastProgressSyncTime;
  Timer? _progressSyncTimer;
  Future<void>? _progressSyncChain;
  String? _lastSyncedEpubCfi;

  String get _readerTheme =>
      ref.read(settingsManagerProvider.notifier).getGlobalSetting<String>(SettingKeys.readerTheme);
  double get _fontSizeMultiplier =>
      ref.read(settingsManagerProvider.notifier).getGlobalSetting<double>(SettingKeys.readerFontSizeMultiplier);
  double get _lineHeight =>
      ref.read(settingsManagerProvider.notifier).getGlobalSetting<double>(SettingKeys.readerLineHeight);
  String get _readerLayout =>
      ref.read(settingsManagerProvider.notifier).getGlobalSetting<String>(SettingKeys.readerLayout);

  String get _epubFlow => _readerLayout == 'scrolled' ? 'scrolled' : 'paginated';
  int get _epubMaxColumnCount => _readerLayout == 'paginated_2' && !context.isMobile ? 2 : 1;

  void _readerSetState(VoidCallback update) {
    if (_isDisposed || !mounted) {
      return;
    }

    setState(update);
  }

  Future<void> _sendProgressToServer({required String location, required double progress}) {
    final api = _api;

    if (api == null || location.trim().isEmpty) {
      return Future<void>.value();
    }

    final itemId = widget.itemId;
    final completer = Completer<void>();
    final newChain = (_progressSyncChain ?? Future<void>.value())
        .then((_) async {
          try {
            await api.getMeApi().updateBookProgress(itemId, epubCfi: location, progress: progress);
          } catch (e, s) {
            logger('Failed to sync progress for $itemId: $e\n$s', tag: 'ReaderProgressSync', level: InfoLevel.error);
          }
        })
        .whenComplete(() {
          completer.complete();
        });

    _progressSyncChain = newChain;

    return completer.future;
  }

  void _throttleProgressSync({required String location, required double progress}) {
    _pendingSyncLocation = location;
    _pendingSyncProgress = progress;

    final now = DateTime.now();
    final lastSync = _lastProgressSyncTime;

    if (lastSync == null || now.difference(lastSync) >= const Duration(seconds: 10)) {
      _flushPendingProgressSync();
    } else {
      if (_progressSyncTimer == null) {
        final remaining = const Duration(seconds: 10) - now.difference(lastSync);

        _progressSyncTimer = Timer(remaining, () {
          _flushPendingProgressSync();
        });
      }
    }
  }

  void _flushPendingProgressSync() {
    _progressSyncTimer?.cancel();
    _progressSyncTimer = null;

    final loc = _pendingSyncLocation;
    final prog = _pendingSyncProgress;

    if (loc != null && prog != null) {
      _pendingSyncLocation = null;
      _pendingSyncProgress = null;
      _lastProgressSyncTime = DateTime.now();
      unawaited(_sendProgressToServer(location: loc, progress: prog));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      if (!_isAudioPlaying) {
        unawaited(_pauseReadingSession());
      }
    } else {
      _resumeReadingSession();
    }
  }

  @override
  void initState() {
    super.initState();
    _sessionRepository = ref.read(sessionRepositoryProvider);
    _listenToNarration();
    _listenToSpeech();
    _api = ref.read(absApiProvider);
    WidgetsBinding.instance.addObserver(this);
    HardwareKeyboard.instance.addHandler(_handleVolumeKeys);
    unawaited(_refreshStoredProgress());
    unawaited(_loadStoredDownload());
  }

  @override
  void didUpdateWidget(covariant Reader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.itemId != widget.itemId) {
      _ttsGeneration++;
      _lastSpeechCfi = null;
      _pendingSpeechCfi = null;
      _lastNarrationTarget = null;
      unawaited(_closeReadingSession());
      unawaited(epubController.close());
      _pendingSyncLocation = null;
      _pendingSyncProgress = null;
      _lastProgressSyncTime = null;
      _progressSyncTimer?.cancel();
      _progressSyncTimer = null;
      _progressSyncChain = null;
      _pdfSearcher?.dispose();
      _pdfSearcher = null;
      _pdfSearchHighlightTimer?.cancel();
      _pdfSearchHighlight = null;
      _currentEpubLocation = null;
      _currentPdfPage = null;
      _pdfDocument = null;
      _epubToc = null;
      _epubPageList = null;
      _pdfToc = null;
      _epubAnnotations = [];
      _isSystemUiVisible = true;
      _resetPdfState();
      _lastSyncedEpubCfi = null;
      _isBookReady = false;
      _resolvedEbookLocation = null;
      _autoAnnotationLoadStarted = false;
      _isApplyingRemoteAnnotations = false;
      _annotationSyncInFlight = false;
      _annotationsSyncDebounce?.cancel();
      unawaited(_refreshStoredProgress());
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_narrationStateSubscription?.cancel());
    unawaited(_narrationPositionSubscription?.cancel());
    unawaited(_narrationMediaSubscription?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    HardwareKeyboard.instance.removeHandler(_handleVolumeKeys);
    unawaited(_closeReadingSession());
    unawaited(epubController.close());
    _ttsGeneration++;
    unawaited(_speechStateSubscription?.cancel());
    _annotationsSyncDebounce?.cancel();
    _pdfSearcher?.dispose();
    _pdfSearchHighlightTimer?.cancel();

    if (_tempEbookFile != null) {
      try {
        _tempEbookFile!.deleteSync();
      } catch (_) {}
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsManagerProvider);

    for (final key in [
      SettingKeys.readerTheme,
      SettingKeys.readerFontSizeMultiplier,
      SettingKeys.readerLineHeight,
      SettingKeys.readerFontFamily,
      SettingKeys.readerTextAlignment,
      SettingKeys.readerLetterSpacing,
      SettingKeys.readerPageMargin,
      SettingKeys.readerPageWidth,
    ]) {
      ref.listen(globalSettingByKeyProvider(key), (previous, next) {
        if (previous?.value != next.value) {
          _applyEpubStyles();
        }
      });
    }

    ref.listen(globalSettingByKeyProvider(SettingKeys.readerLayout), (previous, next) {
      if (previous?.value == next.value) {
        return;
      }

      unawaited(epubController.setFlow(_epubFlow));
      unawaited(epubController.setMaxColumnCount(_epubMaxColumnCount));
    });

    final currentProgress = ref.watch(mediaProgressByKeyProvider(widget.itemId));

    _currentAudioTime = currentProgress?.currentTime ?? 0.0;

    _canReachServer = ref.watch(serverReachabilityProvider);

    final hideMiniPlayerSetting = ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.readerHideMiniPlayer);

    final userAsync = ref.watch(currentUserProvider);
    final itemAsync = ref.watch(libraryItemProvider(widget.itemId));
    final effectiveInitialLocation = _resolvedEbookLocation ?? currentProgress?.ebookLocation;

    final bool isEpubMode = itemAsync.maybeWhen(
      data: (item) => _resolveReaderMode(item) == _ReaderRenderMode.epub,
      orElse: () => true,
    );

    return _buildReaderSurface(
      itemAsync: itemAsync,
      userAsync: userAsync,
      effectiveInitialLocation: effectiveInitialLocation,
      isEpubMode: isEpubMode,
      hideMiniPlayerSetting: hideMiniPlayerSetting,
    );
  }
}
