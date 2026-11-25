import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_draft.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';

class ChapterEditorToolbar extends StatelessWidget {
  const ChapterEditorToolbar({
    super.key,
    required this.draft,
    required this.status,
    required this.search,
    required this.onSearchChanged,
    required this.visibleRows,
    required this.enabled,
    required this.onAdd,
    required this.onLookup,
    required this.onShift,
    required this.onFromTracks,
    required this.onRemoveSelected,
  });

  final ChapterEditorDraft draft;
  final ValueListenable<int> status;
  final TextEditingController search;
  final ValueChanged<String> onSearchChanged;
  final List<ChapterEditorEntry> visibleRows;
  final bool enabled;
  final VoidCallback onAdd;
  final VoidCallback onLookup;
  final VoidCallback onShift;
  final VoidCallback? onFromTracks;
  final VoidCallback onRemoveSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: enabled ? onAdd : null,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.actionAddChapters),
              ),
              if (context.isMobile)
                YaabsaContextMenuButton<String>(
                  enabled: enabled,
                  tooltip: context.l10n.actionChapterTools,
                  onSelected: (action) {
                    if (action == 'lookup') {
                      onLookup();
                    } else if (action == 'shift') {
                      onShift();
                    } else if (action == 'tracks') {
                      onFromTracks?.call();
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(value: 'lookup', child: Text(context.l10n.actionFindChapters)),
                      PopupMenuItem(
                        value: 'shift',
                        enabled: draft.rows.isNotEmpty,
                        child: Text(context.l10n.actionShiftTimes),
                      ),
                      PopupMenuItem(
                        value: 'tracks',
                        enabled: onFromTracks != null,
                        child: Text(context.l10n.actionUseAudioTracks),
                      ),
                    ];
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.build_outlined),
                        const SizedBox(width: 8),
                        Text(context.l10n.actionChapterTools),
                      ],
                    ),
                  ),
                ),
              if (!context.isMobile)
                OutlinedButton.icon(
                  onPressed: enabled ? onLookup : null,
                  icon: const Icon(Icons.search),
                  label: Text(context.l10n.actionFindChapters),
                ),
              if (!context.isMobile)
                OutlinedButton.icon(
                  onPressed: enabled && draft.rows.isNotEmpty ? onShift : null,
                  icon: const Icon(Icons.more_time_rounded),
                  label: Text(context.l10n.actionShiftTimes),
                ),
              if (!context.isMobile)
                OutlinedButton.icon(
                  onPressed: enabled ? onFromTracks : null,
                  icon: const Icon(Icons.queue_music_rounded),
                  label: Text(context.l10n.actionUseAudioTracks),
                ),
            ],
          ),
          const SizedBox(height: 8),
          StyledTextField(
            controller: search,
            enabled: enabled,
            onChanged: onSearchChanged,
            label: context.l10n.hintSearchChapters,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            prefixIcon: const Icon(Icons.search_rounded),
          ),
          ValueListenableBuilder<int>(
            valueListenable: status,
            builder: (context, value, child) {
              final selected = draft.selectedKeys.length;
              final visibleSelected = visibleRows.where((row) => row.selected).length;
              bool? checked = false;
              if (visibleSelected > 0) {
                checked = visibleSelected == visibleRows.length ? true : null;
              }

              return Row(
                children: [
                  Checkbox(
                    tristate: true,
                    value: checked,
                    onChanged: enabled && visibleRows.isNotEmpty
                        ? (_) => draft.selectAll(visibleSelected != visibleRows.length, visibleRows)
                        : null,
                    semanticLabel: context.l10n.a11ySelectAllVisibleChapters,
                  ),
                  Expanded(
                    child: Text(
                      selected > 0
                          ? context.l10n.selectedCount(selected)
                          : context.l10n.chapterCount(draft.rows.length),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selected > 0)
                    TextButton.icon(
                      onPressed: enabled ? onRemoveSelected : null,
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(context.l10n.actionRemoveSelected),
                    ),
                ],
              );
            },
          ),
          if (!context.isMobile)
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 0, 96, 4),
              child: Row(
                children: [
                  SizedBox(width: 168, child: Text(context.l10n.fieldStartTime)),
                  Expanded(child: Text(context.l10n.fieldTitle)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ChapterEditorFooter extends StatelessWidget {
  const ChapterEditorFooter({
    super.key,
    required this.draft,
    required this.status,
    required this.saving,
    required this.conflict,
    required this.message,
    required this.onReset,
    required this.onSave,
  });

  final ChapterEditorDraft draft;
  final ValueListenable<int> status;
  final bool saving;
  final bool conflict;
  final String? message;
  final VoidCallback onReset;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ValueListenableBuilder<int>(
          valueListenable: status,
          builder: (context, value, child) {
            final canSave = draft.hasChanges && draft.errorCount == 0 && !saving && !conflict;
            String? summary;
            if (draft.errorCount > 0) {
              summary = context.l10n.statusChapterErrors(draft.errorCount);
            } else if (draft.hasChanges) {
              summary = context.l10n.statusUnsavedChanges;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (message != null) ...[Text(message!), const SizedBox(height: 8)],
                Row(
                  children: [
                    Expanded(
                      child: summary == null
                          ? const SizedBox.shrink()
                          : Text(summary, maxLines: 2, style: Theme.of(context).textTheme.bodySmall),
                    ),
                    TextButton(
                      onPressed: !saving && (draft.hasChanges || conflict) ? onReset : null,
                      child: Text(context.l10n.actionDiscardEdits),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: canSave ? onSave : null,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(saving ? context.l10n.statusSaving : context.l10n.actionSave),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
