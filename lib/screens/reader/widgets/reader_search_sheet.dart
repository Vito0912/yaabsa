import 'dart:async';

import 'package:foliate_reader/foliate_reader.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pdfrx/pdfrx.dart';

const _maxEpubSearchResults = 300;

typedef ReaderSearchSelection = ({String? epubCfi, PdfPageTextRange? pdfMatch});

class ReaderSearchSheet extends StatefulWidget {
  const ReaderSearchSheet({super.key, this.epubController, this.pdfSearcher});

  final FoliateViewerController? epubController;
  final PdfTextSearcher? pdfSearcher;

  @override
  State<ReaderSearchSheet> createState() => _ReaderSearchSheetState();
}

class _ReaderSearchSheetState extends State<ReaderSearchSheet> {
  final TextEditingController _queryController = TextEditingController();
  Timer? _debounce;
  Timer? _pdfUpdateTimer;
  int? _activeEpubSearch;
  int _pdfResultCount = 0;
  RegExp? _highlightPattern;
  bool _hasSearched = false;
  int _generation = 0;
  String _query = '';
  List<FoliateSearchResult> _epubResults = [];
  bool _searching = false;
  bool _openingResult = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.pdfSearcher?.addListener(_onPdfSearchChanged);
  }

  void _onPdfSearchChanged() {
    if (!mounted) {
      return;
    }

    final searcher = widget.pdfSearcher!;
    if (!searcher.isSearching) {
      _pdfUpdateTimer?.cancel();
      _pdfUpdateTimer = null;
      _updatePdfResults();
      return;
    }

    if (_pdfResultCount == searcher.matches.length && _searching) {
      return;
    }

    _pdfUpdateTimer ??= Timer(const Duration(milliseconds: 80), () {
      _pdfUpdateTimer = null;
      _updatePdfResults();
    });
  }

  void _updatePdfResults() {
    if (!mounted) {
      return;
    }

    setState(() {
      _pdfResultCount = widget.pdfSearcher!.matches.length;
      _searching = widget.pdfSearcher!.isSearching;
    });
  }

  void _onQueryChanged(String text) {
    final query = text.trim();
    if (query == _query) {
      return;
    }

    _debounce?.cancel();
    _pdfUpdateTimer?.cancel();
    _pdfUpdateTimer = null;
    final generation = ++_generation;

    if (_activeEpubSearch != null) {
      _activeEpubSearch = null;
      unawaited(widget.epubController?.clearSearch());
    }

    final pdfSearcher = widget.pdfSearcher;
    if (pdfSearcher != null && (pdfSearcher.pattern != null || pdfSearcher.isSearching)) {
      pdfSearcher.resetTextSearch();
    }

    setState(() {
      _query = query;
      _highlightPattern = query.isEmpty ? null : RegExp(RegExp.escape(query), caseSensitive: false);
      _epubResults = [];
      _pdfResultCount = 0;
      _error = null;
      _hasSearched = false;
      _searching = query.runes.length >= 2;
    });

    if (!_searching) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(_search(query, generation));
    });
  }

  Future<void> _search(String query, int generation) async {
    if (!mounted || generation != _generation || query.isEmpty) {
      return;
    }

    setState(() {
      _hasSearched = true;
      _searching = true;
      _error = null;
    });

    final pdfSearcher = widget.pdfSearcher;
    if (pdfSearcher != null) {
      pdfSearcher.startTextSearch(query, goToFirstMatch: false, searchImmediately: true);
      return;
    }

    _activeEpubSearch = generation;

    try {
      final results = await widget.epubController!.searchBook(query, maxResults: _maxEpubSearchResults);
      if (!mounted || generation != _generation) {
        return;
      }

      setState(() {
        _epubResults = results;
        _searching = false;
      });
    } catch (_) {
      if (!mounted || generation != _generation) {
        return;
      }

      setState(() {
        _searching = false;
        _error = 'Could not search this book. Please try again.';
      });
    } finally {
      if (_activeEpubSearch == generation) {
        _activeEpubSearch = null;
      }
    }
  }

  String get _emptyMessage {
    if (_error != null) {
      return _error!;
    }

    if (_query.isEmpty) {
      return 'Find a passage anywhere in this book.';
    }

    if (!_hasSearched && !_searching) {
      return 'Type at least two characters, or press Search.';
    }

    if (_searching) {
      return 'Looking for “$_query”';
    }

    return 'No matches found. Try another word or phrase.';
  }

  Future<void> _openResult(int index) async {
    if (_openingResult) {
      return;
    }

    _openingResult = true;
    _debounce?.cancel();
    FocusScope.of(context).unfocus();

    try {
      final pdfSearcher = widget.pdfSearcher;
      final ReaderSearchSelection selection;
      if (pdfSearcher != null) {
        final match = pdfSearcher.matches[index];
        selection = (epubCfi: null, pdfMatch: match);
        await pdfSearcher.goToMatch(match);
      } else {
        final cfi = _epubResults[index].cfi;
        selection = (epubCfi: cfi, pdfMatch: null);
        await widget.epubController!.goTo(cfi);
      }

      if (mounted) {
        Navigator.pop(context, selection);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Could not open this result. Please try again.';
        });
      }
    } finally {
      _openingResult = false;
    }
  }

  String _pdfExcerpt(PdfPageTextRange match) {
    final text = match.pageText.fullText;
    final start = (match.start - 55).clamp(0, text.length);
    final end = (match.end + 85).clamp(0, text.length);

    return text.substring(start, end).replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Widget _buildExcerpt(String excerpt) {
    final theme = Theme.of(context);
    final spans = <TextSpan>[];
    final matches = _highlightPattern?.allMatches(excerpt) ?? const <RegExpMatch>[];
    var offset = 0;

    for (final match in matches) {
      spans.add(TextSpan(text: excerpt.substring(offset, match.start)));
      spans.add(
        TextSpan(
          text: excerpt.substring(match.start, match.end),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondaryContainer,
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
        ),
      );
      offset = match.end;
    }

    spans.add(TextSpan(text: excerpt.substring(offset)));

    return Text.rich(TextSpan(children: spans), maxLines: 4, overflow: TextOverflow.ellipsis);
  }

  @override
  void dispose() {
    _generation++;
    _debounce?.cancel();
    _pdfUpdateTimer?.cancel();
    if (_activeEpubSearch != null) {
      unawaited(widget.epubController?.clearSearch());
    }
    widget.pdfSearcher?.removeListener(_onPdfSearchChanged);
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pdfMatches = widget.pdfSearcher?.matches;
    final resultCount = pdfMatches?.length ?? _epubResults.length;
    final insets = MediaQuery.viewInsetsOf(context);
    var resultLabel = '$resultCount ${resultCount == 1 ? 'result' : 'results'}';
    if (_searching) {
      resultLabel = 'Searching the book…';
    } else if (pdfMatches == null && resultCount >= _maxEpubSearchResults) {
      resultLabel = 'First $resultCount results. Refine your search.';
    }

    return Padding(
      padding: EdgeInsets.only(bottom: insets.bottom),
      child: SizedBox(
        height: (MediaQuery.sizeOf(context).height * 0.78 - insets.bottom).clamp(180.0, double.infinity),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(child: Text('Search in book', style: theme.textTheme.titleLarge)),
                  IconButton(
                    tooltip: 'Close search',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _queryController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: _onQueryChanged,
                onSubmitted: (text) {
                  if (_query.isNotEmpty && (_debounce?.isActive == true || !_hasSearched || _error != null)) {
                    _debounce?.cancel();
                    unawaited(_search(_query, _generation));
                  }

                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Find a word or phrase',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _queryController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _queryController.clear();
                            _onQueryChanged('');
                          },
                        ),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                ),
              ),
            ),
            if (_searching) const Padding(padding: EdgeInsets.only(top: 16), child: LinearProgressIndicator()),
            if (_query.isNotEmpty && _error == null && (_searching || _hasSearched))
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    resultLabel,
                    style: theme.textTheme.labelLarge,
                    semanticsLabel: _searching ? 'Searching the book' : '$resultCount results found',
                  ),
                ),
              ),
            Expanded(
              child: resultCount == 0 || _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _emptyMessage,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    )
                  : ListView.separated(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: resultCount,
                      separatorBuilder: (context, index) => const Divider(height: 1, indent: 24, endIndent: 24),
                      itemBuilder: (context, index) {
                        final match = pdfMatches?[index];
                        final excerpt = match == null ? _epubResults[index].excerpt : _pdfExcerpt(match);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          leading: Text('${index + 1}', style: theme.textTheme.labelLarge),
                          title: _buildExcerpt(excerpt),
                          subtitle: match == null ? null : Text('Page ${match.pageNumber}'),
                          trailing: const Icon(Icons.arrow_forward_rounded, size: 20),
                          onTap: () => unawaited(_openResult(index)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
