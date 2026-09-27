part of 'reader.dart';

/// Wires the EPUB3 media-overlay reader UI up to
/// [EpubMediaOverlayPlaybackController], which drives narration audio
/// through the shared [BGAudioHandler] (lockscreen/notification/Bluetooth
/// controls, sleep timer, speed, skip/seek) instead of the old WebView-only
/// `foliate-js` playback path.
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

    // Find the sync-point nearest the reader's current visible position (the
    // same technique the old in-WebView `startMediaOverlay()` used) so
    // narration starts close to what's on screen instead of always
    // restarting at the top of the current section. This is a fire-and-
    // forget WebView request answered via a callback (not evaluateJavascript's
    // return value, which does not await JS Promises) — bridge it back to a
    // single in-flight request with a completer, with a timeout in case the
    // WebView never responds.
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

  /// Redirects active narration to the section containing [href] (a TOC
  /// entry's href) — lets the table-of-contents drawer double as section
  /// navigation for narration, since there's no chapter list to drive the
  /// main player's native chapter-skip UI for this content.
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

  /// Handles a tap on a narrated paragraph in the WebView (tap-to-seek).
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

    // Push the first highlight/goTo immediately from the position the audio
    // was just seeked to, instead of waiting for the first
    // `subtitlePositionStream` tick to arrive (which only starts once the
    // ephemeral audio source has actually finished loading, up to ~1s
    // later). Without this, the WebView sits at whatever it was showing
    // before narration started while its container is *already* resized for
    // the mini player — and since foliate's paginator recomputes page
    // boundaries from scratch on a height change rather than preserving
    // the previous top-of-view character, that transient state can show a
    // jumbled, unrelated page until the delayed first tick corrects it.
    // Queuing the real target right away collapses that window to nothing.
    final controller = _mediaOverlayPlaybackController;
    if (controller != null) {
      final initialClip = controller.clipAtGlobalPosition(audioHandler.position);
      if (initialClip != null) {
        _lastHighlightedMediaOverlayClip = initialClip;
        _queueMediaOverlayHighlightUpdate(initialClip);
      }
    }
  }

  /// Subscribes to the shared player's fine-grained position stream and
  /// pushes the currently-narrated paragraph's highlight into the WebView
  /// whenever it changes — reuses the same highlight-application code the
  /// old foliate-js-driven path used (`Overlayer.add`/`resolveNavigation`),
  /// just triggered explicitly from Dart instead of a foliate-js event.
  ///
  /// Also pushes reading progress to the server on the same per-paragraph
  /// cadence, through the same `ebookLocation`/`ebookProgress` path the
  /// plain reader already uses (`_syncEpubProgress`/`_throttleProgressSync`)
  /// — this is what makes listening advance the position a plain e-reader
  /// (or this app's own reading mode) will resume from, since the server has
  /// no separate concept of media-overlay listening progress.
  ///
  /// Also moves the WebView to the narrated location (`goTo`) every time the
  /// highlighted clip changes — not just on a discontinuous seek jump — so
  /// the visible page actually follows along as narration crosses a page
  /// boundary during ordinary forward playback, the same way real
  /// read-along implementations keep the page in sync with narration.
  ///
  /// A single drag/tap on the player's seek bar can trigger several *real*
  /// backend seeks in quick succession (it rate-limits and queues, rather
  /// than sending every intermediate drag value), each producing its own
  /// clip change here. Applying each one's goTo-then-highlight
  /// independently and concurrently lets them race — a later seek's update
  /// can finish before an earlier seek's does (e.g. the earlier one needed
  /// to load a new section, the later one didn't), leaving the WebView
  /// showing a stale intermediate position. So updates are queued and
  /// drained strictly one at a time — mirroring the same pattern the seek
  /// bar itself already uses for the same class of problem — always
  /// converging on whatever the latest requested target was by the time the
  /// queue is drained, and skipping a highlight application entirely if a
  /// newer target already arrived while this one's `goTo` was in flight.
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

  // `goTo` on its own already triggers a WebView 'relocate' event (foliate's
  // `#afterScroll` fires unconditionally, even when the scroll offset
  // doesn't change), which `_onEpubRelocated` turns into a progress sync -
  // but the CFI that event reports spans the *entire visible page* (its
  // range runs from the first to the last visible character), not the
  // specific narrated sentence. That's fine for a plain reader resuming
  // somewhere on the page it last showed, but for narration a different CFI
  // consumer (e.g. another Audiobookshelf client) resolving that whole-page
  // range can land anywhere within it - not the sentence being narrated when
  // playback actually stopped, which is what should determine where you
  // resume. Sync the precise per-sentence CFI here instead, alongside the
  // fraction from the accompanying page-level relocate (close enough - see
  // `EpubMediaOverlayEngine`'s documented tolerance for minor audio/text
  // misalignment).
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

        // goTo must complete before the highlight is applied: if this
        // position is in a spine section that isn't currently rendered (a
        // large seek can land anywhere), applying the highlight first would
        // try to resolve the target against the *old* section's DOM and
        // silently fail to find it.
        await epubController.goTo(clip.clip.textHref);
        // If a newer target arrived while goTo was in flight, don't bother
        // highlighting this now-stale one — the next loop iteration will
        // goTo-and-highlight the latest one instead.
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
    // Always released here too (not just on narration stopping) since this
    // also runs when the reader screen itself goes away (e.g. navigating to
    // the full player, or switching books) — the screen only needs to stay
    // on while media-overlay narration is visually followed on this screen,
    // not for as long as the underlying (possibly still-playing) session
    // lives on elsewhere.
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
