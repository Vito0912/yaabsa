part of 'reader.dart';

extension _ReaderBuilders on _ReaderState {
  Widget _buildTopBar({required bool isEpubMode}) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    final isTtsActive = _isTtsPlaying;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      top: _isSystemUiVisible ? 0.0 : -100.0 - topPadding,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(top: topPadding, left: 8, right: 8, bottom: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withAlpha(220),
            border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withAlpha(100))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
              const SizedBox(width: 8),
              const Spacer(),
              if (isEpubMode)
                IconButton(
                  icon: Icon(isTtsActive ? Icons.volume_off : Icons.volume_up),
                  onPressed: () {
                    if (isTtsActive) {
                      _stopTts();
                    } else {
                      unawaited(_startTts());
                    }
                  },
                  tooltip: isTtsActive ? 'Stop TTS' : 'Start TTS',
                ),
              if (_hasMediaOverlays)
                IconButton(
                  icon: Icon(_mediaOverlayState != 'stopped' ? Icons.hearing_disabled : Icons.hearing),
                  onPressed: () {
                    if (_mediaOverlayState != 'stopped') {
                      unawaited(epubController.stopMediaOverlay());
                    } else {
                      if (_isTtsPlaying) {
                        _stopTts();
                      }
                      unawaited(epubController.startMediaOverlay());
                    }
                  },
                  tooltip: _mediaOverlayState != 'stopped' ? 'Stop Narration' : 'Start Narration',
                ),
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_book),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: 'Table of Contents',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showReaderSettingsSheet(isEpubMode: isEpubMode),
                tooltip: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildDrawer({required bool isEpubMode}) {
    final theme = Theme.of(context);
    final hasToc = isEpubMode ? (_epubToc != null && _epubToc!.isNotEmpty) : (_pdfToc != null && _pdfToc!.isNotEmpty);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Table of Contents',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: !hasToc
                  ? const Center(child: Text('No table of contents available'))
                  : ListView(
                      children: isEpubMode
                          ? _epubToc!.map((item) => _buildEpubTocTile(item, context)).toList()
                          : _pdfToc!.map((node) => _buildPdfTocTile(node, context)).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpubTocTile(FoliateTOCItem item, BuildContext context) {
    final hasSubitems = item.subitems != null && item.subitems!.isNotEmpty;

    if (!hasSubitems) {
      return ListTile(
        title: Text(item.label ?? 'Untitled'),
        onTap: () {
          Navigator.pop(context);
          if (item.href != null) {
            unawaited(epubController.goTo(item.href!));
          }
        },
      );
    }

    return ExpansionTile(
      title: Text(item.label ?? 'Untitled'),
      children: item.subitems!.map((sub) => _buildEpubTocTile(sub, context)).toList(),
    );
  }

  Widget _buildPdfTocTile(PdfOutlineNode node, BuildContext context) {
    final hasChildren = node.children.isNotEmpty;

    if (!hasChildren) {
      return ListTile(
        title: Text(node.title),
        onTap: () {
          Navigator.pop(context);
          if (node.dest != null) {
            unawaited(_pdfController.goToDest(node.dest!));
          }
        },
      );
    }

    return ExpansionTile(
      title: Text(node.title),
      children: node.children.map((sub) => _buildPdfTocTile(sub, context)).toList(),
    );
  }

  void _applyEpubStyles() {
    unawaited(epubController.setStyles(_currentEpubStyles));
  }

  void _showReaderSettingsSheet({required bool isEpubMode}) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (bottomSheetContext) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Navigator(
              initialRoute: '/',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case '/':
                    builder = (BuildContext context) => const ReaderSettings();
                    break;
                  case ReaderTtsSettings.routeName:
                    builder = (BuildContext context) => const ReaderTtsSettings();
                    break;
                  default:
                    throw Exception('Invalid route: ${settings.name}');
                }
                return MaterialPageRoute<void>(builder: builder, settings: settings);
              },
            ),
          ),
        );
      },
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
      bookFetcher: (url, headers, request) async {
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
        response.headers.forEach((key, values) {
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
      },
      onBookLoaded: (metadata, toc, pageList, dir, hasMediaOverlays) {
        if (!mounted) return;
        _readerSetState(() {
          _epubToc = toc;
          _epubPageList = pageList;
          _hasMediaOverlays = hasMediaOverlays;
        });
        _applyEpubStyles();
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _applyEpubStyles();
          }
        });
        _triggerAutoAnnotationLoadIfNeeded(isEpubMode: true);
        unawaited(_startReadingSession());
      },
      onMediaOverlayStateChanged: (state) {
        _readerSetState(() {
          _mediaOverlayState = state;
        });
      },
      onMediaOverlayError: (error) {
        _showSnackBar(error);
      },
      onSelectionChanged: (selection) {},
      onSelectionCleared: () {},
      onAnnotationClicked: (annotation) {
        if (!mounted) return;
        final noteController = TextEditingController(text: annotation.note);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (bottomSheetContext) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: noteController,
                      maxLines: 3,
                      minLines: 1,
                      decoration: const InputDecoration(labelText: 'Note', hintText: 'Add an optional note'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [Colors.yellow, Colors.green, Colors.blue, Colors.pink, Colors.purple].map((c) {
                      final hex = _colorToHex(c);
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(bottomSheetContext);
                          unawaited(_editEpubAnnotation(annotation, noteText: noteController.text, color: hex));
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                          unawaited(_editEpubAnnotation(annotation, noteText: noteController.text));
                        },
                        child: const Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                          unawaited(_removeEpubAnnotation(annotation));
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
      onAnnotationAdded: (annotation) {
        if (!mounted) return;
        _readerSetState(() {
          _epubAnnotations.add(annotation);
        });
        _scheduleAutoAnnotationSync(isEpubMode: true);
      },
      onError: (error) {
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
      initialPage: initialPage,
      onPageFocused: (pageNumber) => _syncPdfProgress(pageNumber: pageNumber),
      onTextSelectionChange: (_) {},
      customizeContextMenuItems: _customizePdfContextMenuItems,
      buildPageOverlays: _buildPdfPageOverlays,
      onGeneralTap: _onPdfViewerGeneralTap,
      onDocumentReady: (doc) {
        _readerSetState(() {
          _pdfDocument = doc;
        });
        unawaited(_startReadingSession());
      },
      onOutlineLoaded: (outline) {
        _readerSetState(() {
          _pdfToc = outline;
        });
      },
    );
  }

  Widget _buildMediaOverlayControlPanel() {
    if (_mediaOverlayState == 'stopped') return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                unawaited(epubController.stopMediaOverlay());
              },
              tooltip: 'Stop Narration',
            ),
            IconButton(
              icon: Icon(_mediaOverlayState == 'paused' ? Icons.play_arrow : Icons.pause),
              onPressed: () {
                if (_mediaOverlayState == 'paused') {
                  unawaited(epubController.resumeMediaOverlay());
                } else {
                  unawaited(epubController.pauseMediaOverlay());
                }
              },
              tooltip: _mediaOverlayState == 'paused' ? 'Resume' : 'Pause',
            ),
          ],
        ),
      ),
    );
  }
}
