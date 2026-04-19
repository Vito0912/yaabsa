import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/request/library_sort.dart';

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
    final selectedSort = LibrarySortValueX.tryParse(currentSelection.sort);
    final double listHeight = (options.length * 48.0).clamp(180.0, 360.0).toDouble();
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
                  const Expanded(
                    child: Text('Sort Library', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = option == selectedSort;
                  final isDescending = currentSelection.desc == 1;
                  final isRandom = option == LibrarySortValue.random;
                  final trailingText = isSelected && !isRandom ? (isDescending ? 'DESC' : 'ASC') : null;
                  final trailingIcon = isSelected && !isRandom
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
