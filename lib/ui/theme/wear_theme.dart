import 'package:material_ui/material_ui.dart';

ThemeData buildWearTheme(ThemeData base) {
  final colors = base.colorScheme.copyWith(
    surfaceContainerLow: const Color(0xFF1D1E20),
    surfaceContainer: const Color(0xFF242528),
    surfaceContainerHigh: const Color(0xFF2D2F32),
    surfaceContainerHighest: const Color(0xFF36383C),
  );
  final buttonStyle = FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(52),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    shape: const StadiumBorder(),
    textStyle: const TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w600),
  );
  const inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(22)),
    borderSide: BorderSide.none,
  );

  return base.copyWith(
    colorScheme: colors,
    scaffoldBackgroundColor: Colors.black,
    filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: colors.primary,
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: colors.surfaceContainerHigh.withValues(alpha: 0.65),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: colors.primary)),
      labelStyle: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
      hintStyle: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
    ),
    textTheme: base.textTheme.copyWith(
      bodyMedium: base.textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.2),
      bodySmall: base.textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.2),
      titleMedium: base.textTheme.titleMedium?.copyWith(fontSize: 18, height: 1.15, fontWeight: FontWeight.w600),
    ),
  );
}
