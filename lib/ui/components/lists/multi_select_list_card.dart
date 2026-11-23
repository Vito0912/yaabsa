import 'package:material_ui/material_ui.dart';

class YaabsaMultiSelectOption {
  const YaabsaMultiSelectOption({required this.id, required this.label, this.subtitle});

  final String id;
  final String label;
  final String? subtitle;
}

class YaabsaMultiSelectListCard extends StatelessWidget {
  const YaabsaMultiSelectListCard({
    super.key,
    required this.title,
    required this.options,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.enabled = true,
    this.maxHeight = 220,
    this.emptyMessage = 'No options available.',
  });

  final String title;
  final List<YaabsaMultiSelectOption> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool enabled;
  final double maxHeight;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allOptionsSelected = options.isNotEmpty && selectedIds.length == options.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
            Text('${selectedIds.length}/${options.length}', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            TextButton(
              onPressed: !enabled || allOptionsSelected
                  ? null
                  : () {
                      final allOptionIds = options.map((option) => option.id).toSet();
                      onSelectionChanged(allOptionIds);
                    },
              child: const Text('Select all'),
            ),
            TextButton(
              onPressed: !enabled || selectedIds.isEmpty ? null : () => onSelectionChanged(<String>{}),
              child: const Text('Clear all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(emptyMessage, style: theme.textTheme.bodyMedium),
          )
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final isSelected = selectedIds.contains(option.id);
                  final subtitle = option.subtitle;

                  return CheckboxListTile(
                    dense: true,
                    value: isSelected,
                    title: Text(option.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: subtitle == null ? null : Text(subtitle, maxLines: 1),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: !enabled
                        ? null
                        : (nextSelected) {
                            final nextSelection = Set<String>.from(selectedIds);
                            if (nextSelected ?? false) {
                              nextSelection.add(option.id);
                            } else {
                              nextSelection.remove(option.id);
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
