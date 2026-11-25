import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/tables/expressive_tile_list.dart';
import 'package:yaabsa/util/l10n.dart';

@immutable
class LibraryMetadataSourceEntry {
  const LibraryMetadataSourceEntry({required this.id, required this.label, required this.enabled});

  final String id;
  final String label;
  final bool enabled;

  LibraryMetadataSourceEntry copyWith({String? id, String? label, bool? enabled}) {
    return LibraryMetadataSourceEntry(id: id ?? this.id, label: label ?? this.label, enabled: enabled ?? this.enabled);
  }
}

class LibraryMetadataPrecedenceEditor extends StatelessWidget {
  const LibraryMetadataPrecedenceEditor({
    super.key,
    required this.sources,
    required this.onReorderItem,
    required this.onToggleSource,
    required this.onResetToDefault,
    this.enabled = true,
  });

  final List<LibraryMetadataSourceEntry> sources;
  final ReorderCallback onReorderItem;
  final ValueChanged<LibraryMetadataSourceEntry> onToggleSource;
  final VoidCallback onResetToDefault;
  final bool enabled;

  String _priorityLabel(BuildContext context, LibraryMetadataSourceEntry source) {
    final l10n = context.l10n;
    if (!source.enabled) {
      return l10n.statusDisabled;
    }

    final enabledSources = sources.where((entry) => entry.enabled).toList(growable: false);
    final index = enabledSources.indexWhere((entry) => entry.id == source.id);
    if (index < 0) {
      return l10n.statusEnabled;
    }

    if (enabledSources.length == 1) {
      return l10n.statusOnlyActiveMetadataSource;
    }

    if (index == 0) {
      return l10n.statusHighestMetadataPriority;
    }

    if (index == enabledSources.length - 1) {
      return l10n.statusLowestMetadataPriority;
    }

    return l10n.statusMetadataPriority(index + 1, enabledSources.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(context.l10n.headingMetadataPrecedence, style: Theme.of(context).textTheme.titleSmall),
            ),
            TextButton.icon(
              onPressed: enabled ? onResetToDefault : null,
              icon: const Icon(Icons.restart_alt_rounded),
              label: Text(context.l10n.actionReset),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ExpressiveTileList<LibraryMetadataSourceEntry>(
              items: sources,
              itemId: (entry) => entry.id,
              titleBuilder: (entry) => entry.label,
              subtitleBuilder: (source) => _priorityLabel(context, source),
              onReorderItem: enabled ? onReorderItem : null,
              trailingBuilder: (context, entry) {
                return [
                  Switch.adaptive(
                    value: entry.enabled,
                    onChanged: enabled ? (value) => onToggleSource(entry.copyWith(enabled: value)) : null,
                  ),
                ];
              },
              physics: const AlwaysScrollableScrollPhysics(),
              emptyTitle: context.l10n.statusNoMetadataSourcesAvailable,
            ),
          ),
        ),
      ],
    );
  }
}
