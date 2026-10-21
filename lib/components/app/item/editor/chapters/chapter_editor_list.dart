import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_draft.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_row.dart';

class ChapterEditorList extends StatelessWidget {
  const ChapterEditorList({
    super.key,
    required this.controller,
    required this.draft,
    required this.rows,
    required this.indexByKey,
    required this.rowHeight,
    required this.mobile,
    required this.enabled,
    required this.canReorder,
    required this.activePreview,
    required this.onPreview,
    required this.onNextTitle,
    required this.onReorder,
    required this.onReorderStart,
  });

  final ScrollController controller;
  final ChapterEditorDraft draft;
  final List<ChapterEditorEntry> rows;
  final Map<int, int> indexByKey;
  final double rowHeight;
  final bool mobile;
  final bool enabled;
  final bool canReorder;
  final ValueListenable<int?> activePreview;
  final ValueChanged<ChapterEditorEntry> onPreview;
  final ValueChanged<ChapterEditorEntry> onNextTitle;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onReorderStart;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Center(
        child: Text(
          draft.rows.isEmpty ? 'No chapters yet. Add chapters or use audio tracks.' : 'No matching chapters.',
        ),
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: !mobile,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverReorderableList(
            itemExtent: rowHeight,
            itemCount: rows.length,
            findChildIndexCallback: (key) {
              final rowKey = key is GlobalObjectKey ? key.value : key;
              return rowKey is ValueKey<int> ? indexByKey[rowKey.value] : null;
            },
            onReorderStart: (index) {
              FocusManager.instance.primaryFocus?.unfocus();
              onReorderStart();
            },
            onReorderItem: onReorder,
            proxyDecorator: (child, index, animation) {
              return Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                child: child,
              );
            },
            itemBuilder: (context, index) {
              final row = rows[index];
              return ValueListenableBuilder<int?>(
                key: ValueKey(row.key),
                valueListenable: activePreview,
                builder: (context, active, child) {
                  return ChapterEditorRow(
                    key: ValueKey(row.key),
                    entry: row,
                    draft: draft,
                    mobile: mobile,
                    enabled: enabled,
                    isPreviewing: active == row.key,
                    onNextTitle: () => onNextTitle(row),
                    onPreview: () => onPreview(row),
                    dragHandle: Tooltip(
                      message: canReorder
                          ? 'Drag to reorder. Existing start times stay in place.'
                          : 'Clear search to reorder chapters',
                      child: ReorderableDragStartListener(
                        index: index,
                        enabled: enabled && canReorder,
                        child: MouseRegion(
                          cursor: enabled && canReorder ? SystemMouseCursors.grab : SystemMouseCursors.basic,
                          child: SizedBox(
                            width: 32,
                            height: 48,
                            child: Icon(
                              Icons.drag_indicator_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
