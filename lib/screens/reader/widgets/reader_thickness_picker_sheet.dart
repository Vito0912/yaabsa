import 'package:flutter/material.dart';

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
            'Select Underline Thickness',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          ...thicknesses.map((thickness) {
            return ListTile(
              title: Text('${thickness.toInt()}px', style: TextStyle(color: colorScheme.onSurface)),
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
