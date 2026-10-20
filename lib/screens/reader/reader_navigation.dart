part of 'reader.dart';

extension _ReaderNavigation on _ReaderState {
  bool _isReaderLocationBookmarked({required bool isEpubMode}) {
    if (!isEpubMode) {
      return _pdfBookmarks.any((entry) => entry.cfi == 'pdf:bookmark:${_currentPdfPage ?? 1}');
    }

    final cfi = _currentEpubLocation?.cfi;

    return cfi != null &&
        _epubAnnotations.any((annotation) => annotation.type == 'bookmark' && annotation.value == cfi);
  }

  Future<void> _toggleReaderBookmark({required bool isEpubMode}) async {
    if (!isEpubMode) {
      final page = _currentPdfPage;
      if (page == null || !_isBookReady) {
        return;
      }

      final cfi = 'pdf:bookmark:$page';
      _readerSetState(() {
        if (_pdfBookmarks.any((entry) => entry.cfi == cfi)) {
          _pdfBookmarks.removeWhere((entry) => entry.cfi == cfi);
        } else {
          _pdfBookmarks.add(InternalAnnotation(cfi: cfi, type: AnnotationType.bookmark, text: 'Page $page'));
        }
      });
      _scheduleAutoAnnotationSync(isEpubMode: false);
      return;
    }

    final location = _currentEpubLocation;
    final cfi = location?.cfi;

    if (location == null || cfi == null) {
      return;
    }

    if (_isReaderLocationBookmarked(isEpubMode: true)) {
      final annotation = _epubAnnotations.firstWhere((entry) => entry.type == 'bookmark' && entry.value == cfi);
      await _removeEpubAnnotation(annotation);
      return;
    }

    final chapter = location.tocItem?.label ?? 'Bookmark';
    final annotation = FoliateAnnotation(
      value: cfi,
      color: 'none',
      type: 'bookmark',
      note: '$chapter · ${(location.fraction * 100).round()}%',
    );

    _readerSetState(() {
      _epubAnnotations.add(annotation);
    });
    _scheduleAutoAnnotationSync(isEpubMode: true);
    _showSnackBar('Bookmark added');
  }

