part of 'reader.dart';

extension _ReaderSpeech on _ReaderState {
  void _listenToSpeech() {
    _speechStateSubscription = audioHandler.readerSpeechStateStream.listen((state) {
      if (!mounted || _isDisposed) {
        return;
      }

      final active = audioHandler.isReaderSpeechFor(widget.itemId);
      final paused = active && state?.playerState.playing != true;

      if (_isTtsPlaying != active || _isTtsPaused != paused) {
        _readerSetState(() {
          _isTtsPlaying = active;
          _isTtsPaused = paused;
        });
      }

      if (active && state != null) {
        if (state.error != null && state.error != _lastSpeechError) {
          _showSnackBar('Speech stopped: ${state.error}');
        }

        _lastSpeechError = state.error;
        _followReaderSpeech();
      } else {
        _lastSpeechCfi = null;
        _pendingSpeechCfi = null;
        _lastSpeechError = null;

        if (_isBookReady) {
          unawaited(epubController.setSpeechActive(false));
          unawaited(epubController.clearTtsHighlight());
        }
      }
    });
  }

  void _followReaderSpeech() {
    if (!_isBookReady || !audioHandler.isReaderSpeechFor(widget.itemId)) {
      return;
    }

    final cfi = audioHandler.readerSpeechCfi;

    if (cfi == null || cfi.isEmpty || cfi == _lastSpeechCfi) {
      return;
    }

    _lastSpeechCfi = cfi;
    _pendingSpeechCfi = cfi;
    unawaited(_highlightReaderSpeech());
  }

  Future<void> _highlightReaderSpeech() async {
    if (_isHighlightingSpeech) {
      return;
    }

    _isHighlightingSpeech = true;

    try {
      while (mounted && !_isDisposed && _pendingSpeechCfi != null) {
        final cfi = _pendingSpeechCfi!;

        _pendingSpeechCfi = null;

        if (!audioHandler.isReaderSpeechFor(widget.itemId)) {
          break;
        }

        await epubController.goTo(cfi);

        if (!mounted || _isDisposed || !audioHandler.isReaderSpeechFor(widget.itemId)) {
          break;
        }

        await epubController.setSpeechActive(true);
        await epubController.highlightCFI(cfi);
      }
    } catch (error) {
      logger('Unable to follow read aloud: $error', tag: 'Reader', level: InfoLevel.warning);
    } finally {
      _isHighlightingSpeech = false;
    }
  }

  void _stopTts() {
    _ttsGeneration++;

    if (audioHandler.isReaderSpeechFor(widget.itemId)) {
      _ttsTransition = audioHandler.stop();
    }

    _readerSetState(() => _isStartingTts = false);
  }

  Future<void> _startTts() async {
    if (_isStartingTts) {
      return;
    }

    final generation = ++_ttsGeneration;

    _readerSetState(() => _isStartingTts = true);

    final itemId = widget.itemId;

    try {
      final sentences = await epubController.prepareSpeech();

      if (!mounted || _isDisposed || generation != _ttsGeneration) {
        return;
      }

      if (sentences.isEmpty) {
        _showSnackBar('No readable text found');
        return;
      }

      final item = await ref.read(libraryItemProvider(itemId).future);

      if (!mounted || _isDisposed || generation != _ttsGeneration) {
        return;
      }

      await _closeReadingSession();

      if (!mounted || _isDisposed || generation != _ttsGeneration) {
        return;
      }

      await audioHandler.playReaderSpeech(
        item: item,
        sentences: sentences,
        cover: _api?.getLibraryItemApi().getCoverUri(item.id, item: item),
      );
    } catch (error) {
      if (mounted && !_isDisposed && generation == _ttsGeneration) {
        _showSnackBar('Unable to start speech: $error');
      }
    } finally {
      if (generation == _ttsGeneration) {
        _readerSetState(() => _isStartingTts = false);
        unawaited(_startReadingSession());
      }
    }
  }

  void _jumpToTtsSentence(String cfi) {
    if (!audioHandler.isReaderSpeechFor(widget.itemId)) {
      return;
    }

    unawaited(audioHandler.seekReaderSpeechCfi(cfi));
  }
}
