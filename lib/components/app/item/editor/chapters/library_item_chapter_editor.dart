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
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
  var _quickMatching = false;
  var _conflict = false;
  var _confirmingLeave = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _savedChapters = widget.item.media?.bookMedia?.chapters ?? const [];
    _files = chapterEditorAudioFiles(widget.item);
    final duration = chapterEditorDuration(widget.item, _files);
    _draft = ChapterEditorDraft(duration: duration, chapters: chapterEditorValues(_savedChapters));
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
    if (_saving || _quickMatching || identical(oldWidget.item, widget.item)) {
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
      _draft.reset(chapterEditorValues(chapters));
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

  void _updateStatus() {
    if (_preview.activeKey.value != null) {
      unawaited(stopPreview());
    }
    _status.value++;
  }

  void _refreshVisible() {
    _visible = filterChapterEditorRows(_draft.rows, _search.text);
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
    if (_saving || _quickMatching || _confirmingLeave) {
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

  void _setConnectionUnavailable() {
    setState(() {
      _message = context.l10n.errorConnectionUnavailable;
    });
  }

  Future<bool> _save() async {
    if (_saving || !_draft.hasChanges || _draft.errorCount > 0 || _conflict) {
      return false;
    }
    final api = ref.read(absApiProvider);
    if (api == null) {
      _setConnectionUnavailable();
      return false;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    final l10n = context.l10n;
    setState(() {
      _saving = true;
      _message = null;
    });

    try {
      await stopPreview();
      final outcome = await persistChapterEditorDraft(
        api: api,
        itemId: widget.item.id,
        baseline: _savedChapters,
        duration: _draft.duration,
        draft: _draft,
        cancelToken: _cancelToken,
        l10n: l10n,
      );
      if (!mounted) {
        return false;
      }

      if (outcome.updated != null && outcome.savedChapters != null) {
        _savedChapters = outcome.savedChapters!;
        _draft.reset(chapterEditorValues(_savedChapters));
        await processLibraryItemUpdate(
          container: ref.container,
          item: outcome.updated!,
          source: 'editor.chapters.save',
        );
        await widget.onSaved(outcome.updated!);
        if (mounted) {
          setState(() {
            _message = outcome.message;
          });
        }
        return true;
      }

      if (!_cancelToken.isCancelled || outcome.conflict) {
        setState(() {
          _conflict = outcome.conflict;
          _message = outcome.message;
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

  Future<void> _fromTracks() async {
    final confirmed = await showChapterReplaceDialog(context, context.l10n.confirmCreateChaptersFromTracks);
    if (!mounted || !confirmed) {
      return;
    }

    await stopPreview();
    if (mounted) {
      _draft.replace(chapterEditorValuesFromTracks(_files));
    }
  }

  Future<bool> _confirmAndStopPreview(String title) async {
    if (_draft.hasChanges && !await showChapterReplaceDialog(context, title)) {
      return false;
    }
    if (!mounted) {
      return false;
    }

    await stopPreview();
    return mounted;
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
    if (!await _confirmAndStopPreview(context.l10n.confirmReplaceUnsavedChapterEdits)) {
      return;
    }

    if (choice.titlesOnly) {
      _draft.mapTitles(choice.chapters.map((chapter) => chapter.title).toList(growable: false));
    } else {
      _draft.replace(choice.chapters);
    }
  }

  Future<void> _applyServerItem(LibraryItem fresh, {required String source}) async {
    _files = chapterEditorAudioFiles(fresh);
    _draft.duration = chapterEditorDuration(fresh, _files);
    _savedChapters = fresh.media?.bookMedia?.chapters ?? const [];
    _draft.reset(chapterEditorValues(_savedChapters));
    _conflict = false;
    _message = null;
    await processLibraryItemUpdate(container: ref.container, item: fresh, source: source);
    await widget.onSaved(fresh);
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _quickMatch() async {
    if (_saving || _quickMatching) {
      return;
    }
    final l10n = context.l10n;
    if (!await _confirmAndStopPreview(l10n.confirmReplaceUnsavedChapterEdits)) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _setConnectionUnavailable();
      return;
    }

    setState(() {
      _quickMatching = true;
      _message = null;
    });

    final outcome = await runChapterEditorQuickMatch(
      api: api,
      itemId: widget.item.id,
      l10n: l10n,
      cancelToken: _cancelToken,
    );
    if (!mounted) {
      return;
    }
    if (outcome.refreshedItem != null) {
      await _applyServerItem(outcome.refreshedItem!, source: 'editor.chapters.quickMatch');
      if (!mounted) {
        return;
      }
    }
    if (!outcome.isError || !_cancelToken.isCancelled) {
      _showSnackBar(outcome.feedback);
    }

    setState(() {
      _quickMatching = false;
    });
  }

  Future<void> _reset() async {
    final confirmed = await showChapterDiscardDialog(context);
    if (!mounted || !confirmed) {
      return;
    }

    await stopPreview();
    if (!mounted) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _setConnectionUnavailable();
      return;
    }

    setState(() {
      _saving = true;
    });

    final outcome = await reloadChapterEditorItem(
      api: api,
      itemId: widget.item.id,
      cancelToken: _cancelToken,
      l10n: context.l10n,
    );
    if (!mounted) {
      return;
    }

    if (outcome.item != null) {
      await _applyServerItem(outcome.item!, source: 'editor.chapters.reload');
    } else if (!_cancelToken.isCancelled) {
      _message = outcome.error;
    }

    if (mounted) {
      setState(() {
        _saving = false;
      });
    }
  }

  Future<void> _play(ChapterEditorEntry row) async {
    final ok = await _preview.playEntry(
      row: row,
      draft: _draft,
      itemId: widget.item.id,
      files: _files,
      api: ref.read(absApiProvider),
    );
    if (!ok && mounted) {
      setState(() {
        _message = context.l10n.errorChapterPreviewUnavailable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final rowHeight = (mobile ? 128.0 : 64.0) * (scale < 1 ? 1 : scale);
    final busy = _saving || _quickMatching;
    final currentUser = ref.watch(currentUserProvider).value;
    final quickMatchEnabled = watchSettingDefinition(
      ref,
      AppSettingDefs.toolsMatchAudiobookChapters,
      userId: currentUser?.id,
    );

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
            enabled: !busy,
            onAdd: () => unawaited(_add()),
            onLookup: () => unawaited(_lookup()),
            onShift: () => unawaited(_shift()),
            onFromTracks: _files.isEmpty ? null : () => unawaited(_fromTracks()),
            onQuickMatch: quickMatchEnabled ? () => unawaited(_quickMatch()) : null,
            onRemoveSelected: () {
              unawaited(stopPreview());
              FocusManager.instance.primaryFocus?.unfocus();
              _draft.removeSelected();
            },
          ),
          if (busy) const YaabsaLinearProgressIndicator(),
          if (_conflict) const ChapterEditorConflictBanner(),
          Expanded(
            child: ChapterEditorList(
              controller: _scroll,
              draft: _draft,
              rows: _visible,
              indexByKey: _visibleIndex,
              rowHeight: rowHeight,
              mobile: mobile,
              enabled: !busy,
              canReorder: _search.text.trim().isEmpty && _visible.length == _draft.rows.length,
              activePreview: _preview.activeKey,
              onPreview: (row) => unawaited(_play(row)),
              onNextTitle: (row) => unawaited(
                focusNextChapterEditorTitle(
                  scrollController: _scroll,
                  visibleRows: _visible,
                  indexByKey: _visibleIndex,
                  row: row,
                  rowHeight: rowHeight,
                  isMounted: () => mounted,
                ),
              ),
              onReorderStart: () => unawaited(stopPreview()),
              onReorder: (oldIndex, newIndex) {
                if (!busy && _search.text.trim().isEmpty && _visible.length == _draft.rows.length) {
                  _draft.reorder(oldIndex, newIndex);
                }
              },
            ),
          ),
          ChapterEditorFooter(
            draft: _draft,
            status: _status,
            saving: busy,
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
