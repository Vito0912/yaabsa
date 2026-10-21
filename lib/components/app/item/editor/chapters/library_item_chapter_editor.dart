import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_draft.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_controls.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_preview.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_persistence.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_list.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_tools.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class LibraryItemChapterEditor extends ConsumerStatefulWidget {
  const LibraryItemChapterEditor({super.key, required this.item, required this.onSaved});

  final LibraryItem item;
  final Future<void> Function(LibraryItem item) onSaved;

  @override
  ConsumerState<LibraryItemChapterEditor> createState() => LibraryItemChapterEditorState();
}

class LibraryItemChapterEditorState extends ConsumerState<LibraryItemChapterEditor> {
  final _scroll = ScrollController();
  final _search = TextEditingController();
  final _status = ValueNotifier<int>(0);
  final _selectionStatus = ValueNotifier<int>(0);
  final _preview = ChapterEditorPreview();
  final _cancelToken = CancelToken();
  late final ChapterEditorDraft _draft;
  late List<Chapter> _savedChapters;
  late List<AudioFile> _files;
  List<ChapterEditorEntry> _visible = [];
  final Map<int, int> _visibleIndex = {};
  Timer? _searchTimer;
  var _saving = false;
  var _conflict = false;
  var _confirmingLeave = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _savedChapters = widget.item.media?.bookMedia?.chapters ?? const [];
    _files = chapterEditorAudioFiles(widget.item);
    final duration = chapterEditorDuration(widget.item, _files);
    _draft = ChapterEditorDraft(duration: duration, chapters: _values(_savedChapters));
    _draft.onStatusChanged = _updateStatus;
    _draft.onSelectionChanged = () {
      _selectionStatus.value++;
    };
    _draft.onStructureChanged = _refreshVisible;
    _refreshVisible();
  }

  @override
  void didUpdateWidget(covariant LibraryItemChapterEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_saving || identical(oldWidget.item, widget.item)) {
      return;
    }
    final chapters = widget.item.media?.bookMedia?.chapters ?? const <Chapter>[];
    _files = chapterEditorAudioFiles(widget.item);
    final duration = chapterEditorDuration(widget.item, _files);
    if (listEquals(chapters, _savedChapters) && duration == _draft.duration) {
      return;
    }
    if (_draft.hasChanges) {
      _conflict = true;
    } else {
      _savedChapters = chapters;
      _draft.duration = duration;
      _draft.reset(_values(chapters));
    }
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _searchTimer?.cancel();
    _draft.onStatusChanged = null;
    _draft.onSelectionChanged = null;
    _draft.onStructureChanged = null;
    _preview.dispose();
    _scroll.dispose();
    _search.dispose();
    _status.dispose();
    _selectionStatus.dispose();
    super.dispose();
  }

  List<ChapterEditorValue> _values(List<Chapter> chapters) {
    return chapters.map((chapter) => (start: chapter.start, title: chapter.title)).toList(growable: false);
  }

  void _updateStatus() {
    if (_preview.activeKey.value != null) {
      unawaited(stopPreview());
    }
    _status.value++;
  }

  void _refreshVisible() {
    final query = _search.text.trim().toLowerCase();
    _visible = query.isEmpty
        ? List.of(_draft.rows)
        : _draft.rows
              .where((row) {
                return row.title.toLowerCase().contains(query) || '${row.position + 1}' == query;
              })
              .toList(growable: false);
    _visibleIndex
      ..clear()
      ..addEntries(_visible.indexed.map((entry) => MapEntry(entry.$2.key, entry.$1)));
    setState(() {});
  }

  void _searchChanged(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 180), _refreshVisible);
  }

  Future<void> stopPreview() => _preview.stop();

  Future<bool> requestLeave() async {
    if (_saving || _confirmingLeave) {
      return false;
    }
    if (!_draft.hasChanges) {
      await stopPreview();
      return true;
    }

    _confirmingLeave = true;
    final choice = await showChapterUnsavedDialog(context);
    _confirmingLeave = false;
    if (!mounted) {
      return false;
    }
    if (choice == 'save') {
      return _save();
    }
    if (choice == 'discard') {
      await stopPreview();
      return true;
    }

    return false;
  }

  Future<bool> _save() async {
    if (_saving || !_draft.hasChanges || _draft.errorCount > 0 || _conflict) {
      return false;
    }
    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _message = 'No server connection available.';
      });
      return false;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    final chapters = _draft
        .values()
        .map((value) {
          return Chapter(id: value.id, start: value.start, end: value.end, title: value.title);
        })
        .toList(growable: false);
    setState(() {
      _saving = true;
      _message = null;
    });

    try {
      await stopPreview();
      final updated = await saveChapterEditorDraft(
        api: api,
        itemId: widget.item.id,
        baseline: _savedChapters,
        duration: _draft.duration,
        chapters: chapters,
        cancelToken: _cancelToken,
      );
      if (!mounted) {
        return false;
      }
      _savedChapters = chapters;
      _draft.reset(_values(chapters));
      await processLibraryItemUpdate(container: ref.container, item: updated, source: 'editor.chapters.save');
      await widget.onSaved(updated);
      if (mounted) {
        setState(() {
          _message = 'Chapters saved.';
        });
      }
      return true;
    } on ChapterEditorConflict {
      if (mounted) {
        setState(() {
          _conflict = true;
          _message = 'Chapters or audio tracks changed on the server. Reload before saving.';
        });
      }
      return false;
    } catch (error) {
      if (mounted && !_cancelToken.isCancelled) {
        setState(() {
          _message = listManagementErrorMessage(error, fallback: 'Could not save chapters. $error');
        });
      }
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _add() async {
    final lastStart = _draft.rows.lastOrNull?.start ?? -60;
    final options = await showChapterAddDialog(context, initialStart: lastStart + 60);
    if (!mounted || options == null) {
      return;
    }
    await stopPreview();
    if (!mounted) {
      return;
    }
    _draft.add(title: options.title, count: options.count, start: options.start, interval: options.interval);
  }

  Future<void> _shift() async {
    final amount = await showChapterShiftDialog(context, selectedCount: _draft.selectedKeys.length);
    if (!mounted || amount == null) {
      return;
    }
    await stopPreview();
    if (mounted) {
      _draft.shift(amount);
    }
  }

  Future<bool> _confirmReplace(String title) {
    return showListManagementDeleteDialog(
      context: context,
      title: title,
      message: 'This replaces the current chapter draft. Changes take effect when you save.',
      confirmLabel: 'Replace',
    );
  }

  Future<void> _fromTracks() async {
    final confirmed = await _confirmReplace('Create chapters from audio tracks?');
    if (!mounted || !confirmed) {
      return;
    }
    await stopPreview();
    if (!mounted) {
      return;
    }
    var offset = 0.0;
    final chapters = <ChapterEditorValue>[];
    for (final file in _files) {
      final duration = file.duration ?? 0;
      if (duration <= 0 || !duration.isFinite) {
        continue;
      }
      final title = file.metadata.filename.replaceFirst(RegExp(r'\.[^.]+$'), '');
      chapters.add((start: offset, title: title));
      offset += duration;
    }
    _draft.replace(chapters);
  }

  Future<void> _lookup() async {
    final choice = await showChapterLookupDialog(
      context,
      asin: widget.item.media?.bookMedia?.metadata.asin ?? '',
      chapterCount: _draft.rows.length,
      duration: _draft.duration,
    );
    if (!mounted || choice == null) {
      return;
    }
    if (_draft.hasChanges && !await _confirmReplace('Replace unsaved chapter edits?')) {
      return;
    }
    if (!mounted) {
      return;
    }
    await stopPreview();
    if (!mounted) {
      return;
    }
    if (choice.titlesOnly) {
      _draft.mapTitles(choice.chapters.map((chapter) => chapter.title).toList(growable: false));
    } else {
      _draft.replace(choice.chapters);
    }
  }

  Future<void> _reset() async {
    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Discard chapter edits?',
      message: 'Restore the chapters currently stored on the server.',
      confirmLabel: 'Discard edits',
    );
    if (!mounted || !confirmed) {
      return;
    }
    await stopPreview();
    if (!mounted) {
      return;
    }
    final api = ref.read(absApiProvider);
    setState(() {
      _saving = true;
    });
    try {
      if (api == null) {
        throw StateError('No server connection available.');
      }
      final fresh = await loadChapterEditorItem(api: api, itemId: widget.item.id, cancelToken: _cancelToken);
      if (!mounted) {
        return;
      }
      _files = chapterEditorAudioFiles(fresh);
      _draft.duration = chapterEditorDuration(fresh, _files);
      _savedChapters = fresh.media?.bookMedia?.chapters ?? const [];
      _draft.reset(_values(_savedChapters));
      _conflict = false;
      _message = null;
      await processLibraryItemUpdate(container: ref.container, item: fresh, source: 'editor.chapters.reload');
      await widget.onSaved(fresh);
    } catch (error) {
      if (mounted && !_cancelToken.isCancelled) {
        _message = listManagementErrorMessage(error, fallback: 'Could not reload chapters. $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _play(ChapterEditorEntry row) async {
    final api = ref.read(absApiProvider);
    final start = row.start;
    if (api == null || start == null || row.error != null) {
      return;
    }
    final end = row.position + 1 < _draft.rows.length ? _draft.rows[row.position + 1].start : _draft.duration;
    if (end == null) {
      return;
    }
    try {
      await _preview.play(key: row.key, start: start, end: end, itemId: widget.item.id, files: _files, api: api);
    } catch (error) {
      if (mounted) {
        setState(() {
          _message = 'Could not preview this chapter.';
        });
      }
    }
  }

  Future<void> _focusNextTitle(ChapterEditorEntry row, double rowHeight) async {
    final next = (_visibleIndex[row.key] ?? -1) + 1;
    if (next >= _visible.length || !_scroll.hasClients) {
      return;
    }
    final target = _visible[next];
    final position = _scroll.position;
    final top = next * rowHeight;
    if (top < position.pixels || top + rowHeight > position.pixels + position.viewportDimension) {
      await _scroll.animateTo(
        top.clamp(0, position.maxScrollExtent),
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    }
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) {
      target.onRequestTitleFocus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final rowHeight = (mobile ? 128.0 : 64.0) * (scale < 1 ? 1 : scale);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): () => unawaited(_save()),
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true): () => unawaited(_save()),
      },
      child: Column(
        children: [
          ChapterEditorToolbar(
            draft: _draft,
            status: _selectionStatus,
            search: _search,
            onSearchChanged: _searchChanged,
            visibleRows: _visible,
            enabled: !_saving,
            onAdd: () => unawaited(_add()),
            onLookup: () => unawaited(_lookup()),
            onShift: () => unawaited(_shift()),
            onFromTracks: _files.isEmpty ? null : () => unawaited(_fromTracks()),
            onRemoveSelected: () {
              unawaited(stopPreview());
              FocusManager.instance.primaryFocus?.unfocus();
              _draft.removeSelected();
            },
          ),
          if (_saving) const LinearProgressIndicator(),
          if (_conflict)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Chapters changed on the server. Discard edits to reload them.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: ChapterEditorList(
              controller: _scroll,
              draft: _draft,
              rows: _visible,
              indexByKey: _visibleIndex,
              rowHeight: rowHeight,
              mobile: mobile,
              enabled: !_saving,
              canReorder: _search.text.trim().isEmpty && _visible.length == _draft.rows.length,
              activePreview: _preview.activeKey,
              onPreview: (row) => unawaited(_play(row)),
              onNextTitle: (row) => unawaited(_focusNextTitle(row, rowHeight)),
              onReorderStart: () => unawaited(stopPreview()),
              onReorder: (oldIndex, newIndex) {
                if (!_saving && _search.text.trim().isEmpty && _visible.length == _draft.rows.length) {
                  _draft.reorder(oldIndex, newIndex);
                }
              },
            ),
          ),
          ChapterEditorFooter(
            draft: _draft,
            status: _status,
            saving: _saving,
            conflict: _conflict,
            message: _message,
            onReset: () => unawaited(_reset()),
            onSave: () => unawaited(_save()),
          ),
        ],
      ),
    );
  }
}
