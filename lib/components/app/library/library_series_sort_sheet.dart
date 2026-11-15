import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/request/library_series_sort.dart';
import 'package:yaabsa/features/library/widgets/library_sort_option_sheet.dart';

class LibrarySeriesSortSheet extends StatelessWidget {
  const LibrarySeriesSortSheet({super.key, required this.activeSort, required this.activeSortDesc});

  final String? activeSort;
  final int? activeSortDesc;

  @override
  Widget build(BuildContext context) {
    final currentSelection = resolveLibrarySeriesSortSelection(activeSort: activeSort, activeDesc: activeSortDesc);
    final selectedSort = LibrarySeriesSortValueX.tryParse(currentSelection.sort) ?? LibrarySeriesSortValue.name;

    return LibrarySortOptionSheet<LibrarySeriesSortValue>(
      title: 'Sort',
      selectedValue: selectedSort,
      isDescending: currentSelection.isDescending,
      options: librarySeriesSortOptions
          .map((option) => LibrarySortOption<LibrarySeriesSortValue>(value: option, label: option.displayName))
          .toList(growable: false),
      onSelected: (option) {
        final isSelected = option == selectedSort;
        final nextDesc = isSelected ? (currentSelection.desc == 1 ? 0 : 1) : (option.defaultsToAscending ? 0 : 1);
        final nextSelection = LibrarySeriesSortSelection(sort: option.wireValue, desc: nextDesc);
        Navigator.of(context).pop(nextSelection);
      },
    );
  }
}
