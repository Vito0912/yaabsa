import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/util/l10n.dart';

class ReaderAnnotationTile extends StatelessWidget {
  const ReaderAnnotationTile({
    super.key,
    required this.type,
    required this.cfi,
    required this.color,
    required this.onRemove,
    this.thickness,
  });

  final String type;
  final String cfi;
  final String color;
  final double? thickness;
  final VoidCallback onRemove;

  Color _parseColor(String colorStr) {
    if (colorStr == 'none') {
      return Colors.transparent;
    }
    if (colorStr.startsWith('#')) {
      return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final parsedColor = _parseColor(color);
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = context.l10n;
    final localizedType = switch (type) {
      'Highlight' => localizations.readerAnnotationHighlight,
      'Underline' => localizations.readerAnnotationUnderline,
      _ => type,
    };
    final title = thickness == null
        ? localizedType
        : localizations.readerAnnotationTitleWithThickness(
            localizedType,
            localizations.readerUnderlineThicknessPixels(
              NumberFormat.decimalPattern(Localizations.localeOf(context).toString()).format(thickness!.toInt()),
            ),
          );

    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: type == 'Highlight' ? parsedColor : Colors.transparent,
          border: type == 'Underline'
              ? Border(
                  bottom: BorderSide(color: parsedColor, width: thickness ?? 1),
                )
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      title: Text(title, style: TextStyle(color: colorScheme.onSurface)),
      trailing: YaabsaDeleteIconButton(tooltip: localizations.actionDeleteAnnotation, onPressed: onRemove),
    );
  }
}
