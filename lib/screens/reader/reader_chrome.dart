part of 'reader.dart';

extension _ReaderChrome on _ReaderState {
  ColorScheme get _readerColors {
    final brightness = _readerTheme == 'dark' || _readerTheme == 'grey' ? Brightness.dark : Brightness.light;
    final surface = switch (_readerTheme) {
      'light' => const Color(0xFFFFFEFA),
      'dark' => const Color(0xFF121212),
      'grey' => const Color(0xFF2E2E2E),
      _ => const Color(0xFFF4ECD8),
    };

    return ColorScheme.fromSeed(
      seedColor: Theme.of(context).colorScheme.primary,
      brightness: brightness,
      surface: surface,
    );
  }

  ThemeData get _readerThemeData {
    final colors = _readerColors;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: Theme.of(context).textTheme.apply(bodyColor: colors.onSurface, displayColor: colors.onSurface),
    );
  }

  void _toggleSystemUi() {
    _readerSetState(() {
      _isSystemUiVisible = !_isSystemUiVisible;
    });

    if (_isBookReady && _pdfDocument == null) {
      _applyEpubPageGeometry();
    }
  }

  bool _handleVolumeKeys(KeyEvent event) {
    if (event is! KeyDownEvent ||
        _isReaderPanelOpen ||
        _isNavigationOpen ||
        ModalRoute.of(context)?.isCurrent == false) {
      return false;
    }

    final keyboard = HardwareKeyboard.instance;
    final isEpub = _pdfDocument == null;

    if ((keyboard.isControlPressed || keyboard.isMetaPressed) && event.logicalKey == LogicalKeyboardKey.keyF) {
      if (_isBookReady) {
        unawaited(_showReaderSearch(isEpubMode: isEpub));
      }

      return true;
    }

    if (!_isBookReady ||
        keyboard.isAltPressed ||
        keyboard.isShiftPressed ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed) {
      return false;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _toggleSystemUi();
      return true;
    }

    final key = event.logicalKey;
    final volumeForward = key == LogicalKeyboardKey.audioVolumeUp;
    final volumeBackward = key == LogicalKeyboardKey.audioVolumeDown;

    if (_isAudioPlaybackActive && (volumeForward || volumeBackward)) {
      return false;
    }

    if (volumeForward || key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.pageDown) {
      unawaited(_turnReaderPage(forward: true, isEpubMode: isEpub));
      return true;
    }

    if (volumeBackward || key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.pageUp) {
      unawaited(_turnReaderPage(forward: false, isEpubMode: isEpub));
      return true;
    }

    return false;
  }

  Future<void> _turnReaderPage({required bool forward, required bool isEpubMode}) async {
    if (!_isBookReady) {
      return;
    }

    if (isEpubMode) {
      if (forward) {
        await epubController.next();
      } else {
        await epubController.prev();
      }

      return;
    }

    if (!_pdfController.isReady) {
      return;
    }

    final page = (_pdfController.pageNumber ?? 1) + (forward ? 1 : -1);

    if (page >= 1 && page <= _pdfController.pageCount) {
      await _pdfController.goToPage(pageNumber: page);
    }
  }

  Widget _buildTopBar({required bool isEpubMode, required String title}) {
    final colors = _readerColors;
    final visible = _isSystemUiVisible || !_isBookReady;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, -1),
          duration: const Duration(milliseconds: 220),
          child: Material(
            color: colors.surfaceContainerLow,
            elevation: 1,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Close book',
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _readerThemeData.textTheme.titleSmall,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Search in book',
                      icon: const Icon(Icons.search_rounded),
                      onPressed: _isBookReady ? () => unawaited(_showReaderSearch(isEpubMode: isEpubMode)) : null,
                    ),
                    IconButton(
                      tooltip: 'Reading preferences',
                      icon: const Icon(Icons.text_fields_rounded),
                      onPressed: () => unawaited(_showReaderSettingsSheet(isEpubMode: isEpubMode)),
                    ),
                    PopupMenuButton<String>(
                      tooltip: 'More reading options',
                      icon: const Icon(Icons.more_vert_rounded),
                      enabled: _isBookReady,
                      onOpened: () => _isReaderPanelOpen = true,
                      onCanceled: () => _isReaderPanelOpen = false,
                      onSelected: (value) {
                        _isReaderPanelOpen = false;

                        if (value == 'bookmark') {
                          unawaited(_toggleReaderBookmark(isEpubMode: isEpubMode));
                        } else if (value == 'speech') {
                          if (_isTtsPlaying) {
                            _stopTts();
                          } else {
                            unawaited(_startTts());
                          }
                        } else if (value == 'narration') {
                          if (_isMediaOverlayActive) {
                            unawaited(audioHandler.stop());
                          } else {
                            if (_isTtsPlaying) {
                              _stopTts();
                            }

                            unawaited(_startNarration());
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'bookmark',
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              _isReaderLocationBookmarked(isEpubMode: isEpubMode)
                                  ? Icons.bookmark_remove_outlined
                                  : Icons.bookmark_add_outlined,
                            ),
                            title: Text(
                              _isReaderLocationBookmarked(isEpubMode: isEpubMode)
                                  ? 'Remove bookmark'
                                  : 'Bookmark this page',
                            ),
                          ),
                        ),
                        if (isEpubMode)
                          PopupMenuItem(
                            value: 'speech',
                            enabled: !_isStartingTts,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(_isTtsPlaying ? Icons.stop_circle_outlined : Icons.volume_up_outlined),
                              title: Text(_isTtsPlaying ? 'Stop reading aloud' : 'Read aloud'),
                            ),
                          ),
                        if (_hasMediaOverlays)
                          PopupMenuItem(
                            value: 'narration',
                            enabled: !_isPreparingNarration,
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.headphones_rounded),
                              title: Text(_isMediaOverlayActive ? 'Stop narration' : 'Play book narration'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showReaderSettingsSheet({required bool isEpubMode}) async {
    _isReaderPanelOpen = true;

    try {
      await showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: const BoxConstraints(maxWidth: 720),
        backgroundColor: _readerColors.surfaceContainerLow,
        builder: (context) => Theme(
          data: _readerThemeData,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: ReaderSettingsSheet(isEpub: isEpubMode),
          ),
        ),
      );
    } finally {
      _isReaderPanelOpen = false;
    }
  }

  Future<void> _showReaderSearch({required bool isEpubMode}) async {
    if (_isReaderPanelOpen || !_isBookReady) {
      return;
    }

    _isReaderPanelOpen = true;
    final itemId = widget.itemId;
    ReaderSearchSelection? selection;

    try {
      selection = await showModalBottomSheet<ReaderSearchSelection>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: const BoxConstraints(maxWidth: 720),
        backgroundColor: _readerColors.surfaceContainerLow,
        builder: (context) => Theme(
          data: _readerThemeData,
          child: ReaderSearchSheet(
            epubController: isEpubMode ? epubController : null,
            pdfSearcher: isEpubMode ? null : _pdfSearcher,
          ),
        ),
      );
    } finally {
      _isReaderPanelOpen = false;

      if (mounted && !_isDisposed && widget.itemId == itemId) {
        if (isEpubMode) {
          await epubController.clearSearch();
        } else {
          _pdfSearcher?.resetTextSearch();
        }
      }
    }

    if (!mounted || _isDisposed || widget.itemId != itemId || selection == null) {
      return;
    }

    final cfi = selection.epubCfi;
    final pdfMatch = selection.pdfMatch;
    if (cfi != null) {
      await epubController.highlightSearchResult(cfi);
    } else if (pdfMatch != null) {
      _pdfSearchHighlightTimer?.cancel();
      _readerSetState(() {
        _pdfSearchHighlight = pdfMatch;
      });
      _pdfController.invalidate();

      _pdfSearchHighlightTimer = Timer(const Duration(seconds: 3), () {
        _readerSetState(() {
          _pdfSearchHighlight = null;
        });
        _pdfController.invalidate();
      });
    }
  }

  Widget _buildProgressControls({required bool isEpubMode, required bool showMiniPlayer}) {
    final location = _currentEpubLocation;
    final total = _pdfController.isReady ? _pdfController.pageCount : 0;
    final page = _currentPdfPage ?? 1;
    final fraction = isEpubMode ? (location?.fraction ?? 0) : (total > 1 ? (page - 1) / (total - 1) : 0.0);
    String progress = '${(fraction * 100).round()}%';

    if (!isEpubMode && total > 0) {
      progress = 'Page $page of $total';
    } else if (location?.pageItem?.label?.isNotEmpty == true) {
      final pageCount = _epubPageList?.length ?? 0;
      final pageLabel = location!.pageItem!.label;
      progress = pageCount > 0 ? 'Page $pageLabel of $pageCount · $progress' : 'Page $pageLabel · $progress';
    } else if (location?.location != null) {
      final current = location!.location!['current'] as num? ?? 0;
      final count = location.location!['total'] as num? ?? 0;

      if (count > 0) {
        final position = (current.toInt() + 1).clamp(1, count.toInt());
        progress = 'Location $position of ${count.toInt()} · $progress';
      }
    }

    return ReaderProgressControls(
      visible: _isSystemUiVisible,
      ready: _isBookReady,
      includeBottomSafeArea: !showMiniPlayer,
      progress: progress,
      chapter: isEpubMode ? (location?.tocItem?.label ?? 'Reading') : 'Reading',
      fraction: fraction.clamp(0.0, 1.0),
      canGoPrevious: _isBookReady && (isEpubMode ? fraction > 0 : page > 1),
      canGoNext: _isBookReady && (isEpubMode ? fraction < 1 : page < total),
      onPrevious: () => unawaited(_turnReaderPage(forward: false, isEpubMode: isEpubMode)),
      onNext: () => unawaited(_turnReaderPage(forward: true, isEpubMode: isEpubMode)),
      onContents: () => _scaffoldKey.currentState?.openDrawer(),
      onToggleControls: _toggleSystemUi,
      onSeek: (value) {
        if (isEpubMode) {
          unawaited(epubController.goToFraction(value));
        } else if (total > 0) {
          unawaited(_pdfController.goToPage(pageNumber: (value * (total - 1)).round() + 1));
        }
      },
    );
  }
}
