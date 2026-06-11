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
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
              const SizedBox(width: 8),
              Expanded(child: Text('Ebook Reader', style: theme.textTheme.titleMedium)),
              IconButton(
                icon: Icon(isTtsActive ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  if (isTtsActive) {
                    _stopTts();
                  } else {
                    unawaited(_startTts(isEpubMode: isEpubMode));
                  }
                },
                tooltip: isTtsActive ? 'Stop TTS' : 'Read Aloud (TTS)',
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
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (bottomSheetContext) {
        final theme = Theme.of(bottomSheetContext);
        return StatefulBuilder(
          builder: (bottomSheetContext, setSheetState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reader Settings',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (isEpubMode) ...[
                        Text('Theme', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildThemeButton('light', Colors.white, Colors.black, setSheetState),
                            _buildThemeButton('sepia', const Color(0xFFF4ECD8), const Color(0xFF5B4636), setSheetState),
                            _buildThemeButton('grey', const Color(0xFF2E2E2E), Colors.white, setSheetState),
                            _buildThemeButton('dark', const Color(0xFF121212), const Color(0xFFE0E0E0), setSheetState),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Font Size', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {
                                final current = _fontSizeMultiplier;
                                final newValue = (current - 0.1).clamp(0.6, 2.5);
                                await ref
                                    .read(settingsManagerProvider.notifier)
                                    .setGlobalSetting<double>(SettingKeys.readerFontSizeMultiplier, newValue);
                                setSheetState(() {});
                                _applyEpubStyles();
                              },
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${(_fontSizeMultiplier * 100).toInt()}%',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                final current = _fontSizeMultiplier;
                                final newValue = (current + 0.1).clamp(0.6, 2.5);
                                await ref
                                    .read(settingsManagerProvider.notifier)
                                    .setGlobalSetting<double>(SettingKeys.readerFontSizeMultiplier, newValue);
                                setSheetState(() {});
                                _applyEpubStyles();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Line Spacing', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {
                                final current = _lineHeight;
                                final newValue = (current - 0.1).clamp(1.0, 3.0);
                                await ref
                                    .read(settingsManagerProvider.notifier)
                                    .setGlobalSetting<double>(SettingKeys.readerLineHeight, newValue);
                                setSheetState(() {});
                                _applyEpubStyles();
                              },
                            ),
                            Expanded(
                              child: Center(
                                child: Text(_lineHeight.toStringAsFixed(1), style: theme.textTheme.bodyLarge),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                final current = _lineHeight;
                                final newValue = (current + 0.1).clamp(1.0, 3.0);
                                await ref
                                    .read(settingsManagerProvider.notifier)
                                    .setGlobalSetting<double>(SettingKeys.readerLineHeight, newValue);
                                setSheetState(() {});
                                _applyEpubStyles();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Layout / Columns', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLayoutButton(
                            'paginated_1',
                            'Single Column',
                            Icons.view_column_outlined,
                            setSheetState,
                            isEpubMode,
                          ),
                          _buildLayoutButton(
                            'paginated_2',
                            'Two Columns',
                            Icons.view_column,
                            setSheetState,
                            isEpubMode,
                          ),
                          _buildLayoutButton(
                            'scrolled',
                            'Infinite Scroll',
                            Icons.view_stream,
                            setSheetState,
                            isEpubMode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeButton(String themeName, Color bg, Color text, void Function(void Function()) setSheetState) {
    final theme = Theme.of(context);
    final isSelected = _readerTheme == themeName;
    return GestureDetector(
      onTap: () async {
        await ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(SettingKeys.readerTheme, themeName);
        setSheetState(() {});
        _applyEpubStyles();
      },
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Aa',
            style: TextStyle(color: text, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutButton(
    String value,
    String label,
    IconData icon,
    void Function(void Function()) setSheetState,
    bool isEpubMode,
  ) {
    if (!isEpubMode && value == 'paginated_2') {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final bool isSelected = isEpubMode ? (value == _readerLayout) : (value == 'scrolled');

    return GestureDetector(
      onTap: () async {
        if (isEpubMode) {
          await ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(SettingKeys.readerLayout, value);
        }
        setSheetState(() {});
      },
      child: Container(
        width: 90,
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpubReaderBody({
    required User user,
    required String authToken,
    required String? initialCfi,
    required String? bookExtension,
  }) {
    final requestHeaders = buildRequestHeaders(serverHeaders: user.server?.headers, bearerToken: authToken);
    final url = _ebookUrl(user);

    return ReaderEpubView(
      controller: epubController,
      bookUrl: url,
      bookExtension: bookExtension,
      headers: requestHeaders,
      initialCfi: initialCfi,
      initialStyles: _currentEpubStyles,
      flow: _epubFlow,
      maxColumnCount: _epubMaxColumnCount,
      onRelocated: _onEpubRelocated,
      onTtsJumpToSentence: _jumpToTtsSentence,
      onBookLoaded: (metadata, toc, pageList, dir) {
        if (!mounted) return;
        _readerSetState(() {
          _epubToc = toc;
          _epubPageList = pageList;
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

  Widget _buildPdfReaderBody({required User user, required String authToken, required String? initialLocation}) {
    final int initialPage = _parseStoredPdfPage(initialLocation);
    final requestHeaders = buildRequestHeaders(serverHeaders: user.server?.headers, bearerToken: authToken);
    _triggerAutoAnnotationLoadIfNeeded(isEpubMode: false);

    return ReaderPdfView(
      controller: _pdfController,
      documentUrl: _ebookUrl(user),
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
}
