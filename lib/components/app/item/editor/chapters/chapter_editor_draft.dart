import 'dart:math' as math;

final _chapterTimePart = RegExp(r'^\d+(?:\.\d+)?$');

typedef ChapterEditorValue = ({double start, String title});

String formatChapterTime(double seconds) {
  if (!seconds.isFinite || seconds < 0) {
    return '';
  }

  final micros = (seconds * 1000000).round();
  final hours = micros ~/ 3600000000;
  final minutes = (micros ~/ 60000000) % 60;
  final wholeSeconds = (micros ~/ 1000000) % 60;
  final fraction = (micros % 1000000).toString().padLeft(6, '0').replaceFirst(RegExp(r'0+$'), '');
  final suffix = fraction.isEmpty ? '' : '.$fraction';
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:'
      '${wholeSeconds.toString().padLeft(2, '0')}$suffix';
}

double? parseChapterTime(String input) {
  final parts = input.trim().split(':');
  if (parts.isEmpty || parts.length > 3) {
    return null;
  }

  var result = 0.0;
  for (var index = 0; index < parts.length; index++) {
    final part = parts[index];
    if (!_chapterTimePart.hasMatch(part)) {
      return null;
    }

    final value = double.tryParse(part);
    if (value == null || !value.isFinite || (index > 0 && value >= 60)) {
      return null;
    }
    if (index < parts.length - 1 && value != value.truncateToDouble()) {
      return null;
    }

    result = result * 60 + value;
  }

  return result.isFinite ? result : null;
}

class ChapterEditorEntry {
  ChapterEditorEntry({required this.key, required this.title, required String startText})
    : originalTitle = title,
      originalStart = parseChapterTime(startText),
      _startText = startText,
      _parsedStart = parseChapterTime(startText);

  final int key;
  final String originalTitle;
  final double? originalStart;
  String title;
  String _startText;
  double? _parsedStart;
  String? error;
  int position = 0;
  bool selected = false;
  void Function()? onChanged;
  void Function()? onRequestTitleFocus;

  String get startText => _startText;
  set startText(String value) {
    _startText = value;
    _parsedStart = parseChapterTime(value);
  }

  double? get start => _parsedStart;
  bool get isDirty => title != originalTitle || start != originalStart;
}

class ChapterEditorDraft {
  ChapterEditorDraft({required this.duration, required List<ChapterEditorValue> chapters}) {
    reset(chapters);
  }

  double duration;
  final List<ChapterEditorEntry> rows = [];
  final Map<int, int> indexByKey = {};
  final Set<int> selectedKeys = {};
  final Set<int> _dirtyKeys = {};
  final Set<int> _invalidKeys = {};
  List<int> _originalKeys = [];
  var _nextKey = 0;
  var _structureDirty = false;
  void Function()? onStatusChanged;
  void Function()? onStructureChanged;
  void Function()? onSelectionChanged;

  bool get hasChanges => _structureDirty || _dirtyKeys.isNotEmpty;
  int get errorCount => _invalidKeys.length;

  void reset(List<ChapterEditorValue> chapters) {
    rows
      ..clear()
      ..addAll(chapters.map(_create));
    selectedKeys.clear();
    _originalKeys = rows.map((row) => row.key).toList(growable: false);
    _reindex();
  }

  ChapterEditorEntry _create(ChapterEditorValue value) {
    return ChapterEditorEntry(key: _nextKey++, title: value.title, startText: formatChapterTime(value.start));
  }

  void editTitle(ChapterEditorEntry row, String value) {
    if (!indexByKey.containsKey(row.key)) {
      return;
    }

    row.title = value;
    _refresh(row.position);
    onStatusChanged?.call();
  }

  void editStart(ChapterEditorEntry row, String value) {
    if (!indexByKey.containsKey(row.key)) {
      return;
    }

    row.startText = value;
    for (var index = row.position - 1; index <= row.position + 1; index++) {
      _refresh(index);
    }
    onStatusChanged?.call();
  }

  void select(ChapterEditorEntry row, bool value) {
    if (!indexByKey.containsKey(row.key)) {
      return;
    }

    row.selected = value;
    if (value) {
      selectedKeys.add(row.key);
    } else {
      selectedKeys.remove(row.key);
    }
    row.onChanged?.call();
    onSelectionChanged?.call();
  }

  void selectAll(bool value, Iterable<ChapterEditorEntry> visibleRows) {
    for (final row in visibleRows) {
      if (!indexByKey.containsKey(row.key)) {
        continue;
      }

      row.selected = value;
      if (value) {
        selectedKeys.add(row.key);
      } else {
        selectedKeys.remove(row.key);
      }
      row.onChanged?.call();
    }
    onSelectionChanged?.call();
  }

