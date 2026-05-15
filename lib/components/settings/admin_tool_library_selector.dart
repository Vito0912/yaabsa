import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/library.dart';

class AdminToolLibrarySelector extends StatelessWidget {
  const AdminToolLibrarySelector({
    super.key,
    required this.libraries,
    required this.selectedLibraryIds,
    required this.onSelectionChanged,
    this.enabled = true,
    this.maxHeight = 240,
  });

  final List<Library> libraries;
  final Set<String> selectedLibraryIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool enabled;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final allSelected = libraries.isNotEmpty && selectedLibraryIds.length == libraries.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text('Target libraries', style: Theme.of(context).textTheme.titleSmall)),
            Text('${selectedLibraryIds.length}/${libraries.length}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: !enabled || allSelected
                  ? null
                  : () => onSelectionChanged(libraries.map((library) => library.id).toSet()),
              child: const Text('Select all'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: !enabled || selectedLibraryIds.isEmpty ? null : () => onSelectionChanged(<String>{}),
              child: const Text('Clear all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (libraries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('No libraries available.', style: Theme.of(context).textTheme.bodyMedium),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: libraries.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final library = libraries[index];
                  final isSelected = selectedLibraryIds.contains(library.id);
                  return CheckboxListTile(
                    dense: true,
                    value: isSelected,
                    title: Text(library.name),
                    subtitle: Text(library.mediaType),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: !enabled
                        ? null
                        : (next) {
                            final nextSelection = Set<String>.from(selectedLibraryIds);
                            if (next ?? false) {
                              nextSelection.add(library.id);
                            } else {
                              nextSelection.remove(library.id);
                            }
                            onSelectionChanged(nextSelection);
                          },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
