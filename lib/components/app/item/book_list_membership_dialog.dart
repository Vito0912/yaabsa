import 'dart:async';

import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/paged_list_footer.dart';

class BookListMembershipDialog<T> extends StatefulWidget {
  const BookListMembershipDialog({
    super.key,
    required this.entries,
    required this.allowed,
    required this.plural,
    required this.bookTitle,
    required this.id,
    required this.name,
    required this.membership,
    required this.disabledReason,
    required this.onReload,
    required this.onSave,
    this.confirmSave,
    this.hasNextPage = false,
    this.isLoadingNextPage = false,
    this.nextPageError,
    this.onLoadMore,
    this.sameRevision,
    this.canRetryEntry,
  });

  final AsyncValue<List<T>> entries;
  final bool allowed;
  final String plural;
  final String bookTitle;
  final String Function(T) id;
  final String Function(T) name;
  final bool? Function(T) membership;
  final String? Function(T) disabledReason;
  final Future<void> Function() onReload;
  final Future<void> Function(List<T>, Set<String>) onSave;
  final Future<bool> Function(List<T>, Set<String>)? confirmSave;
  final bool hasNextPage;
  final bool isLoadingNextPage;
  final Object? nextPageError;
  final Future<void> Function()? onLoadMore;
  final bool Function(T original, T current)? sameRevision;
  final bool Function(T entry)? canRetryEntry;

  @override
  State<BookListMembershipDialog<T>> createState() => _BookListMembershipDialogState<T>();
}

class _BookListMembershipDialogState<T> extends State<BookListMembershipDialog<T>> {
  List<T>? _original;
  List<T>? _lastData;
  final Map<String, T> _displayEntries = {};
  final Set<String> _conflictedIds = {};
  final Map<String, bool?> _memberships = {};
  Set<String> _selected = {};
  Set<String> _initialSelected = {};
  bool _saving = false;
  bool _reloading = false;
  String? _error;

  void _reconcileEntries(List<T> entries) {
    final originalById = {for (final entry in _original!) widget.id(entry): entry};
    final nextOriginal = <T>[];
    final incomingIds = <String>{};
    _conflictedIds.clear();

    for (final entry in entries) {
      final id = widget.id(entry);
      if (!incomingIds.add(id)) {
        continue;
      }

      final previous = originalById[id];
      final edited = previous != null && _selected.contains(id) != _initialSelected.contains(id);
      _displayEntries[id] = entry;
      final membership = widget.membership(entry);
      _memberships[id] = membership;

      if (edited) {
        nextOriginal.add(previous);
        final sameRevision = widget.sameRevision?.call(previous, entry) ?? previous == entry;
        if (!sameRevision) {
          _conflictedIds.add(id);
        }
        continue;
      }

      nextOriginal.add(entry);
      if (membership == true) {
        _initialSelected.add(id);
        _selected.add(id);
      } else {
        _initialSelected.remove(id);
        _selected.remove(id);
      }
    }

    for (final entry in _original!) {
      final id = widget.id(entry);
      if (incomingIds.contains(id)) {
        continue;
      }

      if (_selected.contains(id) != _initialSelected.contains(id)) {
        nextOriginal.add(entry);
        _conflictedIds.add(id);
      } else {
        _displayEntries.remove(id);
        _memberships.remove(id);
        _selected.remove(id);
        _initialSelected.remove(id);
      }
    }

    _original = nextOriginal;
    _lastData = entries;
  }

  Future<void> _reload() async {
    setState(() {
      _reloading = true;
      _error = null;
    });
    try {
      await widget.onReload();
    } finally {
      if (mounted) {
        setState(() {
          _original = null;
          _reloading = false;
        });
      }
    }
  }

  void _reviewUpdates() {
    final latest = {for (final entry in _lastData ?? <T>[]) widget.id(entry): entry};
    setState(() {
      _original = _original!
          .where((entry) {
            final id = widget.id(entry);
            if (!_conflictedIds.contains(id) || latest.containsKey(id)) {
              return true;
            }

            _selected.remove(id);
            _initialSelected.remove(id);
            _displayEntries.remove(id);
            _memberships.remove(id);
            return false;
          })
          .map((entry) {
            final id = widget.id(entry);
            if (!_conflictedIds.contains(id)) {
              return entry;
            }

            final current = latest[id] as T;
            final membership = widget.membership(current);
            if (membership == true) {
              _initialSelected.add(id);
            } else {
              _initialSelected.remove(id);
            }
            if (membership == null || widget.disabledReason(current) != null) {
              if (membership == true) {
                _selected.add(id);
              } else {
                _selected.remove(id);
              }
            }

            return current;
          })
          .toList(growable: false);
      _conflictedIds.clear();
      _error = null;
    });
  }

