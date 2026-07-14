import 'package:flutter/material.dart';
import 'package:foliate_reader/foliate_reader.dart';

enum ReaderAnnotationSheetActionType { update, delete }

class ReaderAnnotationSheetAction {
  const ReaderAnnotationSheetAction.update({required this.note, required this.color})
    : type = ReaderAnnotationSheetActionType.update;

  const ReaderAnnotationSheetAction.delete() : type = ReaderAnnotationSheetActionType.delete, note = null, color = null;

  final ReaderAnnotationSheetActionType type;
  final String? note;
  final String? color;
}

enum _AnnotationDetailsAction { edit, delete }

const List<(String, Color)> _annotationColors = <(String, Color)>[
  ('#FFEB3B', Colors.yellow),
  ('#4CAF50', Colors.green),
  ('#2196F3', Colors.blue),
  ('#E91E63', Colors.pink),
  ('#9C27B0', Colors.purple),
];

Future<ReaderAnnotationSheetAction?> showReaderEpubAnnotationSheet(
  BuildContext context,
  FoliateAnnotation annotation,
) async {
  final detailsAction = await showModalBottomSheet<_AnnotationDetailsAction>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _AnnotationDetailsSheet(annotation: annotation),
  );
  if (!context.mounted || detailsAction == null) return null;

  if (detailsAction == _AnnotationDetailsAction.delete) {
    return const ReaderAnnotationSheetAction.delete();
  }
  return showModalBottomSheet<ReaderAnnotationSheetAction>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _AnnotationEditorSheet(annotation: annotation),
  );
}

class _AnnotationDetailsSheet extends StatelessWidget {
  const _AnnotationDetailsSheet({required this.annotation});

  final FoliateAnnotation annotation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final note = annotation.note?.trim() ?? '';

    return Center(
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Note', style: Theme.of(context).textTheme.titleMedium)),
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context, _AnnotationDetailsAction.edit),
                    tooltip: 'Edit annotation',
                    visualDensity: VisualDensity.compact,
                    iconSize: 20,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(minHeight: 72),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.topLeft,
                child: SelectableText(
                  note.isEmpty ? 'No note added' : note,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: note.isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                    fontStyle: note.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context, _AnnotationDetailsAction.delete),
                    style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                  const Spacer(),
                  FilledButton.tonal(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnotationEditorSheet extends StatefulWidget {
  const _AnnotationEditorSheet({required this.annotation});

  final FoliateAnnotation annotation;

  @override
  State<_AnnotationEditorSheet> createState() => _AnnotationEditorSheetState();
}

class _AnnotationEditorSheetState extends State<_AnnotationEditorSheet> {
  late final TextEditingController _noteController;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.annotation.note);
    _selectedColor = widget.annotation.color;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Edit annotation', style: Theme.of(context).textTheme.headlineSmall)),
                  IconButton(onPressed: () => Navigator.pop(context), tooltip: 'Close', icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                minLines: 3,
                maxLines: 6,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Add an optional note',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Color', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _annotationColors.map((entry) {
                  final (hex, color) = entry;
                  final selected = hex.toUpperCase() == _selectedColor.toUpperCase();
                  return Semantics(
                    button: true,
                    selected: selected,
                    label: 'Annotation color $hex',
                    child: InkWell(
                      onTap: () => setState(() => _selectedColor = hex),
                      customBorder: const CircleBorder(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: selected ? const Icon(Icons.check, color: Colors.black87) : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(
                      context,
                      ReaderAnnotationSheetAction.update(note: _noteController.text.trim(), color: _selectedColor),
                    ),
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
