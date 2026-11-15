import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/request/library_author_sort.dart';
import 'package:yaabsa/features/library/widgets/library_sort_option_sheet.dart';

class LibraryAuthorSortSheet extends StatelessWidget {
  const LibraryAuthorSortSheet({super.key, required this.activeSort, required this.activeSortDesc});

  final String? activeSort;
  final int? activeSortDesc;

  @override
  Widget build(BuildContext context) {
    final currentSelection = resolveLibraryAuthorSortSelection(activeSort: activeSort, activeDesc: activeSortDesc);
    final selectedSort =
        LibraryAuthorSortValueX.tryParse(currentSelection.sort) ?? LibraryAuthorSortValue.authorFirstLast;

    return LibrarySortOptionSheet<LibraryAuthorSortValue>(
      title: 'Sort',
      selectedValue: selectedSort,
      isDescending: currentSelection.isDescending,
      options: libraryAuthorSortOptions
          .map((option) => LibrarySortOption<LibraryAuthorSortValue>(value: option, label: option.displayName))
          .toList(growable: false),
      onSelected: (option) {
        final nextSelection = _nextSelectionForTap(
          option: option,
          currentSelection: currentSelection,
          isSelected: option == selectedSort,
        );
        Navigator.of(context).pop(nextSelection);
      },
    );
  }

  static LibraryAuthorSortSelection _nextSelectionForTap({
    required LibraryAuthorSortValue option,
    required LibraryAuthorSortSelection currentSelection,
    required bool isSelected,
  }) {
    if (!isSelected) {
      return LibraryAuthorSortSelection(sort: option.wireValue, desc: option.defaultsToAscending ? 0 : 1);
    }

    final nextDesc = currentSelection.desc == 1 ? 0 : 1;
    return LibraryAuthorSortSelection(sort: option.wireValue, desc: nextDesc);
  }
}
