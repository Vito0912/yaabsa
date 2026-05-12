import 'package:flutter/material.dart';

BorderSide libraryItemEditorSoftBorderSide(BuildContext context, {double alpha = 0.4}) {
  return BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: alpha));
}

class LibraryItemEditorFieldContainer extends StatelessWidget {
  const LibraryItemEditorFieldContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.borderRadius = 10,
    this.backgroundAlpha = 0.72,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double backgroundAlpha;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.fromBorderSide(libraryItemEditorSoftBorderSide(context, alpha: 0.38)),
      ),
      child: child,
    );
  }
}
