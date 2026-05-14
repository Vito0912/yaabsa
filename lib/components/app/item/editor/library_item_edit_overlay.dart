import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_models.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_form.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class LibraryItemEditOverlay extends ConsumerStatefulWidget {
  const LibraryItemEditOverlay({
    super.key,
    required this.orderedItemIds,
    required this.currentItemId,
    required this.onSelectItem,
    required this.onClose,
    required this.onItemSaved,
    this.filterData,
  });

  final List<String> orderedItemIds;
  final String currentItemId;
  final ValueChanged<String> onSelectItem;
  final VoidCallback onClose;
  final Future<void> Function(String itemId, LibraryItem? updatedItem) onItemSaved;
  final LibraryFilterData? filterData;

  @override
  ConsumerState<LibraryItemEditOverlay> createState() => _LibraryItemEditOverlayState();
}

class _LibraryItemEditOverlayState extends ConsumerState<LibraryItemEditOverlay> {
  var _isSaving = false;
  final Map<String, LibraryItem> _cachedItems = <String, LibraryItem>{};

  int get _currentIndex => widget.orderedItemIds.indexOf(widget.currentItemId);

  bool get _hasPrevious => _currentIndex > 0;
  bool get _hasNext => _currentIndex >= 0 && _currentIndex < widget.orderedItemIds.length - 1;

  @override
  void initState() {
    super.initState();
    _preloadAdjacentItems();
  }

  @override
  void didUpdateWidget(covariant LibraryItemEditOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentItemId != widget.currentItemId) {
      _preloadAdjacentItems();
    }
  }

  void _preloadAdjacentItems() {
    unawaited(_preloadItem(widget.currentItemId));

    if (_hasPrevious) {
      final previousId = widget.orderedItemIds[_currentIndex - 1];
      unawaited(_preloadItem(previousId));
    }

    if (_hasNext) {
      final nextId = widget.orderedItemIds[_currentIndex + 1];
      unawaited(_preloadItem(nextId));
    }
  }

  Future<void> _preloadItem(String itemId) async {
    try {
      final item = await ref.read(libraryItemProvider(itemId).future);
      if (!mounted) {
        return;
      }

      setState(() {
        _cachedItems[itemId] = item;
      });
    } catch (_) {}
  }

  Future<void> _saveChanges(LibraryItemEditorDiff diff) async {
    if (_isSaving) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No server connection available.')));
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await api.getLibraryItemApi().updateLibraryItemMedia(
        widget.currentItemId,
        request: diff.request,
      );
      final payload = response.data;

      if (payload == null || !payload.updated) {
        throw Exception('Update request failed.');
      }

      final updatedItem = payload.libraryItem;
      if (updatedItem != null) {
        _cachedItems[widget.currentItemId] = updatedItem;
        await processLibraryItemUpdate(container: ref.container, item: updatedItem, source: 'editor.save');
      } else {
        invalidateLibraryItemConsumers(container: ref.container, itemId: widget.currentItemId);
      }
      await widget.onItemSaved(widget.currentItemId, updatedItem);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved item details.')));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(error, fallback: 'Could not save item details.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchedItemAsync = ref.watch(libraryItemProvider(widget.currentItemId));
    final watchedItem = watchedItemAsync.asData?.value;
    if (watchedItem != null) {
      _cachedItems[widget.currentItemId] = watchedItem;
    }

    final cachedItem = _cachedItems[widget.currentItemId];
    final itemAsync = cachedItem != null ? AsyncValue.data(cachedItem) : watchedItemAsync;

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.52),
        child: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: widget.onClose,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = context.isDesktop
                    ? constraints.maxWidth * 0.88
                    : context.isTablet
                    ? constraints.maxWidth * 0.94
                    : constraints.maxWidth;
                final maxHeight = context.isDesktop ? constraints.maxHeight * 0.9 : constraints.maxHeight;

                return Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(context.isMobile ? 18 : 24),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.8),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildHeader(context, itemAsync),
                              Expanded(
                                child: itemAsync.when(
                                  data: (item) => LibraryItemEditorForm(
                                    key: ValueKey(item.id),
                                    item: item,
                                    filterData: widget.filterData,
                                    isSaving: _isSaving,
                                    onSave: _saveChanges,
                                    onClose: widget.onClose,
                                  ),
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                  error: (error, _) => Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'Could not load item details for editing.\n$error',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue<LibraryItem> itemAsync) {
    final colorScheme = Theme.of(context).colorScheme;
    final showNavigation = widget.orderedItemIds.length > 1;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
      padding: const EdgeInsets.fromLTRB(20, 4, 12, 4),
      child: Row(
        children: [
          if (showNavigation)
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton.filledTonal(
                onPressed: _hasPrevious ? () => widget.onSelectItem(widget.orderedItemIds[_currentIndex - 1]) : null,
                tooltip: 'Previous item',
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
              ),
            ),
          if (showNavigation) const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit item',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.onPrimaryContainer),
                ),
              ],
            ),
          ),
          if (showNavigation) const SizedBox(width: 8),
          if (showNavigation)
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton.filledTonal(
                onPressed: _hasNext ? () => widget.onSelectItem(widget.orderedItemIds[_currentIndex + 1]) : null,
                tooltip: 'Next item',
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              ),
            ),
          if (showNavigation) const SizedBox(width: 8),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              onPressed: widget.onClose,
              tooltip: 'Close editor',
              icon: const Icon(Icons.close_rounded, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
