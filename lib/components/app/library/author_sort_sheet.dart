import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/request/library_author_sort.dart';

import 'package:yaabsa/generated/l10n.dart';

class LibraryAuthorSortSheet extends StatelessWidget {
  const LibraryAuthorSortSheet({super.key, required this.activeSort, required this.activeSortDesc});

  final String? activeSort;
  final int? activeSortDesc;

  @override
  Widget build(BuildContext context) {
    final currentSelection = resolveLibraryAuthorSortSelection(activeSort: activeSort, activeDesc: activeSortDesc);
    final selectedSort = LibraryAuthorSortValueX.tryParse(currentSelection.sort);
    final double listHeight = (libraryAuthorSortOptions.length * 48.0).clamp(180.0, 360.0).toDouble();
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: listHeight + 54,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.componentsAppLibraryAuthorSortSheetSortAuthors,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    tooltip: S.current.componentsAppLibraryAuthorSortSheetClose,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: libraryAuthorSortOptions.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final option = libraryAuthorSortOptions[index];
                  final isSelected = option == selectedSort;
                  final isDescending = currentSelection.desc == 1;
                  String? trailingText;
                  if (isSelected) {
                    trailingText = 'ASC';
                    if (isDescending) {
                      trailingText = 'DESC';
                    }
                  }
                  final trailingIcon = isSelected
                      ? (isDescending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded)
                      : null;

                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    title: Text(option.displayName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (trailingText != null)
                          Text(
                            trailingText,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        if (trailingIcon != null) ...[
                          const SizedBox(width: 4),
                          Icon(trailingIcon, size: 16, color: colorScheme.onSurfaceVariant),
                        ],
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.check_rounded, size: 18, color: colorScheme.primary),
                        ],
                      ],
                    ),
                    onTap: () {
                      final nextSelection = _nextSelectionForTap(
                        option: option,
                        currentSelection: currentSelection,
                        isSelected: isSelected,
                      );
                      Navigator.of(context).pop(nextSelection);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
