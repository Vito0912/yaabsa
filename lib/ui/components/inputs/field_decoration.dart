import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

abstract final class YaabsaFieldDimensions {
  static const borderRadius = BorderRadius.all(Radius.circular(10));
  static const double compactHeight = 48;
  static const double standardHeight = 56;
}

InputDecoration yaabsaFieldDecoration(
  BuildContext context, {
  String? label,
  String? hintText,
  TextStyle? textStyle,
  bool isDense = false,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final effectiveTextStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium;
  final fontSize = effectiveTextStyle?.fontSize ?? 14;
  final scaledFontSize = MediaQuery.textScalerOf(context).scale(fontSize);
  final lineHeight = scaledFontSize * (effectiveTextStyle?.height ?? 1.2);
  final resolvedPadding = contentPadding.resolve(Directionality.of(context));
  const verticalReserve = 6.0;
  final contentHeight = (lineHeight + resolvedPadding.vertical + verticalReserve).ceilToDouble();
  final minimumHeight = isDense ? YaabsaFieldDimensions.compactHeight : YaabsaFieldDimensions.standardHeight;
  final minHeight = math.max(minimumHeight, contentHeight);
  final defaultBorder = OutlineInputBorder(
    borderRadius: YaabsaFieldDimensions.borderRadius,
    borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
  );
  final focusedBorder = OutlineInputBorder(
    borderRadius: YaabsaFieldDimensions.borderRadius,
    borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
  );

  return InputDecoration(
    labelText: label,
    hintText: hintText,
    filled: true,
    fillColor: colorScheme.surfaceContainer,
    contentPadding: contentPadding,
    isDense: isDense,
    constraints: BoxConstraints(minHeight: minHeight),
    border: defaultBorder,
    enabledBorder: defaultBorder,
    focusedBorder: focusedBorder,
  );
}

BoxConstraints? yaabsaFieldConstraints(BoxConstraints? requested, BoxConstraints? base) {
  if (requested == null) {
    return base;
  }

  final baseMinHeight = base?.minHeight ?? 0;
  final requestedMinHeight = math.max(requested.minHeight, baseMinHeight);
  final minHeight = math.min(requestedMinHeight, requested.maxHeight);

  return BoxConstraints(
    minWidth: requested.minWidth,
    maxWidth: requested.maxWidth,
    minHeight: minHeight,
    maxHeight: requested.maxHeight,
  );
}

double yaabsaDropdownFieldVerticalPadding(
  BuildContext context,
  InputDecoration decoration, {
  required TextStyle textStyle,
  required Widget? suffixIcon,
}) {
  final minimumHeight =
      decoration.constraints?.minHeight ??
      (decoration.isDense == true ? YaabsaFieldDimensions.compactHeight : YaabsaFieldDimensions.standardHeight);
  final theme = Theme.of(context);
  final textHeight = _yaabsaTextHeight(context, 'M', textStyle);
  final labelText = decoration.labelText;
  final labelHeight = labelText == null || labelText.isEmpty
      ? 0.0
      : _yaabsaTextHeight(context, labelText, theme.textTheme.labelSmall ?? textStyle);
  final prefixHeight = _yaabsaIconHeight(decoration.prefixIcon, fallback: theme.iconTheme.size ?? 24);
  final suffixHeight = _yaabsaIconHeight(suffixIcon, fallback: theme.iconTheme.size ?? 24);
  final contentHeight = math.max(textHeight + labelHeight, math.max(prefixHeight, suffixHeight));

  return math.max(0, (minimumHeight - contentHeight) / 2);
}

double _yaabsaTextHeight(BuildContext context, String text, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
    maxLines: 1,
  )..layout();
  final height = painter.height;
  painter.dispose();

  return height;
}

double _yaabsaIconHeight(Widget? widget, {required double fallback}) {
  if (widget is Icon) {
    return widget.size ?? fallback;
  }

  return fallback;
}
