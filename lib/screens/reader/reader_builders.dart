part of 'reader.dart';

extension _ReaderBuilders on _ReaderState {
  void _applyEpubStyles() {
    unawaited(epubController.setStyles(_currentEpubStyles));
    _applyEpubPageGeometry();
  }

  void _applyEpubPageGeometry() {
    final settings = ref.read(settingsManagerProvider.notifier);
    final margin = settings.getGlobalSetting<double>(SettingKeys.readerPageMargin);
    final verticalMargin = _isSystemUiVisible ? margin.clamp(0.0, 12.0).toDouble() : margin;

    unawaited(
      epubController.setPageGeometry(
        margin: margin,
        verticalMargin: verticalMargin,
        width: settings.getGlobalSetting<double>(SettingKeys.readerPageWidth),
      ),
    );
  }

  Widget _buildEpubReaderBody({
    required User user,
    required String authToken,
    required String? initialCfi,
    required String? bookExtension,
    File? bookFile,
  }) {
    final requestHeaders = buildRequestHeaders(serverHeaders: user.server?.headers, bearerToken: authToken);
    final url = _ebookUrl(user);

    return ReaderEpubView(
      controller: epubController,
      bookUrl: url,
      bookFile: bookFile,
      bookExtension: bookExtension,
      headers: requestHeaders,
      initialCfi: initialCfi,
      initialStyles: _currentEpubStyles,
      flow: _epubFlow,
      maxColumnCount: _epubMaxColumnCount,
      onRelocated: _onEpubRelocated,
      onTtsJumpToSentence: _jumpToTtsSentence,
      onNarrationSeek: (target) {
        if (audioHandler.isReaderNarrationFor(widget.itemId)) {
          unawaited(audioHandler.seekReaderNarrationTarget(target));
        }
      },
      onDiagnostic: (message, isError) {
        logger(
          'Item ${widget.itemId}: $message',
          tag: 'EpubReader',
          level: isError ? InfoLevel.error : InfoLevel.debug,
        );
      },
      bookFetcher: (url, headers, request) async {
        try {
          final api = ref.read(absApiProvider);
          final dio = api?.dio ?? Dio();

          final response = await dio.get<ResponseBody>(
            url,
            options: Options(
              headers: headers,
              responseType: ResponseType.stream,
              extra: <String, dynamic>{'doNotCache': true},
            ),
          );

          request.response.statusCode = response.statusCode ?? 200;

          final ignoreHeaders = {'content-length', 'content-encoding', 'transfer-encoding', 'connection', 'host'};

          response.headers.forEach((key, values) {
            if (ignoreHeaders.contains(key.toLowerCase())) {
              return;
            }

            for (final value in values) {
              request.response.headers.add(key, value);
            }
          });
          request.response.headers.set('Access-Control-Allow-Origin', '*');

          final data = response.data;

          if (data != null) {
            await data.stream.cast<List<int>>().pipe(request.response);
          } else {
            await request.response.close();
          }
        } catch (e, s) {
          logger(
            'Item ${widget.itemId}: remote eBook fetch failed\nCause: $e\nStack trace:\n$s',
            tag: 'EpubReader',
            level: InfoLevel.error,
          );
          request.response.statusCode = 500;
          request.response.headers.set('Access-Control-Allow-Origin', '*');
          request.response.write('Internal Server Error: $e');
          await request.response.close();
        }
      },
      onBookLoaded: (metadata, toc, pageList, dir, hasMediaOverlays) {
        if (!mounted) {
          return;
        }

        _readerSetState(() {
          _isBookReady = true;
          _epubToc = toc;
          _epubPageList = pageList;
          _hasMediaOverlays = hasMediaOverlays;
        });
        _applyEpubStyles();
        _triggerAutoAnnotationLoadIfNeeded(isEpubMode: true);

        if (audioHandler.isReaderNarrationFor(widget.itemId)) {
          _lastNarrationTarget = null;
          _pendingNarrationTarget = audioHandler.readerNarrationTarget(audioHandler.position);
          unawaited(_highlightNarration());
        } else if (audioHandler.isReaderSpeechFor(widget.itemId)) {
          _lastSpeechCfi = null;
          _followReaderSpeech();
        } else {
          unawaited(_startReadingSession());
        }
      },
      onMediaOverlayError: (error) {
        _showSnackBar(error);
      },
      onSelectionChanged: (selection) {},
      onSelectionCleared: () {},
      onAnnotationClicked: (annotation) async {
        if (!mounted) {
          return;
        }

        final action = await showReaderEpubAnnotationSheet(context, annotation);

        if (!mounted || action == null) {
          return;
        }

        if (action.type == ReaderAnnotationSheetActionType.delete) {
          await _removeEpubAnnotation(annotation);

          return;
        }

        await _editEpubAnnotation(annotation, noteText: action.note, color: action.color);
      },
      onAnnotationAdded: (annotation) {
        if (!mounted) {
          return;
        }

        _readerSetState(() {
          _epubAnnotations.add(annotation);
        });
        _scheduleAutoAnnotationSync(isEpubMode: true);
      },
      onError: (error) {
        _readerSetState(() {
          _isBookReady = false;
        });
        logger('Failed to load ebook: $error', tag: 'EpubReader', level: InfoLevel.error);
        _showSnackBar(error);
      },
      onCenterTap: _toggleSystemUi,
    );
  }

  Widget _buildPdfReaderBody({
    required User user,
    required String authToken,
    required String? initialLocation,
    File? pdfFile,
  }) {
    final int initialPage = _parseStoredPdfPage(initialLocation);
    final requestHeaders = buildRequestHeaders(serverHeaders: user.server?.headers, bearerToken: authToken);

    _triggerAutoAnnotationLoadIfNeeded(isEpubMode: false);

    return ReaderPdfView(
      controller: _pdfController,
      documentUrl: _ebookUrl(user),
      pdfFile: pdfFile,
      requestHeaders: requestHeaders,
      itemId: widget.itemId,
      backgroundColor: _readerColors.surface,
      searcher: _pdfSearcher,
      searchHighlight: _pdfSearchHighlight,
      initialPage: initialPage,
      onPageFocused: (pageNumber) => _syncPdfProgress(pageNumber: pageNumber),
      onTextSelectionChange: (_) {},
      customizeContextMenuItems: _customizePdfContextMenuItems,
      buildPageOverlays: _buildPdfPageOverlays,
      onGeneralTap: _onPdfViewerGeneralTap,
      onDocumentReady: (doc) {
        _readerSetState(() {
          _isBookReady = true;
          _pdfDocument = doc;
          _pdfSearcher ??= PdfTextSearcher(_pdfController);
        });

        if (audioHandler.isReaderNarrationFor(widget.itemId)) {
          _lastNarrationTarget = null;
          _pendingNarrationTarget = audioHandler.readerNarrationTarget(audioHandler.position);
          unawaited(_highlightNarration());
        } else if (audioHandler.isReaderSpeechFor(widget.itemId)) {
          _lastSpeechCfi = null;
          _followReaderSpeech();
        } else {
          unawaited(_startReadingSession());
        }
      },
      onOutlineLoaded: (outline) {
        _readerSetState(() {
          _pdfToc = outline;
        });
      },
    );
  }
}