  Widget _buildDrawer({required bool isEpubMode, required String title}) {
    final theme = _readerThemeData;
    final hasToc = isEpubMode ? _epubToc?.isNotEmpty == true : _pdfToc?.isNotEmpty == true;

    return Drawer(
      width: context.isMobile ? (context.screenWidth * 0.92).clamp(0.0, 400.0) : 400,
      backgroundColor: _readerColors.surface,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 8, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close contents',
                      onPressed: () => _scaffoldKey.currentState?.closeDrawer(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Contents'),
                  Tab(text: 'Saved'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    hasToc
                        ? ListView(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            children: isEpubMode
                                ? _epubToc!.map(_buildEpubTocTile).toList()
                                : _pdfToc!.map(_buildPdfTocTile).toList(),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text('This book has no table of contents.', textAlign: TextAlign.center),
                            ),
                          ),
                    _buildSavedReaderEntries(isEpubMode: isEpubMode),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.tonalIcon(
                  onPressed: !_isBookReady ? null : () => unawaited(_toggleReaderBookmark(isEpubMode: isEpubMode)),
                  icon: Icon(
                    _isReaderLocationBookmarked(isEpubMode: isEpubMode)
                        ? Icons.bookmark_remove_outlined
                        : Icons.bookmark_add_outlined,
                  ),
                  label: Text(
                    _isReaderLocationBookmarked(isEpubMode: isEpubMode) ? 'Remove bookmark' : 'Bookmark this page',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _containsCurrentChapter(FoliateTOCItem item) {
    return (item.href != null && item.href == _currentEpubLocation?.tocItem?.href) ||
        item.subitems?.any(_containsCurrentChapter) == true;
  }

  void _openEpubChapter(FoliateTOCItem item) {
    if (item.href == null) {
      return;
    }

    _scaffoldKey.currentState?.closeDrawer();
    unawaited(epubController.goTo(item.href!));
  }

  Widget _buildEpubTocTile(FoliateTOCItem item) {
    final selected = item.href != null && item.href == _currentEpubLocation?.tocItem?.href;

    if (item.subitems?.isNotEmpty != true) {
      return ListTile(
        selected: selected,
        selectedTileColor: _readerColors.secondaryContainer,
        leading: selected ? const Icon(Icons.menu_book_outlined, size: 20) : const SizedBox(width: 20),
        title: Text(item.label ?? 'Untitled chapter'),
        onTap: item.href == null ? null : () => _openEpubChapter(item),
      );
    }

    return ExpansionTile(
      key: PageStorageKey(item.href ?? item.label),
      initiallyExpanded: _containsCurrentChapter(item),
      title: InkWell(
        onTap: item.href == null ? null : () => _openEpubChapter(item),
        child: Text(item.label ?? 'Untitled chapter'),
      ),
      childrenPadding: const EdgeInsets.only(left: 12),
      children: item.subitems!.map(_buildEpubTocTile).toList(),
    );
  }

  Widget _buildPdfTocTile(PdfOutlineNode node) {
    void openChapter() {
      _scaffoldKey.currentState?.closeDrawer();
      if (node.dest != null) {
        unawaited(_pdfController.goToDest(node.dest!));
      }
    }

    if (node.children.isEmpty) {
      return ListTile(title: Text(node.title), onTap: node.dest == null ? null : openChapter);
    }

    return ExpansionTile(
      title: InkWell(onTap: node.dest == null ? null : openChapter, child: Text(node.title)),
      childrenPadding: const EdgeInsets.only(left: 12),
      children: node.children.map(_buildPdfTocTile).toList(),
    );
  }

  Widget _buildSavedReaderEntries({required bool isEpubMode}) {
    final count = isEpubMode ? _epubAnnotations.length : _pdfBookmarks.length + _pdfAnnotations.length;

    if (count == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bookmarks_outlined, size: 40),
              const SizedBox(height: 16),
              Text(
                'Keep the passages you love',
                style: _readerThemeData.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text('Select text to highlight it or add a note.', textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: count,
      itemBuilder: (context, index) {
        if (!isEpubMode) {
          if (index < _pdfBookmarks.length) {
            final bookmark = _pdfBookmarks[index];
            final page = int.parse(bookmark.cfi.substring('pdf:bookmark:'.length));

            return ListTile(
              leading: const Icon(Icons.bookmark_rounded),
              title: Text(bookmark.text ?? 'Page $page'),
              subtitle: const Text('Bookmark'),
              trailing: IconButton(
                tooltip: 'Remove bookmark',
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () {
                  _readerSetState(() {
                    _pdfBookmarks.remove(bookmark);
                  });
                  _scheduleAutoAnnotationSync(isEpubMode: false);
                },
              ),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                unawaited(_pdfController.goToPage(pageNumber: page));
              },
            );
          }

          final entry = _pdfAnnotations[index - _pdfBookmarks.length];

          return ListTile(
            leading: Icon(entry.type == AnnotationType.underline ? Icons.format_underlined : Icons.highlight_outlined),
            title: Text(
              entry.noteText ?? (entry.type == AnnotationType.underline ? 'Underlined passage' : 'Highlighted passage'),
            ),
            subtitle: Text('Page ${entry.pageNumber}'),
            trailing: IconButton(
              tooltip: 'Remove saved passage',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _removePdfAnnotation(entry.cfi),
            ),
            onTap: () {
              _scaffoldKey.currentState?.closeDrawer();
              unawaited(_pdfController.goToPage(pageNumber: entry.pageNumber));
            },
          );
        }

        final entry = _epubAnnotations[index];
        final label = switch (entry.type) {
          'bookmark' => 'Bookmark',
          'underline' => 'Underlined passage',
          _ => 'Highlighted passage',
        };

        return ListTile(
          leading: Icon(switch (entry.type) {
            'bookmark' => Icons.bookmark_rounded,
            'underline' => Icons.format_underlined,
            _ => Icons.highlight_outlined,
          }),
          title: Text(
            entry.note?.isNotEmpty == true ? entry.note! : label,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: entry.note?.isNotEmpty == true ? Text(label) : null,
          trailing: IconButton(
            tooltip: 'Remove $label',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () => unawaited(_removeEpubAnnotation(entry)),
          ),
          onTap: () {
            _scaffoldKey.currentState?.closeDrawer();
            unawaited(epubController.goTo(entry.value));
          },
        );
      },
    );
  }
}
