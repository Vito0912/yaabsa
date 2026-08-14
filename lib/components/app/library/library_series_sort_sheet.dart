import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/request/library_series_sort.dart';

class LibrarySeriesSortSheet extends StatelessWidget {
  const LibrarySeriesSortSheet({super.key, required this.activeSort, required this.activeSortDesc});

  final String? activeSort;
  final int? activeSortDesc;

  @override
  Widget build(BuildContext context) {
    final currentSelection = resolveLibrarySeriesSortSelection(activeSort: activeSort, activeDesc: activeSortDesc);
    final selectedSort = LibrarySeriesSortValueX.tryParse(currentSelection.sort);
    final listHeight = (librarySeriesSortOptions.length * 48.0).clamp(180.0, 360.0).toDouble();
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
                    child: Text('Sort Series', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
                itemCount: librarySeriesSortOptions.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final option = librarySeriesSortOptions[index];
                  final isSelected = option == selectedSort;
                  final isDescending = currentSelection.desc == 1;

                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    title: Text(option.displayName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          Text(
                            isDescending ? 'DESC' : 'ASC',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isDescending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Icon(Icons.check_rounded, size: 18, color: colorScheme.primary),
                        ],
                      ],
                    ),
                    onTap: () {
                      final nextDesc = isSelected
                          ? (currentSelection.desc == 1 ? 0 : 1)
                          : (option.defaultsToAscending ? 0 : 1);
                      final nextSelection = LibrarySeriesSortSelection(sort: option.wireValue, desc: nextDesc);
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
}
