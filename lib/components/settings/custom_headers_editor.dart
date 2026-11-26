import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/util/l10n.dart';

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
          context.l10n.messageCustomHeadersSentWithRequests,
          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 14),
        if (headers.isEmpty)
          Text(
            context.l10n.statusNoCustomHeadersConfigured,
            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          )
        else
          ...headers.entries.map(
            (entry) => _HeaderCard(entry: entry, enabled: enabled, onEdit: onEdit, onRemove: onRemove),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: YaabsaButton.small(
            variant: YaabsaButtonVariant.outlined,
            onPressed: enabled ? onAdd : null,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(context.l10n.actionAddCustomHeader),
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
          const SizedBox(width: 8),
          YaabsaActionIconButton(
            icon: Icons.edit_outlined,
            tooltip: context.l10n.actionEdit,
            enabled: enabled,
            onPressed: enabled ? () => onEdit(entry.key) : null,
            variant: YaabsaActionButtonVariant.outlined,
            shape: YaabsaActionButtonShape.rounded,
          ),
          const SizedBox(width: 8),
          YaabsaDeleteIconButton(
            tooltip: context.l10n.actionRemove,
            onPressed: enabled ? () => onRemove(entry.key) : null,
          ),
        ],
      ),
    );
  }
}
