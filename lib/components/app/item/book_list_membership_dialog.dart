import 'package:flutter/foundation.dart' show setEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

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

  @override
  State<BookListMembershipDialog<T>> createState() => _BookListMembershipDialogState<T>();
}

class _BookListMembershipDialogState<T> extends State<BookListMembershipDialog<T>> {
  List<T>? _original;
  Set<String> _selected = {};
  Set<String> _initialSelected = {};
  bool _saving = false;
  bool _reloading = false;
  String? _error;

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

  Future<void> _save() async {
    final selected = Set.of(_selected);
    if (widget.confirmSave != null && !await widget.confirmSave!(_original!, selected)) return;
    if (!mounted) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(_original!, selected);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          // Reload selections from confirmed state after conflicts or partial saves.
          _original = null;
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
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
      _original = List.of(data);
      _initialSelected = {
        for (final entry in _original!)
          if (widget.membership(entry) == true) widget.id(entry),
      };
      _selected = Set.of(_initialSelected);
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
    } else if (_original!.isEmpty) {
      content = Center(child: Text('No ${widget.plural} found in this library.'));
    } else {
      content = ListView.builder(
        itemCount: _original!.length,
        itemBuilder: (context, index) {
          final entry = _original![index];
          final membership = widget.membership(entry);
          final reason = widget.disabledReason(entry);
          final id = widget.id(entry);
          return CheckboxListTile(
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
          TextButton(onPressed: _saving || loading ? null : _reload, child: const Text('Reload')),
          FilledButton(
            onPressed: allowed && !_saving && !loading && !loadFailed && hasChanges ? _save : null,
            child: Text(_saving ? 'Saving…' : 'Save changes'),
          ),
        ],
      ),
    );
  }
}
