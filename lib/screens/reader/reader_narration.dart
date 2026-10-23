part of 'reader.dart';

extension _ReaderNarration on _ReaderState {
  void _listenToNarration() {
    void updateState() {
      if (!mounted || _isDisposed) {
        return;
      }

      if (audioHandler.currentMediaItem == null) {
        unawaited(_startReadingSession());
      } else if (_readingSessionBinding != null || _openingReadingSessionGeneration != null) {
        unawaited(_closeReadingSession());
      }

      final active = audioHandler.isReaderNarrationFor(widget.itemId);
      final state = active
          ? audioHandler.playerControlState.playing &&
                    audioHandler.playerControlState.processingState != ProcessingState.completed
                ? 'playing'
                : 'paused'
          : 'stopped';

      if (_mediaOverlayState != state) {
        _readerSetState(() => _mediaOverlayState = state);
      }

      if (!active) {
        _lastNarrationTarget = null;
        _pendingNarrationTarget = null;
        unawaited(epubController.highlightNarrationTarget(''));
      }
    }

    _narrationStateSubscription = audioHandler.playerControlStateStream.listen((_) => updateState());
    _narrationMediaSubscription = audioHandler.mediaItemStream.listen((_) => updateState());
    _narrationPositionSubscription = audioHandler.positionStream.listen((position) {
      if (!_isBookReady || !audioHandler.isReaderNarrationFor(widget.itemId)) {
        return;
      }

      final target = audioHandler.readerNarrationTarget(position);

      if (target == null || target == _lastNarrationTarget) {
        return;
      }

      _lastNarrationTarget = target;
      _pendingNarrationTarget = target;
      unawaited(_highlightNarration());
    });
    updateState();
  }

  Future<void> _highlightNarration() async {
    if (_isHighlightingNarration) {
      return;
    }

    _isHighlightingNarration = true;

    try {
      while (mounted && !_isDisposed && _pendingNarrationTarget != null) {
        final target = _pendingNarrationTarget!;

        _pendingNarrationTarget = null;

        if (!audioHandler.isReaderNarrationFor(widget.itemId)) {
          break;
        }

        await epubController.highlightNarrationTarget(target);

        if (!audioHandler.isReaderNarrationFor(widget.itemId)) {
          await epubController.highlightNarrationTarget('');
        }
      }
    } catch (error) {
      logger('Unable to follow narration: $error', tag: 'Reader', level: InfoLevel.warning);
    } finally {
      _isHighlightingNarration = false;
    }
  }

  Future<void> _startNarration() async {
    if (_isPreparingNarration) {
      return;
    }

    _stopTts();
    _readerSetState(() => _isPreparingNarration = true);

    final itemId = widget.itemId;

    try {
      await _ttsTransition;

      final clips = (await epubController.prepareMediaOverlay()).map(EpubNarrationClip.fromMap).toList();

      if (!mounted || _isDisposed || widget.itemId != itemId) {
        return;
      }

      final item = await ref.read(libraryItemProvider(itemId).future);

      if (!mounted || _isDisposed || widget.itemId != itemId) {
        return;
      }

      final chapterTitles = <int, String>{};

      void collectTitles(List<FoliateTOCItem> items) {
        for (final toc in items) {
          final href = toc.href?.split('#').first;
          final matchingIndex = clips.where((clip) => clip.target.split('#').first == href).firstOrNull?.sectionIndex;

          if (matchingIndex != null && toc.label != null) {
            chapterTitles.putIfAbsent(matchingIndex, () => toc.label!);
          }

          if (toc.subitems != null) {
            collectTitles(toc.subitems!);
          }
        }
      }

      collectTitles(_epubToc ?? []);
      await _closeReadingSession();

      if (!mounted || _isDisposed || widget.itemId != itemId) {
        return;
      }

      await audioHandler.playReaderNarration(
        item: item,
        clips: clips,
        chapterTitles: chapterTitles,
        cover: _api?.getLibraryItemApi().getCoverUri(item.id, item: item),
      );
    } catch (error) {
      if (mounted && !_isDisposed) {
        _showSnackBar('Unable to start narration: $error');
      }
    } finally {
      _readerSetState(() => _isPreparingNarration = false);
      unawaited(_startReadingSession());
    }
  }
}
