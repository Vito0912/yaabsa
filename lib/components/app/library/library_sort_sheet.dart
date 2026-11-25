import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';
import 'package:yaabsa/features/library/widgets/library_sort_option_sheet.dart';
import 'package:yaabsa/util/l10n.dart';

class LibrarySortSheet extends StatelessWidget {
  const LibrarySortSheet({
    super.key,
    required this.libraryMediaType,
    required this.activeFilter,
    required this.activeSort,
    required this.activeSortDesc,
  });

  final String libraryMediaType;
  final String? activeFilter;
  final String? activeSort;
  final int? activeSortDesc;

  @override
  Widget build(BuildContext context) {
    final options = getLibrarySortOptions(libraryMediaType: libraryMediaType, activeFilter: activeFilter);
    final currentSelection = resolveLibrarySortSelection(
      libraryMediaType: libraryMediaType,
      activeFilter: activeFilter,
      activeSort: activeSort,
      activeDesc: activeSortDesc,
    );
    final selectedSort = LibrarySortValueX.tryParse(currentSelection.sort) ?? LibrarySortValue.addedAt;

    return LibrarySortOptionSheet<LibrarySortValue>(
      title: context.l10n.actionSort,
      selectedValue: selectedSort,
      isDescending: currentSelection.isDescending,
      options: options
          .map(
            (option) => LibrarySortOption<LibrarySortValue>(
              value: option,
              label: option.displayName,
              supportsDirection: option != LibrarySortValue.random,
            ),
          )
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

  static LibrarySortSelection _nextSelectionForTap({
    required LibrarySortValue option,
    required LibrarySortSelection currentSelection,
    required bool isSelected,
  }) {
    if (option == LibrarySortValue.random) {
      return LibrarySortSelection(sort: option.wireValue, desc: 1);
    }

    if (!isSelected) {
      return LibrarySortSelection(sort: option.wireValue, desc: 1);
    }

    final nextDesc = currentSelection.desc == 1 ? 0 : 1;
    return LibrarySortSelection(sort: option.wireValue, desc: nextDesc);
  }
}
