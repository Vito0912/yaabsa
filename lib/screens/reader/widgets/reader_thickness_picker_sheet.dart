import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

class ReaderThicknessPickerSheet extends StatelessWidget {
  const ReaderThicknessPickerSheet({
    super.key,
    required this.color,
    required this.thicknesses,
    required this.onThicknessSelected,
  });

  final Color color;
  final List<double> thicknesses;
  final ValueChanged<double> onThicknessSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.screensReaderWidgetsReaderThicknessPickerSheetSelectUnderlineThickness,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          ...thicknesses.map((thickness) {
            return ListTile(
              title: Text(
                S.current.screensReaderWidgetsReaderThicknessPickerSheetPx(thickness.toInt()),
                style: TextStyle(color: colorScheme.onSurface),
              ),
              leading: Container(
                width: 40,
                height: thickness,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(thickness / 2)),
              ),
              onTap: () => onThicknessSelected(thickness),
            );
          }),
        ],
      ),
    );
  }
}
