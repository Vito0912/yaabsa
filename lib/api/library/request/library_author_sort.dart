const String defaultAuthorSortWireValue = 'name';
const int defaultAuthorSortDesc = 0;

enum LibraryAuthorSortValue { authorFirstLast, authorLastFirst, numBooks, addedAt, updatedAt }

extension LibraryAuthorSortValueX on LibraryAuthorSortValue {
  String get wireValue => switch (this) {
    LibraryAuthorSortValue.authorFirstLast => 'name',
    LibraryAuthorSortValue.authorLastFirst => 'lastFirst',
    LibraryAuthorSortValue.numBooks => 'numBooks',
    LibraryAuthorSortValue.addedAt => 'addedAt',
    LibraryAuthorSortValue.updatedAt => 'updatedAt',
  };

  String get displayName => switch (this) {
    LibraryAuthorSortValue.authorFirstLast => 'Author (First Last)',
    LibraryAuthorSortValue.authorLastFirst => 'Author (Last, First)',
    LibraryAuthorSortValue.numBooks => 'Number of Books',
    LibraryAuthorSortValue.addedAt => 'Added At',
    LibraryAuthorSortValue.updatedAt => 'Updated At',
  };

  bool get defaultsToAscending => switch (this) {
    LibraryAuthorSortValue.authorFirstLast || LibraryAuthorSortValue.authorLastFirst => true,
    _ => false,
  };

  static LibraryAuthorSortValue? tryParse(String raw) {
    for (final value in LibraryAuthorSortValue.values) {
      if (value.wireValue == raw) {
        return value;
      }
    }
    return null;
  }
}

class LibraryAuthorSortSelection {
  const LibraryAuthorSortSelection({required this.sort, required this.desc});

  final String sort;
  final int desc;

  bool get isDescending => desc == 1;
}

const List<LibraryAuthorSortValue> libraryAuthorSortOptions = <LibraryAuthorSortValue>[
  LibraryAuthorSortValue.authorFirstLast,
  LibraryAuthorSortValue.authorLastFirst,
  LibraryAuthorSortValue.numBooks,
  LibraryAuthorSortValue.addedAt,
  LibraryAuthorSortValue.updatedAt,
];

LibraryAuthorSortSelection resolveLibraryAuthorSortSelection({required String? activeSort, required int? activeDesc}) {
  final selectedSort = _resolveSortValue(activeSort);
  return LibraryAuthorSortSelection(sort: selectedSort.wireValue, desc: _resolveSortDesc(activeDesc, selectedSort));
}

String buildLibraryAuthorSortLabel({required String? activeSort, required int? activeDesc}) {
  final selection = resolveLibraryAuthorSortSelection(activeSort: activeSort, activeDesc: activeDesc);
  final sortValue = LibraryAuthorSortValueX.tryParse(selection.sort);
  if (sortValue == null) {
    return selection.sort;
  }

  final directionLabel = selection.isDescending ? 'DESC' : 'ASC';
  return '${sortValue.displayName} ($directionLabel)';
}

LibraryAuthorSortValue _resolveSortValue(String? rawSort) {
  if (rawSort != null) {
    final parsedSort = LibraryAuthorSortValueX.tryParse(rawSort);
    if (parsedSort != null && libraryAuthorSortOptions.contains(parsedSort)) {
      return parsedSort;
    }
  }

  final defaultSort = LibraryAuthorSortValueX.tryParse(defaultAuthorSortWireValue);
  if (defaultSort != null) {
    return defaultSort;
  }

  return libraryAuthorSortOptions.first;
}

int _resolveSortDesc(int? activeDesc, LibraryAuthorSortValue selectedSort) {
  if (activeDesc == 0 || activeDesc == 1) {
    return activeDesc!;
  }

  return selectedSort.defaultsToAscending ? 0 : 1;
}
