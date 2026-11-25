import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_draft.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';

class ChapterEditorRow extends StatefulWidget {
  const ChapterEditorRow({
    super.key,
    required this.entry,
    required this.draft,
    required this.mobile,
    required this.enabled,
    required this.onPreview,
    required this.isPreviewing,
    required this.onNextTitle,
    required this.dragHandle,
  });

  final ChapterEditorEntry entry;
  final ChapterEditorDraft draft;
  final bool mobile;
  final bool enabled;
  final VoidCallback? onPreview;
  final bool isPreviewing;
  final VoidCallback onNextTitle;
  final Widget dragHandle;

  @override
  State<ChapterEditorRow> createState() => _ChapterEditorRowState();
}

class _ChapterEditorRowState extends State<ChapterEditorRow> {
  final _titleFocus = FocusNode();
  late final TextEditingController _title;
  late final TextEditingController _start;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.entry.title);
    _start = TextEditingController(text: widget.entry.startText);
    widget.entry.onChanged = _refresh;
    widget.entry.onRequestTitleFocus = _titleFocus.requestFocus;
  }

  @override
  void dispose() {
    if (widget.entry.onChanged == _refresh) {
      widget.entry.onChanged = null;
    }
    if (widget.entry.onRequestTitleFocus == _titleFocus.requestFocus) {
      widget.entry.onRequestTitleFocus = null;
    }
    _titleFocus.dispose();
    _title.dispose();
    _start.dispose();
    super.dispose();
  }

  void _refresh() {
    if (_title.text != widget.entry.title) {
      _title.text = widget.entry.title;
    }
    if (_start.text != widget.entry.startText) {
      _start.text = widget.entry.startText;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final row = widget.entry;
    final colorScheme = Theme.of(context).colorScheme;
    final rowError = row.error;
    final checkbox = SizedBox(
      width: 48,
      child: Checkbox(
        value: row.selected,
        onChanged: widget.enabled ? (value) => widget.draft.select(row, value ?? false) : null,
        semanticLabel: context.l10n.a11ySelectChapter(row.position + 1),
      ),
    );
    final startField = StyledTextField(
      controller: _start,
      enabled: widget.enabled,
      onChanged: (value) => widget.draft.editStart(row, value),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {},
      onSubmitted: (_) => _titleFocus.requestFocus(),
      label: widget.mobile ? context.l10n.fieldStartTime : context.l10n.fieldChapterNumber(row.position + 1),
    );
    Widget? statusIcon;
    if (rowError != null) {
      statusIcon = Tooltip(
        message: _chapterEditorErrorMessage(context.l10n, rowError),
        child: Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 20),
      );
    } else if (row.isDirty) {
      statusIcon = Tooltip(message: context.l10n.statusEdited, child: const Icon(Icons.circle, size: 8));
    }

    final titleField = StyledTextField(
      controller: _title,
      focusNode: _titleFocus,
      enabled: widget.enabled,
      onChanged: (value) => widget.draft.editTitle(row, value),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {},
      onSubmitted: (_) => widget.onNextTitle(),
      label: context.l10n.fieldTitle,
      hintText: context.l10n.hintChapterTitle,
      suffixIcon: statusIcon,
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: widget.enabled && row.error == null ? widget.onPreview : null,
          tooltip: widget.isPreviewing ? context.l10n.actionStopPreview : context.l10n.tooltipChapterPreview,
          icon: Icon(widget.isPreviewing ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 20),
        ),
        YaabsaContextMenuButton<String>(
          enabled: widget.enabled,
          tooltip: context.l10n.tooltipChapterActions,
          onSelected: (action) {
            FocusManager.instance.primaryFocus?.unfocus();
            if (action == 'insert') {
              widget.draft.insertAfter(row, title: context.l10n.fieldChapterNumber(row.position + 2));
            } else if (action == 'remove') {
              widget.draft.remove(row);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: 'insert', child: Text(context.l10n.actionInsertChapterBelow)),
              PopupMenuItem(value: 'remove', child: Text(context.l10n.actionRemoveChapter)),
            ];
          },
          icon: const Icon(Icons.more_vert_rounded, size: 20),
        ),
      ],
    );

    return Material(
      color: row.selected ? colorScheme.secondaryContainer.withValues(alpha: 0.35) : colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.mobile) ...[
              Row(
                children: [
                  widget.dragHandle,
                  checkbox,
                  Expanded(child: startField),
                  const SizedBox(width: 4),
                  actions,
                ],
              ),
              const SizedBox(height: 4),
              Padding(padding: const EdgeInsets.only(left: 8), child: titleField),
            ] else
              Row(
                children: [
                  widget.dragHandle,
                  checkbox,
                  SizedBox(width: 160, child: startField),
                  const SizedBox(width: 8),
                  Expanded(child: titleField),
                  const SizedBox(width: 4),
                  actions,
                ],
              ),
          ],
        ),
      ),
    );
  }
}

String _chapterEditorErrorMessage(AppLocalizations l10n, ChapterEditorError error) {
  return switch (error) {
    ChapterEditorError.bookDurationUnavailable => l10n.errorBookDurationUnavailable,
    ChapterEditorError.emptyTitle => l10n.errorEnterTitle,
    ChapterEditorError.invalidStartFormat => l10n.hintChapterTimeFormat,
    ChapterEditorError.firstChapterMustStartAtZero => l10n.errorFirstChapterMustStartAtZero,
    ChapterEditorError.startOutsideBook => l10n.errorChapterStartOutsideBook,
    ChapterEditorError.startsNotAscending => l10n.errorChapterStartsNotAscending,
  };
}