  void removeSelected() {
    rows.removeWhere((row) => selectedKeys.contains(row.key));
    selectedKeys.clear();
    _reindex();
  }

  void remove(ChapterEditorEntry row) {
    if (!indexByKey.containsKey(row.key)) {
      return;
    }

    rows.removeAt(row.position);
    selectedKeys.remove(row.key);
    _reindex();
  }

  void insertAfter(ChapterEditorEntry row) {
    if (!indexByKey.containsKey(row.key)) {
      return;
    }

    final start = row.start ?? 0;
    final end = row.position + 1 < rows.length ? rows[row.position + 1].start ?? duration : duration;
    rows.insert(row.position + 1, _create((start: start + (end - start) / 2, title: 'Chapter ${row.position + 2}')));
    _reindex();
  }

  void add({required String title, required int count, required double start, required double interval}) {
    for (var index = 0; index < count; index++) {
      rows.add(_create((start: start + interval * index, title: title.replaceAll('{n}', '${index + 1}'))));
    }
    rows.sort((left, right) => (left.start ?? 0).compareTo(right.start ?? 0));
    _reindex();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex || oldIndex < 0 || oldIndex >= rows.length || newIndex < 0 || newIndex >= rows.length) {
      return;
    }

    final first = math.min(oldIndex, newIndex);
    final last = math.max(oldIndex, newIndex);
    final starts = [for (var index = first; index <= last; index++) rows[index].startText];
    final moved = rows.removeAt(oldIndex);
    rows.insert(newIndex, moved);
    for (var index = first; index <= last; index++) {
      rows[index].startText = starts[index - first];
    }

    _reindex();
  }

  void replace(List<ChapterEditorValue> chapters) {
    rows
      ..clear()
      ..addAll(chapters.map(_create));
    selectedKeys.clear();
    _reindex();
  }

  void mapTitles(List<String> titles) {
    for (var index = 0; index < math.min(rows.length, titles.length); index++) {
      rows[index].title = titles[index];
    }
    _reindex();
  }

  void shift(double seconds) {
    for (final row in rows) {
      if (selectedKeys.isNotEmpty && !selectedKeys.contains(row.key)) {
        continue;
      }
      if (row.position == 0 && row.start == 0) {
        continue;
      }

      final start = row.start;
      if (start != null) {
        final shifted = start + seconds;
        row.startText = shifted < 0 ? shifted.toString() : formatChapterTime(shifted);
      }
    }
    _reindex();
  }

  List<({int id, double start, double end, String title})> values() {
    if (errorCount > 0) {
      throw StateError('Correct chapter errors before saving.');
    }

    return [
      for (var index = 0; index < rows.length; index++)
        (
          id: index,
          start: rows[index].start!,
          end: index + 1 < rows.length ? rows[index + 1].start! : duration,
          title: rows[index].title.trim(),
        ),
    ];
  }

  void _refresh(int index) {
    if (index < 0 || index >= rows.length) {
      return;
    }

    final row = rows[index];
    final start = row.start;
    final previous = index > 0 ? rows[index - 1].start : null;
    final next = index + 1 < rows.length ? rows[index + 1].start : null;
    String? error;
    if (!duration.isFinite || duration <= 0) {
      error = 'Book duration is unavailable';
    } else if (row.title.trim().isEmpty) {
      error = 'Enter a chapter title';
    } else if (start == null) {
      error = 'Use HH:MM:SS or seconds';
    } else if (index == 0 && start != 0) {
      error = 'The first chapter must start at zero';
    } else if (start < 0 || start >= duration) {
      error = 'Start must be within the book';
    } else if ((previous != null && start <= previous) || (next != null && start >= next)) {
      error = 'Starts must be in ascending order';
    }

    row.error = error;
    if (error != null) {
      _invalidKeys.add(row.key);
    } else {
      _invalidKeys.remove(row.key);
    }
    if (row.isDirty) {
      _dirtyKeys.add(row.key);
    } else {
      _dirtyKeys.remove(row.key);
    }
    row.onChanged?.call();
  }

  void _reindex() {
    indexByKey.clear();
    _dirtyKeys.clear();
    _invalidKeys.clear();
    for (var index = 0; index < rows.length; index++) {
      rows[index].position = index;
      indexByKey[rows[index].key] = index;
    }
    for (var index = 0; index < rows.length; index++) {
      _refresh(index);
    }

    _structureDirty = rows.length != _originalKeys.length;
    if (!_structureDirty) {
      for (var index = 0; index < rows.length; index++) {
        if (rows[index].key != _originalKeys[index]) {
          _structureDirty = true;
          break;
        }
      }
    }

    onStructureChanged?.call();
    onStatusChanged?.call();
  }
}
