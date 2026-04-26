import 'package:flutter/material.dart';

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
      title: Text(
        '$type ${thickness != null ? '(${thickness!.toInt()}px)' : ''}',
        style: TextStyle(color: colorScheme.onSurface),
      ),
      subtitle: Text(
        'CFI: ${cfi.length > 30 ? '${cfi.substring(0, 30)}...' : cfi}',
        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
      ),
      trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: onRemove),
    );
  }
}
