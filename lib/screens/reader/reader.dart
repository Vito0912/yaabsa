import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:foliate_reader/foliate_reader.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_annotation.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/screens/player/play_bar.dart';
import 'package:yaabsa/screens/reader/models/pdf_annotation_entry.dart';
import 'package:yaabsa/screens/reader/widgets/reader_epub_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_pdf_view.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'reader_annotation_actions.dart';
part 'reader_annotation_sync.dart';
part 'reader_builders.dart';
part 'reader_core_helpers.dart';
part 'reader_pdf_helpers.dart';

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
  String? _hoveredPdfAnnotationCfi;

  final Color _lastHighlightColor = Colors.yellow;
  final Color _lastUnderlineColor = Colors.blue;
  final double _lastUnderlineThickness = 2.0;

  String? _resolvedEbookLocation;
  int _progressRefreshToken = 0;
  Timer? _annotationsSyncDebounce;
  bool _autoAnnotationLoadStarted = false;
  bool _isApplyingRemoteAnnotations = false;
  bool _annotationSyncInFlight = false;

  List<FoliateTOCItem>? _epubToc;
  List<FoliateTOCItem>? _epubPageList;
  List<PdfOutlineNode>? _pdfToc;
  bool _isSystemUiVisible = false;

  FoliateLocation? _currentEpubLocation;
  int? _currentPdfPage;
  PdfDocument? _pdfDocument;

  Timer? _readingSessionTimer;
  DateTime? _lastReadingSessionSyncTime;
  bool _sessionIsOpened = false;

  FlutterTts? _flutterTts;
  bool _isTtsPlaying = false;
  bool _isTtsPaused = false;
  List<Map<String, String>> _ttsSentences = const [];
  int _currentTtsSentenceIndex = 0;
  bool _waitingForTtsPageLoad = false;
  bool _isJumpingTts = false;
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
  int get _epubMaxColumnCount => _readerLayout == 'paginated_2' ? 2 : 1;

  String get _currentEpubStyles {
    final themeBg = switch (_readerTheme) {
      'light' => '#ffffff',
      'sepia' => '#f4ecd8',
      'dark' => '#000000',
      'grey' => '#2e2e2e',
      _ => '#f4ecd8',
    };
    final themeColor = switch (_readerTheme) {
      'light' => '#000000',
      'sepia' => '#5b4636',
      'dark' => '#e0e0e0',
      'grey' => '#ffffff',
      _ => '#5b4636',
    };

    return '''
      :root {
        --bg-color: $themeBg;
        --color: $themeColor;
      }
      body {
        background-color: $themeBg !important;
        color: $themeColor !important;
        font-size: ${(_fontSizeMultiplier * 100).toInt()}% !important;
        line-height: $_lineHeight !important;
      }
      p, span, div, h1, h2, h3, h4, h5, h6, a {
        color: $themeColor !important;
      }
    ''';
  }

  void _readerSetState(VoidCallback update) {
    if (_isDisposed || !mounted) {
      return;
    }

    setState(update);
  }

  void _toggleSystemUi() {
    _readerSetState(() {
      _isSystemUiVisible = !_isSystemUiVisible;
    });
  }

  bool _handleVolumeKeys(KeyEvent event) {
    if (_isAudioPlaybackActive) {
      return false;
    }
    if (event is KeyDownEvent) {
      final isEpub = _pdfDocument == null;
      if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (isEpub) {
          epubController.next();
        } else {
          final currentPage = _pdfController.pageNumber;
          final pageCount = _pdfController.pageCount;
          if (currentPage != null && pageCount > 0 && currentPage < pageCount) {
            _pdfController.goToPage(pageNumber: currentPage + 1);
          }
        }
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.audioVolumeDown ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (isEpub) {
          epubController.prev();
        } else {
          final currentPage = _pdfController.pageNumber;
          if (currentPage != null && currentPage > 1) {
            _pdfController.goToPage(pageNumber: currentPage - 1);
          }
        }
        return true;
      }
    }
    return false;
  }

  Future<void> _startReadingSession() async {
    if (_sessionIsOpened) return;
    final settings = ref.read(settingsManagerProvider.notifier);
    final enabled = settings.getGlobalSetting<bool>(SettingKeys.readerStartSession);
    if (!enabled) return;

    try {
      final media = await _sessionRepository.openSession(widget.itemId, forceDirectPlay: true);
      if (media != null) {
        _sessionIsOpened = true;
        _lastReadingSessionSyncTime = DateTime.now();
        _readingSessionTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
          _syncReadingSession();
        });
      }
    } catch (e, s) {
      logger('Failed to open reading session: $e\n$s', tag: 'ReadingSession', level: InfoLevel.error);
    }
  }

  Future<void> _syncReadingSession({bool force = false}) async {
    if (!force && (!_sessionIsOpened || _lastReadingSessionSyncTime == null)) return;
    if (force && _lastReadingSessionSyncTime == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(_lastReadingSessionSyncTime!).inSeconds.toDouble();
    _lastReadingSessionSyncTime = now;

    final currentAudioTime = _currentAudioTime;
    final canReach = _canReachServer;

    try {
      await _sessionRepository.syncOpenSession(currentAudioTime, elapsed, canReachServer: canReach);
    } catch (e, s) {
      logger('Failed to sync reading session: $e\n$s', tag: 'ReadingSession', level: InfoLevel.error);
    }
  }

  Future<void> _closeReadingSession() async {
    _readingSessionTimer?.cancel();
    _readingSessionTimer = null;

    _flushPendingProgressSync();
    if (_progressSyncChain != null) {
      try {
        await _progressSyncChain;
      } catch (_) {}
    }

    if (_sessionIsOpened) {
      _sessionIsOpened = false;
      await _syncReadingSession(force: true);
      try {
        await _sessionRepository.closeSession();
      } catch (e, s) {
        logger('Failed to close reading session: $e\n$s', tag: 'ReadingSession', level: InfoLevel.error);
      }
    }
  }

  Future<void> _pauseReadingSession() async {
    _readingSessionTimer?.cancel();
    _readingSessionTimer = null;
    _flushPendingProgressSync();
    if (_progressSyncChain != null) {
      try {
        await _progressSyncChain;
      } catch (_) {}
    }
    await _syncReadingSession(force: true);
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

  void _resumeReadingSession() {
    if (!_sessionIsOpened || _readingSessionTimer != null) return;
    _lastReadingSessionSyncTime = DateTime.now();
    _readingSessionTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _syncReadingSession();
    });
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

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts!.setLanguage("en-US");
    await _flutterTts!.setSpeechRate(0.5);
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setPitch(1.0);

    _flutterTts!.setCompletionHandler(() {
      _onTtsSentenceComplete();
    });

    _flutterTts!.setErrorHandler((msg) {
      _stopTts();
    });
  }

  void _stopTts() {
    if (_flutterTts != null) {
      _flutterTts!.stop();
    }
    unawaited(epubController.clearTtsHighlight());
    _readerSetState(() {
      _isTtsPlaying = false;
      _isTtsPaused = false;
      _ttsSentences = const [];
      _currentTtsSentenceIndex = 0;
      _waitingForTtsPageLoad = false;
    });
  }

  void _pauseTts() {
    if (_flutterTts != null) {
      _flutterTts!.pause();
    }
    _readerSetState(() {
      _isTtsPaused = true;
    });
  }

  void _resumeTts() {
    if (_flutterTts != null && _ttsSentences.isNotEmpty && _currentTtsSentenceIndex < _ttsSentences.length) {
      final sentence = _ttsSentences[_currentTtsSentenceIndex];
      final text = sentence['text'] ?? '';
      final cfi = sentence['cfi'] ?? '';
      if (cfi.isNotEmpty) {
        unawaited(epubController.highlightCFI(cfi));
      }
      _flutterTts!.speak(text);
      _readerSetState(() {
        _isTtsPaused = false;
      });
    }
  }

  Future<void> _startTts() async {
    if (_mediaOverlayState != 'stopped') {
      unawaited(epubController.stopMediaOverlay());
    }

    if (_flutterTts == null) {
      await _initTts();
    }

    final sentences = await epubController.getTtsSentences();
    if (sentences.isEmpty) {
      _showSnackBar('No readable text found');
      return;
    }

    _readerSetState(() {
      _ttsSentences = sentences;
      _currentTtsSentenceIndex = 0;
      _isTtsPlaying = true;
      _isTtsPaused = false;
    });

    final sentence = _ttsSentences[0];
    final text = sentence['text'] ?? '';
    final cfi = sentence['cfi'] ?? '';
    if (cfi.isNotEmpty) {
      unawaited(epubController.highlightCFI(cfi));
    }
    await _flutterTts!.speak(text);
  }

  void _onTtsSentenceComplete() {
    if (!mounted || !_isTtsPlaying || _isTtsPaused || _isJumpingTts) {
      return;
    }

    _readerSetState(() {
      _currentTtsSentenceIndex++;
    });

    if (_currentTtsSentenceIndex < _ttsSentences.length) {
      final sentence = _ttsSentences[_currentTtsSentenceIndex];
      final text = sentence['text'] ?? '';
      final cfi = sentence['cfi'] ?? '';
      if (cfi.isNotEmpty) {
        unawaited(epubController.highlightCFI(cfi));
      }
      _flutterTts!.speak(text);
    } else {
      unawaited(epubController.clearTtsHighlight());
      _turnPageForTts();
    }
  }

  void _jumpToTtsSentence(int index) {
    if (!mounted || !_isTtsPlaying) return;
    if (index >= 0 && index < _ttsSentences.length) {
      _isJumpingTts = true;
      _flutterTts?.stop();
      _readerSetState(() {
        _currentTtsSentenceIndex = index;
        _isTtsPaused = false;
      });
      final sentence = _ttsSentences[index];
      final text = sentence['text'] ?? '';
      final cfi = sentence['cfi'] ?? '';
      if (cfi.isNotEmpty) {
        unawaited(epubController.highlightCFI(cfi));
      }
      _isJumpingTts = false;
      _flutterTts?.speak(text);
    }
  }

  void _turnPageForTts() {
    _waitingForTtsPageLoad = true;
    epubController.next();
  }

  @override
  void initState() {
    super.initState();
    _sessionRepository = ref.read(sessionRepositoryProvider);
    _api = ref.read(absApiProvider);
    WidgetsBinding.instance.addObserver(this);
    HardwareKeyboard.instance.addHandler(_handleVolumeKeys);
    unawaited(_refreshStoredProgress());
  }

  @override
  void didUpdateWidget(covariant Reader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId != widget.itemId) {
      unawaited(_closeReadingSession());
      unawaited(epubController.close());
      _pendingSyncLocation = null;
      _pendingSyncProgress = null;
      _lastProgressSyncTime = null;
      _progressSyncTimer?.cancel();
      _progressSyncTimer = null;
      _progressSyncChain = null;
      _resetPdfState();
      _lastSyncedEpubCfi = null;
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
    WidgetsBinding.instance.removeObserver(this);
    HardwareKeyboard.instance.removeHandler(_handleVolumeKeys);
    unawaited(_closeReadingSession());
    unawaited(epubController.close());
    _stopTts();
    _annotationsSyncDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsManagerProvider);

    ref.listen(settingsManagerProvider, (previous, next) {
      if (mounted) {
        _applyEpubStyles();
      }
    });

    final currentProgress = ref.watch(
      mediaProgressProvider.select((asyncValue) {
        return asyncValue.value?[widget.itemId];
      }),
    );
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

    final scaffoldBg = switch (_readerTheme) {
      'light' => Colors.white,
      'sepia' => const Color(0xFFF4ECD8),
      'dark' => const Color(0xFF121212),
      'grey' => const Color(0xFF2E2E2E),
      _ => null,
    };

    return Scaffold(
      backgroundColor: scaffoldBg,
      drawer: _buildDrawer(isEpubMode: isEpubMode),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: itemAsync.when(
                      data: (item) {
                        return userAsync.when(
                          data: (user) {
                            if (user == null) {
                              return const Center(child: Text('No authenticated user available.'));
                            }

                            final authToken = user.preferredAuthToken;
                            if (authToken == null || authToken.isEmpty) {
                              return const Center(child: Text('Missing authentication token for ebook loading.'));
                            }

                            final mode = _resolveReaderMode(item);
                            if (mode == _ReaderRenderMode.pdf) {
                              return _buildPdfReaderBody(
                                user: user,
                                authToken: authToken,
                                initialLocation: effectiveInitialLocation,
                              );
                            }

                            final format = _normalizeEbookFormat(
                              item.media?.bookMedia?.ebookFile?.ebookFormat ??
                                  item.media?.bookMedia?.ebookFormat ??
                                  item.media?.bookMedia?.ebookFile?.metadata.ext,
                            );
                            final bookExtension = format.isNotEmpty ? format : 'epub';

                            return _buildEpubReaderBody(
                              user: user,
                              authToken: authToken,
                              initialCfi: effectiveInitialLocation,
                              bookExtension: bookExtension,
                            );
                          },
                          error: (error, stackTrace) {
                            return Center(child: Text('Failed to load user profile: $error'));
                          },
                          loading: () {
                            return const Center(child: CircularProgressIndicator());
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return Center(child: Text('Failed to load ebook metadata: $error'));
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  _buildTopBar(isEpubMode: isEpubMode),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(child: _buildBottomProgressIndicator(isEpubMode: isEpubMode)),
                  ),
                  Positioned(left: 0, right: 0, bottom: 80, child: Center(child: _buildTtsControlPanel())),
                  Positioned(left: 0, right: 0, bottom: 80, child: Center(child: _buildMediaOverlayControlPanel())),
                ],
              ),
            ),
            if (!hideMiniPlayerSetting) const PlayBar(includeBottomSafeArea: true, attachedToBottom: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomProgressIndicator({required bool isEpubMode}) {
    final theme = Theme.of(context);
    final textColor = switch (_readerTheme) {
      'light' => Colors.black.withAlpha(180),
      'sepia' => const Color(0xFF5B4636).withAlpha(180),
      'grey' => Colors.white.withAlpha(180),
      'dark' => const Color(0xFFE0E0E0).withAlpha(180),
      _ => theme.colorScheme.onSurface.withAlpha(180),
    };
    final textStyle = theme.textTheme.bodySmall?.copyWith(color: textColor);

    String progressText = '';
    if (isEpubMode) {
      if (_currentEpubLocation != null) {
        final pct = (_currentEpubLocation!.fraction * 100).toStringAsFixed(1);
        final pageList = _epubPageList;
        if (pageList != null && pageList.isNotEmpty) {
          final pageIndex = pageList.indexWhere((item) => item.href == _currentEpubLocation!.pageItem?.href);
          final pageLabel = _currentEpubLocation!.pageItem?.label;
          final total = pageList.length;
          if (pageIndex != -1) {
            progressText = 'Page ${pageIndex + 1} of $total • $pct%';
          } else if (pageLabel != null && pageLabel.isNotEmpty) {
            progressText = 'Page $pageLabel of $total • $pct%';
          } else {
            progressText = '$pct%';
          }
        } else {
          final loc = _currentEpubLocation!.location;
          if (loc != null) {
            final current = loc['current'] as int? ?? 0;
            final total = loc['total'] as int? ?? 0;
            if (total > 0) {
              progressText = 'Page $current of $total • $pct%';
            } else {
              progressText = '$pct%';
            }
          } else {
            progressText = '$pct%';
          }
        }
      }
    } else {
      final page = _currentPdfPage ?? 1;
      final total = _pdfController.isReady ? _pdfController.pageCount : 0;
      if (total > 0) {
        final pct = ((page / total) * 100).toStringAsFixed(0);
        progressText = 'Page $page of $total • $pct%';
      }
    }

    if (progressText.isEmpty) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.center,
        child: Text(progressText, style: textStyle),
      ),
    );
  }

  Widget _buildTtsControlPanel() {
    if (!_isTtsPlaying) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.stop), onPressed: _stopTts, tooltip: 'Stop TTS'),
            IconButton(
              icon: Icon(_isTtsPaused ? Icons.play_arrow : Icons.pause),
              onPressed: _isTtsPaused ? _resumeTts : _pauseTts,
              tooltip: _isTtsPaused ? 'Resume' : 'Pause',
            ),
          ],
        ),
      ),
    );
  }
}
