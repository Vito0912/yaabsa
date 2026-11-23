import 'package:material_ui/material_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:yaabsa/ui/theme/app_theme.dart';
import 'package:yaabsa/ui/theme/theme_selection.dart';

Widget yaabsaPreviewLight(Widget child) => YaabsaPreviewApp(child: child);

Widget yaabsaPreviewDark(Widget child) => YaabsaPreviewApp(brightness: Brightness.dark, child: child);

Widget yaabsaPreviewAmoled(Widget child) => YaabsaPreviewApp(brightness: Brightness.dark, amoled: true, child: child);

class YaabsaPreviewApp extends StatelessWidget {
  const YaabsaPreviewApp({super.key, required this.child, this.brightness = Brightness.light, this.amoled = false});

  final Widget child;
  final Brightness brightness;
  final bool amoled;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [...GlobalMaterialLocalizations.delegates, FlutterQuillLocalizations.delegate],
      theme: buildAppThemeData(
        brightness: brightness,
        preset: AppThemePreset.yaabsa,
        customSeedColor: const Color(0xFF0F766E),
        useAmoledDark: amoled,
      ),
      home: Scaffold(body: SafeArea(child: child)),
    );
  }
}
