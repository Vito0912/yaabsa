import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/util/l10n.dart';

class ReaderAnnotationDetailsPresentation extends StatelessWidget {
  const ReaderAnnotationDetailsPresentation({
    super.key,
    required this.note,
    required this.onEdit,
    required this.onDelete,
    required this.onClose,
  });

  final String? note;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = context.l10n;
    final resolvedNote = note?.trim() ?? '';

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
              Container(
                constraints: const BoxConstraints(minHeight: 72),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.topLeft,
                child: SelectableText(
                  resolvedNote.isEmpty ? localizations.readerNoNote : resolvedNote,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: resolvedNote.isEmpty ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                    fontStyle: resolvedNote.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  YaabsaDeleteIconButton(
                    tooltip: localizations.actionDeleteAnnotation,
                    onPressed: onDelete,
                    iconSize: 24,
                    buttonSize: 48,
                    compact: false,
                  ),
                  const Spacer(),
                  YaabsaActionIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: localizations.actionEditAnnotation,
                    onPressed: onEdit,
                    tone: YaabsaActionTone.primary,
                    variant: YaabsaActionButtonVariant.outlined,
                    shape: YaabsaActionButtonShape.rounded,
                    iconSize: 24,
                    buttonSize: 48,
                    compact: false,
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(onPressed: onClose, child: Text(localizations.actionClose)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
