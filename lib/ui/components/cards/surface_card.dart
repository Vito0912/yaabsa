import 'package:material_ui/material_ui.dart';

class YaabsaSurfaceCard extends StatelessWidget {
  const YaabsaSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = color ?? colors.surfaceContainer;
    final outlineColor = borderColor;

    return Material(
      color: backgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: outlineColor == null ? BorderSide.none : BorderSide(color: outlineColor),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
