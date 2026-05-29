import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/tables/expressive_tile_list.dart';

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

  String _priorityLabel(LibraryMetadataSourceEntry source) {
    if (!source.enabled) {
      return 'Disabled';
    }

    final enabledSources = sources.where((entry) => entry.enabled).toList(growable: false);
    final index = enabledSources.indexWhere((entry) => entry.id == source.id);
    if (index < 0) {
      return 'Enabled';
    }

    if (enabledSources.length == 1) {
      return 'Only active source';
    }

    if (index == 0) {
      return 'Highest priority';
    }

    if (index == enabledSources.length - 1) {
      return 'Lowest priority';
    }

    return 'Priority ${index + 1} of ${enabledSources.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text('Metadata precedence', style: Theme.of(context).textTheme.titleSmall)),
            TextButton.icon(
              onPressed: enabled ? onResetToDefault : null,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset'),
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
              subtitleBuilder: _priorityLabel,
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
              emptyTitle: 'No metadata sources available.',
            ),
          ),
        ),
      ],
    );
  }
}
