import 'package:material_ui/material_ui.dart';

class CustomHeadersEditor extends StatelessWidget {
  const CustomHeadersEditor({
    required this.headers,
    required this.enabled,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
    super.key,
  });

  final Map<String, String> headers;
  final bool enabled;
  final VoidCallback onAdd;
  final ValueChanged<String> onEdit;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Headers are sent with requests to this server. Avoid sharing values that contain secrets.',
          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 14),
        if (headers.isEmpty)
          Text(
            'No custom headers configured.',
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          )
        else
          ...headers.entries.map(
            (entry) => _HeaderCard(entry: entry, enabled: enabled, onEdit: onEdit, onRemove: onRemove),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: enabled ? onAdd : null,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add custom header'),
          ),
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.entry, required this.enabled, required this.onEdit, required this.onRemove});

  final MapEntry<String, String> entry;
  final bool enabled;
  final ValueChanged<String> onEdit;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(Icons.http_rounded, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  entry.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit header',
            onPressed: enabled ? () => onEdit(entry.key) : null,
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Remove header',
            onPressed: enabled ? () => onRemove(entry.key) : null,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}
