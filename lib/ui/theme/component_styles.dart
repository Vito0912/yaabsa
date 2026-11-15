import 'package:material_ui/material_ui.dart';

abstract final class YaabsaButtonStyles {
  static const shape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14)));
  static const minimumSize = Size(64, 48);
  static const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  static const compactProminentAction = ButtonStyle(
    minimumSize: WidgetStatePropertyAll<Size>(Size(0, 40)),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
    visualDensity: VisualDensity.compact,
  );

  static const compactFilePathAction = ButtonStyle(
    minimumSize: WidgetStatePropertyAll<Size>(Size(0, 32)),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
    shape: WidgetStatePropertyAll<OutlinedBorder>(shape),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static const inlineMetadataLink = ButtonStyle(
    minimumSize: WidgetStatePropertyAll<Size>(Size(0, 28)),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 2)),
    shape: WidgetStatePropertyAll<OutlinedBorder>(shape),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    alignment: Alignment.centerLeft,
  );

  static const style = ButtonStyle(
    minimumSize: WidgetStatePropertyAll<Size>(minimumSize),
    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
    shape: WidgetStatePropertyAll<OutlinedBorder>(shape),
  );

  static ThemeData applyTo(ThemeData theme) {
    return theme.copyWith(
      elevatedButtonTheme: const ElevatedButtonThemeData(style: style),
      filledButtonTheme: const FilledButtonThemeData(style: style),
      outlinedButtonTheme: const OutlinedButtonThemeData(style: style),
      textButtonTheme: const TextButtonThemeData(style: style),
    );
  }
}
