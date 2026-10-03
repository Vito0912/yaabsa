part of 'reader.dart';

extension _ReaderMediaOverlay on _ReaderState {
  Future<void> _startMediaOverlayNarration() async {
    if (_isTtsPlaying) {
      _stopTts();
    }

    final controller = await _ensureMediaOverlayController();
    if (controller == null) {
      _showSnackBar('Unable to load narration audio for this book');
      return;
    }

    final fallbackSection = _currentEpubLocation?.sectionIndex ?? 0;

    final completer = Completer<(int, String)?>();
    _mediaOverlayStartTargetCompleter = completer;
    unawaited(epubController.requestMediaOverlayStartTarget());
    final target = await completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () => null,
    );
    if (identical(_mediaOverlayStartTargetCompleter, completer)) {
      _mediaOverlayStartTargetCompleter = null;
    }

    final bool started;
    if (target != null) {
      final (sectionIndex, textHref) = target;
      started = await controller.seekToTextHref(sectionIndex, textHref);
    } else {
      started = await controller.playSection(fallbackSection);
    }

    if (!mounted) return;
    if (!started) {
      _showSnackBar('No narration available from this point');
      return;
    }
    _onMediaOverlayPlaybackStarted();
  }

  Future<void> _stopMediaOverlayNarration() async {
    PlayerUtils.disableReadingWakelock();
    _mediaOverlayStoppedAt = DateTime.now();
    await _mediaOverlayPlaybackController?.stop();
    unawaited(epubController.setMediaOverlayUiActive(false));
    unawaited(_stopListeningForMediaOverlayHighlight());
  }

  void _jumpMediaOverlayToHref(String href) {
    final controller = _mediaOverlayPlaybackController;
    if (controller == null) return;
    final sectionIndex = controller.engine.sectionIndexForHref(href);
    if (sectionIndex == null) return;
    unawaited(
      controller.playSection(sectionIndex).then((started) {
        if (!mounted || !started) return;
        _onMediaOverlayPlaybackStarted();
      }),
    );
  }

  void _onMediaOverlaySeekRequested(String textHref) {
    final controller = _mediaOverlayPlaybackController;
    if (controller == null) return;
    final sectionIndex = _currentEpubLocation?.sectionIndex ?? controller.activeSectionIndex;
    if (sectionIndex == null) return;
    unawaited(
      controller.seekToTextHref(sectionIndex, textHref).then((seeked) {
        if (!mounted || !seeked) return;
        _onMediaOverlayPlaybackStarted();
      }),
    );
  }

  void _onMediaOverlayStartTargetResolved((int, String)? target) {
    final completer = _mediaOverlayStartTargetCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(target);
    }
  }

  void _onMediaOverlayPlaybackStarted() {
    PlayerUtils.enableReadingWakelock();
    _readerSetState(() {
      _mediaOverlayState = 'playing';
    });
    unawaited(epubController.setMediaOverlayUiActive(true));
    _listenForMediaOverlayHighlight();

    final controller = _mediaOverlayPlaybackController;
    if (controller != null) {
      final initialClip = controller.clipAtGlobalPosition(audioHandler.position);
      if (initialClip != null) {
        _lastHighlightedMediaOverlayClip = initialClip;
        _queueMediaOverlayHighlightUpdate(initialClip);
      }
    }
  }

  void _listenForMediaOverlayHighlight() {
    if (_mediaOverlayHighlightSubscription != null) return;
    _lastHighlightedMediaOverlayClip = null;
    _mediaOverlayHighlightSubscription = audioHandler.subtitlePositionStream.listen((position) {
      final controller = _mediaOverlayPlaybackController;
      if (controller == null || !controller.isActive || !audioHandler.isPlayingEphemeralMedia) return;

      final clip = controller.clipAtGlobalPosition(position);
      final last = _lastHighlightedMediaOverlayClip;
      if (clip == null) {
        if (last != null) {
          _lastHighlightedMediaOverlayClip = null;
          _queueMediaOverlayHighlightUpdate(null);
        }
        return;
      }
      if (last != null && last.clip.textHref == clip.clip.textHref) return;

      _lastHighlightedMediaOverlayClip = clip;
      _queueMediaOverlayHighlightUpdate(clip);
      unawaited(_syncMediaOverlayProgress(clip));
    });
  }

  Future<void> _syncMediaOverlayProgress(MediaOverlayFlatClip clip) async {
    final cfi = await epubController.getCFIForMediaOverlayTarget(clip.clip.textHref);
    if (cfi == null || cfi.isEmpty) return;
    final fraction = _currentEpubLocation?.fraction;
    if (fraction == null) return;
    unawaited(_syncEpubProgress(location: cfi, progress: fraction));
  }

  void _queueMediaOverlayHighlightUpdate(MediaOverlayFlatClip? clip) {
    _pendingMediaOverlayHighlightClip = clip;
    _hasPendingMediaOverlayHighlightUpdate = true;
    if (!_isDrainingMediaOverlayHighlightQueue) {
      unawaited(_drainMediaOverlayHighlightQueue());
    }
  }

  Future<void> _drainMediaOverlayHighlightQueue() async {
    _isDrainingMediaOverlayHighlightQueue = true;
    try {
      while (_hasPendingMediaOverlayHighlightUpdate) {
        _hasPendingMediaOverlayHighlightUpdate = false;
        final clip = _pendingMediaOverlayHighlightClip;
        if (clip == null) {
          await epubController.clearMediaOverlayHighlight();
          continue;
        }

        await epubController.goTo(clip.clip.textHref);
        if (!_hasPendingMediaOverlayHighlightUpdate) {
          await epubController.setMediaOverlayHighlight(clip.clip.textHref);
        }
      }
    } finally {
      _isDrainingMediaOverlayHighlightQueue = false;
    }
  }

  Future<void> _stopListeningForMediaOverlayHighlight() async {
    await _mediaOverlayHighlightSubscription?.cancel();
    _mediaOverlayHighlightSubscription = null;
    _lastHighlightedMediaOverlayClip = null;
    await epubController.clearMediaOverlayHighlight();
  }

  void _listenForMediaOverlayPlaybackState() {
    _mediaOverlayPlaybackStateSubscription = audioHandler.playbackState.listen((state) {
      if (!mounted) return;
      final controller = _mediaOverlayPlaybackController;
      if (controller == null) return;

      final isOurSessionActive = controller.isActive && audioHandler.isPlayingEphemeralMedia;
      final newState = !isOurSessionActive ? 'stopped' : (state.playing ? 'playing' : 'paused');
      if (newState == _mediaOverlayState) return;

      _readerSetState(() {
        _mediaOverlayState = newState;
      });
      if (newState == 'stopped') {
        PlayerUtils.disableReadingWakelock();
        _mediaOverlayStoppedAt = DateTime.now();
        unawaited(epubController.setMediaOverlayUiActive(false));
        unawaited(_stopListeningForMediaOverlayHighlight());
      }
    });
  }

  Future<Uint8List?> _loadEpubBytesForOverlay() async {
    final localFile = _localEbookFile;
    if (localFile != null && await localFile.exists()) {
      return localFile.readAsBytes();
    }

    final user = ref.read(currentUserProvider).value;
    if (user == null) return null;
    final authToken = user.preferredAuthToken;
    if (authToken == null || authToken.isEmpty) return null;

    try {
      final api = ref.read(absApiProvider);
      final dio = api?.dio ?? Dio();
      final headers = buildRequestHeaders(serverHeaders: user.server?.headers, bearerToken: authToken);
      final response = await dio.get<List<int>>(
        _ebookUrl(user),
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
          extra: <String, dynamic>{'doNotCache': true},
        ),
      );
      final data = response.data;
      if (data == null) return null;
      return Uint8List.fromList(data);
    } catch (e, s) {
      logger('Failed to download EPUB for media overlay parsing: $e\n$s', tag: 'EpubMediaOverlay', level: InfoLevel.error);
      return null;
    }
  }

  Future<EpubMediaOverlayPlaybackController?> _ensureMediaOverlayController() async {
    final existing = _mediaOverlayPlaybackController;
    if (existing != null) return existing;
    if (_isLoadingMediaOverlayController) return null;

    _isLoadingMediaOverlayController = true;
    try {
      final bytes = await _loadEpubBytesForOverlay();
      if (bytes == null || !mounted) return null;

      final engine = EpubMediaOverlayEngine.fromBytes(bytes);
      if (!engine.hasMediaOverlays) {
        logger('EPUB has no media overlays: ${widget.itemId}', tag: 'EpubMediaOverlay', level: InfoLevel.debug);
        return null;
      }

      final item = ref.read(libraryItemProvider(widget.itemId)).value;
      final api = ref.read(absApiProvider);
      Uri? cover;
      if (item != null && item.hasCover && api != null) {
        cover = api.getLibraryItemApi().getCoverUri(
          widget.itemId,
          item: item,
          width: playerCoverRequestDimension.toDouble(),
          height: playerCoverRequestDimension.toDouble(),
        );
      }

      final tempDir = await getTemporaryDirectory();
      final extractionDir = Directory(p.join(tempDir.path, 'media_overlay_audio_${widget.itemId}'));

      final controller = EpubMediaOverlayPlaybackController(
        engine: engine,
        itemId: widget.itemId,
        libraryId: item?.libraryId ?? '',
        title: item?.title ?? 'Audiobook',
        author: item?.authorString,
        narrator: item?.narratorString,
        series: item?.seriesName,
        seriesPosition: item?.seriesPosition,
        cover: cover,
        extractionDir: extractionDir,
      );

      if (!mounted) {
        unawaited(controller.dispose());
        return null;
      }

      _mediaOverlayPlaybackController = controller;
      return controller;
    } catch (e, s) {
      logger('Failed to initialize media overlay engine: $e\n$s', tag: 'EpubMediaOverlay', level: InfoLevel.error);
      return null;
    } finally {
      _isLoadingMediaOverlayController = false;
    }
  }

  Future<void> _disposeMediaOverlay() async {
    PlayerUtils.disableReadingWakelock();
    await _mediaOverlayPlaybackStateSubscription?.cancel();
    _mediaOverlayPlaybackStateSubscription = null;
    await _mediaOverlayHighlightSubscription?.cancel();
    _mediaOverlayHighlightSubscription = null;
    _lastHighlightedMediaOverlayClip = null;
    final pendingStartTarget = _mediaOverlayStartTargetCompleter;
    if (pendingStartTarget != null && !pendingStartTarget.isCompleted) {
      pendingStartTarget.complete(null);
    }
    _mediaOverlayStartTargetCompleter = null;
    final controller = _mediaOverlayPlaybackController;
    _mediaOverlayPlaybackController = null;
    if (controller != null) {
      await controller.stop();
      await controller.dispose();
      try {
        if (controller.extractionDir.existsSync()) {
          controller.extractionDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    }
  }
}
