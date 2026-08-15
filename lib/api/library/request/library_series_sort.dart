const String defaultLibrarySeriesSortWireValue = 'name';
const int defaultLibrarySeriesSortDesc = 0;

enum LibrarySeriesSortValue { name, numBooks, totalDuration, addedAt }

extension LibrarySeriesSortValueX on LibrarySeriesSortValue {
  String get wireValue => switch (this) {
    LibrarySeriesSortValue.name => 'name',
    LibrarySeriesSortValue.numBooks => 'numBooks',
    LibrarySeriesSortValue.totalDuration => 'totalDuration',
    LibrarySeriesSortValue.addedAt => 'addedAt',
  };

  String get displayName => switch (this) {
    LibrarySeriesSortValue.name => 'Name',
    LibrarySeriesSortValue.numBooks => 'Number of Books',
    LibrarySeriesSortValue.totalDuration => 'Total Duration',
    LibrarySeriesSortValue.addedAt => 'Added At',
  };

  bool get defaultsToAscending => this == LibrarySeriesSortValue.name;

  static LibrarySeriesSortValue? tryParse(String raw) {
    for (final value in LibrarySeriesSortValue.values) {
      if (value.wireValue == raw) {
        return value;
      }
    }
    return null;
  }
}

class LibrarySeriesSortSelection {
  const LibrarySeriesSortSelection({required this.sort, required this.desc});

  final String sort;
  final int desc;

  bool get isDescending => desc == 1;
}

const List<LibrarySeriesSortValue> librarySeriesSortOptions = <LibrarySeriesSortValue>[
  LibrarySeriesSortValue.name,
  LibrarySeriesSortValue.numBooks,
  LibrarySeriesSortValue.totalDuration,
  LibrarySeriesSortValue.addedAt,
];

LibrarySeriesSortSelection resolveLibrarySeriesSortSelection({required String? activeSort, required int? activeDesc}) {
  final selectedSort = _resolveSortValue(activeSort);
  return LibrarySeriesSortSelection(sort: selectedSort.wireValue, desc: _resolveSortDesc(activeDesc, selectedSort));
}

String buildLibrarySeriesSortLabel({required String? activeSort, required int? activeDesc}) {
  final selection = resolveLibrarySeriesSortSelection(activeSort: activeSort, activeDesc: activeDesc);
  final sortValue = LibrarySeriesSortValueX.tryParse(selection.sort);
  if (sortValue == null) {
    return selection.sort;
  }

  final directionLabel = selection.isDescending ? 'DESC' : 'ASC';
  return '${sortValue.displayName} ($directionLabel)';
}

LibrarySeriesSortValue _resolveSortValue(String? rawSort) {
  final parsed = rawSort == null ? null : LibrarySeriesSortValueX.tryParse(rawSort);
  if (parsed != null && librarySeriesSortOptions.contains(parsed)) {
    return parsed;
  }

  return LibrarySeriesSortValue.name;
}

int _resolveSortDesc(int? activeDesc, LibrarySeriesSortValue selectedSort) {
  if (activeDesc == 0 || activeDesc == 1) {
    return activeDesc!;
  }

  return selectedSort.defaultsToAscending ? 0 : 1;
}
