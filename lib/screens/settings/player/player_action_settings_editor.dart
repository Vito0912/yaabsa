import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';

class PlayerActionSettingsEditor extends ConsumerWidget {
  const PlayerActionSettingsEditor({
    super.key,
    required this.title,
    required this.description,
    required this.settingKey,
    required this.fallback,
  });

  final String title;
  final String description;
  final String settingKey;
  final List<PlayerActionType> fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(globalSettingByKeyProvider(settingKey));

    return setting.when(
      data: (rawValue) {
        final selected = decodePlayerActions(rawValue, fallback: fallback);
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          title: Text(title),
          subtitle: Text('$description\n${selected.length} actions shown'),
          isThreeLine: true,
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showEditor(context, ref, selected),
        );
      },
      loading: () => const ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        title: Text('Loading actions'),
      ),
      error: (error, stackTrace) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error),
        title: Text(title),
        subtitle: const Text('Could not load this setting'),
      ),
    );
  }

  Future<void> _showEditor(BuildContext context, WidgetRef ref, List<PlayerActionType> selected) async {
    final result = await showModalBottomSheet<List<PlayerActionType>>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _PlayerActionEditorSheet(title: title, selected: selected),
    );

    if (result == null) {
      return;
    }

    await ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(settingKey, encodePlayerActions(result));
  }
}

class _PlayerActionEditorSheet extends StatefulWidget {
  const _PlayerActionEditorSheet({required this.title, required this.selected});

  final String title;
  final List<PlayerActionType> selected;

  @override
  State<_PlayerActionEditorSheet> createState() => _PlayerActionEditorSheetState();
}

class _PlayerActionEditorSheetState extends State<_PlayerActionEditorSheet> {
  late final List<PlayerActionType> _order = <PlayerActionType>[
    ...widget.selected,
    ...PlayerActionType.values.where((action) => !widget.selected.contains(action)),
  ];
  late final Set<PlayerActionType> _selected = widget.selected.toSet();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Choose visible actions and drag them into the preferred order.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: _order.length,
              onReorderItem: (oldIndex, newIndex) {
                setState(() {
                  final action = _order.removeAt(oldIndex);
                  _order.insert(newIndex, action);
                });
              },
              itemBuilder: (context, index) {
                final action = _order[index];
                return SwitchListTile(
                  key: ValueKey<PlayerActionType>(action),
                  value: _selected.contains(action),
                  secondary: Icon(action.icon),
                  title: Text(action.label),
                  onChanged: (selected) {
                    setState(() {
                      selected ? _selected.add(action) : _selected.remove(action);
                    });
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.drag_handle_rounded, size: 20),
                            SizedBox(width: 6),
                            Text('Drag to reorder'),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () {
                Navigator.of(context).pop(_order.where(_selected.contains).toList(growable: false));
              },
              child: const Text('Save actions'),
            ),
          ),
        ],
      ),
    );
  }
}
