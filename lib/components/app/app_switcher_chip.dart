import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/field_decoration.dart';

class AppSwitcherChip extends StatelessWidget {
  const AppSwitcherChip({super.key, required this.minWidth, required this.horizontalPadding, required this.child});

  final double minWidth;
  final double horizontalPadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textPainter = TextPainter(
      text: TextSpan(text: 'Ag', style: theme.textTheme.labelLarge),
      textScaler: MediaQuery.textScalerOf(context),
      textDirection: Directionality.of(context),
      maxLines: 1,
    );
    textPainter.layout();

    final contentHeight = math.max(28.0, textPainter.height.ceilToDouble());
    textPainter.dispose();

    return Container(
      height: contentHeight + 12,
      constraints: BoxConstraints(minWidth: minWidth),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: YaabsaFieldDimensions.borderRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}
