import 'package:flutter/material.dart';

class AdminUserSelectableOption {
  const AdminUserSelectableOption({required this.id, required this.label, this.subtitle});

  final String id;
  final String label;
  final String? subtitle;
}

class AdminUserMultiSelectCard extends StatelessWidget {
  const AdminUserMultiSelectCard({
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
  final List<AdminUserSelectableOption> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool enabled;
  final double maxHeight;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final allSelected = options.isNotEmpty && selectedIds.length == options.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
            Text('${selectedIds.length}/${options.length}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            TextButton(
              onPressed: !enabled || allSelected
                  ? null
                  : () {
                      onSelectionChanged(options.map((option) => option.id).toSet());
                    },
              child: const Text('Select all'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: !enabled || selectedIds.isEmpty
                  ? null
                  : () {
                      onSelectionChanged(<String>{});
                    },
              child: const Text('Clear all'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (options.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(emptyMessage, style: Theme.of(context).textTheme.bodyMedium),
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
                            final next = Set<String>.from(selectedIds);
                            if (nextSelected ?? false) {
                              next.add(option.id);
                            } else {
                              next.remove(option.id);
                            }
                            onSelectionChanged(next);
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
