import 'package:material_ui/material_ui.dart';

import 'library_control_sheet.dart';

class LibrarySortOption<T> {
  const LibrarySortOption({required this.value, required this.label, this.supportsDirection = true});

  final T value;
  final String label;
  final bool supportsDirection;
}

class LibrarySortOptionSheet<T> extends StatelessWidget {
  const LibrarySortOptionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.isDescending,
    required this.onSelected,
  });

  final String title;
  final List<LibrarySortOption<T>> options;
  final T selectedValue;
  final bool isDescending;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return LibraryControlSheet(
      title: title,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
        itemCount: options.length,
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option.value == selectedValue;

          return _SortOptionTile<T>(
            option: option,
            isSelected: isSelected,
            isDescending: isDescending,
            onTap: () => onSelected(option.value),
          );
        },
      ),
    );
  }
}

class _SortOptionTile<T> extends StatelessWidget {
  const _SortOptionTile({
    required this.option,
    required this.isSelected,
    required this.isDescending,
    required this.onTap,
  });

  final LibrarySortOption<T> option;
  final bool isSelected;
  final bool isDescending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isSelected ? colorScheme.secondaryContainer : colorScheme.surfaceContainerLow;
    final borderColor = isSelected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.4);

    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: isSelected ? 1.25 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isSelected ? colorScheme.onSecondaryContainer : colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected && option.supportsDirection) ...[
                const SizedBox(width: 8),
                _SortDirectionIndicator(isDescending: isDescending),
              ],
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SortDirectionIndicator extends StatelessWidget {
  const _SortDirectionIndicator({required this.isDescending});

  final bool isDescending;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = isDescending ? 'DESC' : 'ASC';

    return Semantics(
      label: isDescending ? 'Descending' : 'Ascending',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDescending ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              size: 14,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