  Future<void> _save() async {
    final original = List<T>.of(_original!);
    final selected = Set.of(_selected);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (widget.confirmSave != null && !await widget.confirmSave!(original, selected)) {
        return;
      }
      if (!mounted) {
        return;
      }

      await widget.onSave(original, selected);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          // Reload selections from confirmed state after conflicts or partial saves.
          _original = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  void _loadMore() {
    final load = widget.onLoadMore;
    if (load != null && !_saving && !_reloading && !widget.isLoadingNextPage) {
      unawaited(load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = widget.entries;
    final allowed = widget.allowed;
    final data = async.value;
    final loading = _reloading || async.isLoading;
    final loadFailed = async.hasError;
    if (_original == null && data != null && !loading && !loadFailed) {
      _original = [];
      _displayEntries.clear();
      _conflictedIds.clear();
      _memberships.clear();
      _initialSelected = {};
      _selected = {};
      _reconcileEntries(data);
    } else if (_original != null &&
        data != null &&
        !identical(data, _lastData) &&
        !loading &&
        !loadFailed &&
        !_saving) {
      _reconcileEntries(data);
    }
    final hasChanges = !setEquals(_initialSelected, _selected);

    Widget content;
    if (loading && _original == null) {
      content = const Center(child: CircularProgressIndicator());
    } else if (loadFailed || data == null) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Could not load ${widget.plural}.'),
            TextButton(onPressed: _saving ? null : _reload, child: const Text('Retry')),
          ],
        ),
      );
    } else if (_original!.isEmpty && !widget.hasNextPage) {
      content = Center(child: Text('No ${widget.plural} found in this library.'));
    } else {
      content = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 &&
              notification.metrics.extentAfter < 240 &&
              widget.hasNextPage &&
              widget.nextPageError == null) {
            _loadMore();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _original!.length + (widget.hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _original!.length) {
              return PagedListFooter(
                loading: widget.isLoadingNextPage,
                error: widget.nextPageError,
                onLoadMore: _loadMore,
              );
            }
            final original = _original![index];
            final id = widget.id(original);
            final entry = _displayEntries[id] ?? original;
            final reason = _conflictedIds.contains(id)
                ? 'This list changed. Review the updates before saving.'
                : widget.disabledReason(entry);
            final membership = _memberships[id];
            return CheckboxListTile(
              key: ValueKey(id),
              title: Text(widget.name(entry)),
              subtitle: reason == null ? null : Text(reason),
              tristate: membership == null,
              value: membership == null ? null : _selected.contains(id),
              onChanged: !allowed || _saving || loading || reason != null
                  ? null
                  : (selected) {
                      setState(() {
                        if (selected == true) {
                          _selected.add(id);
                        } else {
                          _selected.remove(id);
                        }
                      });
                    },
            );
          },
        ),
      );
    }
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text('Manage ${widget.plural}: ${widget.bookTitle}'),
        content: SizedBox(
          width: 520,
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!allowed) const Text('Editing is not allowed.'),
              if (_conflictedIds.isNotEmpty)
                TextButton(onPressed: _saving || loading ? null : _reviewUpdates, child: const Text('Review updates')),
              if (data?.any((entry) => widget.canRetryEntry?.call(entry) ?? false) ?? false)
                TextButton(
                  onPressed: _saving || loading ? null : _reload,
                  child: const Text('Retry unavailable lists'),
                ),
              if (_error != null)
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ),
                ),
              Expanded(flex: 3, child: content),
              if (_saving) const LinearProgressIndicator(),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: _saving ? null : () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed:
                allowed &&
                    !_saving &&
                    !loading &&
                    !widget.isLoadingNextPage &&
                    !loadFailed &&
                    hasChanges &&
                    _conflictedIds.isEmpty
                ? _save
                : null,
            child: Text(_saving ? 'Saving…' : 'Save changes'),
          ),
        ],
      ),
    );
  }
}
