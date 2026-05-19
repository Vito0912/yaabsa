import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';

import 'package:yaabsa/generated/l10n.dart';

Future<List<String>?> showBookEditorSheet({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  bool selectionRequired = true,
  List<LibraryItem> initialBooks = const <LibraryItem>[],
  String? skipLabel,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      return FractionallySizedBox(
        heightFactor: 0.95,
        child: _BookEditorSheet(
          title: title,
          confirmLabel: confirmLabel,
          selectionRequired: selectionRequired,
          initialBooks: initialBooks,
          skipLabel: skipLabel,
        ),
      );
    },
  );
}

class _BookEditorSheet extends ConsumerStatefulWidget {
  const _BookEditorSheet({
    required this.title,
    required this.confirmLabel,
    required this.selectionRequired,
    required this.initialBooks,
    this.skipLabel,
  });

  final String title;
  final String confirmLabel;
  final bool selectionRequired;
  final List<LibraryItem> initialBooks;
  final String? skipLabel;

  @override
  ConsumerState<_BookEditorSheet> createState() => _BookEditorSheetState();
}

class _BookEditorSheetState extends ConsumerState<_BookEditorSheet> {
  late final TextEditingController _searchController;
  late final List<String> _selectedIds;
  final Map<String, LibraryItem> _selectedItemsById = <String, LibraryItem>{};
  String _searchQuery = '';

  bool get _canSubmit => !widget.selectionRequired || _selectedIds.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _selectedIds = <String>[];

    for (final item in widget.initialBooks) {
      if (item.id.isEmpty || _selectedItemsById.containsKey(item.id)) {
        continue;
      }
      _selectedItemsById[item.id] = item;
      _selectedIds.add(item.id);
    }

    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    final nextQuery = _searchController.text.trim();
    if (nextQuery == _searchQuery) {
      return;
    }

    setState(() {
      _searchQuery = nextQuery;
    });
  }

  void _toggleSelection(LibraryItem item, bool selected) {
    setState(() {
      if (selected) {
        if (!_selectedItemsById.containsKey(item.id)) {
          _selectedIds.add(item.id);
        }
        _selectedItemsById[item.id] = item;
      } else {
        _selectedIds.remove(item.id);
        _selectedItemsById.remove(item.id);
      }
    });
  }

  void _removeSelection(String id) {
    setState(() {
      _selectedIds.remove(id);
      _selectedItemsById.remove(id);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _selectedItemsById.clear();
    });
  }

  void _reorderSelection(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final moved = _selectedIds.removeAt(oldIndex);
      _selectedIds.insert(newIndex, moved);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = _searchQuery.isNotEmpty
        ? ref.watch(librarySearchProvider(_searchQuery))
        : const AsyncData<SearchLibrary?>(null);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
        title: Text(widget.title),
        actions: [
          if (widget.skipLabel != null)
            TextButton(onPressed: () => Navigator.of(context).pop(<String>[]), child: Text(widget.skipLabel!)),
          if (_selectedIds.isNotEmpty)
            TextButton(onPressed: _clearSelection, child: Text(S.current.componentsCommonBookEditorSheetUnselectAll)),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _canSubmit ? () => Navigator.of(context).pop(_selectedIds.toList(growable: false)) : null,
              child: Text(widget.confirmLabel),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sideBySide = constraints.maxWidth >= 900;

          final searchPane = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: S.current.componentsCommonBookEditorSheetSearchBooks,
                  hintText: S.current.componentsCommonBookEditorSheetTitleAuthorOrSeries,
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _SearchResultsList(
                  searchQuery: _searchQuery,
                  searchAsync: searchAsync,
                  selectedIds: _selectedIds,
                  onSelectionChanged: _toggleSelection,
                ),
              ),
            ],
          );

          final selectedPane = _SelectedBooksPane(
            selectedIds: _selectedIds,
            selectedItemsById: _selectedItemsById,
            onReorder: _reorderSelection,
            onRemove: _removeSelection,
          );

          if (sideBySide) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Row(
                children: [
                  Expanded(child: searchPane),
                  const SizedBox(width: 16),
                  Expanded(child: selectedPane),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              children: [
                Expanded(flex: 3, child: searchPane),
                const SizedBox(height: 12),
                Expanded(flex: 2, child: selectedPane),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({
    required this.searchQuery,
    required this.searchAsync,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  final String searchQuery;
  final AsyncValue<SearchLibrary?> searchAsync;
  final List<String> selectedIds;
  final void Function(LibraryItem item, bool selected) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return Center(
        child: Text(
          S.current.componentsCommonBookEditorSheetSearchBooksToAdd,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    return searchAsync.when(
      data: (searchResult) {
        final candidates = _resolveBookCandidates(searchResult);
        if (candidates.isEmpty) {
          return Center(
            child: Text(
              S.current.componentsCommonBookEditorSheetNoMatchingBooksFound,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          );
        }

        return ListView.builder(
          itemCount: candidates.length,
          itemBuilder: (context, index) {
            final item = candidates[index];
            final selected = selectedIds.contains(item.id);

            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: selected,
              onChanged: (checked) => onSelectionChanged(item, checked ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: _bookItemSubtitle(item) == null
                  ? null
                  : Text(_bookItemSubtitle(item)!, maxLines: 1, overflow: TextOverflow.ellipsis),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return Center(
          child: Text(
            S.current.componentsCommonBookEditorSheetSearchFailedPleaseTryAnotherQuery,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        );
      },
    );
  }
}

class _SelectedBooksPane extends StatelessWidget {
  const _SelectedBooksPane({
    required this.selectedIds,
    required this.selectedItemsById,
    required this.onReorder,
    required this.onRemove,
  });

  final List<String> selectedIds;
  final Map<String, LibraryItem> selectedItemsById;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(String id) onRemove;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.current.componentsCommonBookEditorSheetSelected(selectedIds.length),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: selectedIds.isEmpty
                  ? Center(
                      child: Text(
                        S.current.componentsCommonBookEditorSheetNoBooksSelected,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    )
                  : ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: selectedIds.length,
                      onReorder: onReorder,
                      itemBuilder: (context, index) {
                        final id = selectedIds[index];
                        final item = selectedItemsById[id];

                        return ListTile(
                          key: ValueKey(id),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_indicator_rounded),
                          ),
                          title: Text(item?.title ?? id, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: item == null || _bookItemSubtitle(item) == null
                              ? null
                              : Text(_bookItemSubtitle(item)!, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline_rounded),
                            onPressed: () => onRemove(id),
                          ),
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

List<LibraryItem> _resolveBookCandidates(SearchLibrary? searchResult) {
  final books = searchResult?.book ?? const <SearchLibraryResult>[];
  final deduped = <String, LibraryItem>{};

  for (final result in books) {
    final item = result.libraryItem;
    if (item == null) {
      continue;
    }

    deduped.putIfAbsent(item.id, () => item);
  }

  return deduped.values.toList(growable: false);
}

String? _bookItemSubtitle(LibraryItem item) {
  final subtitle = item.authorString ?? item.subtitle;
  if (subtitle == null || subtitle.isEmpty) {
    return null;
  }

  return subtitle;
}
