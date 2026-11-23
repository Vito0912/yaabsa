import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/theme/app_theme.dart';
import 'package:yaabsa/ui/theme/component_styles.dart';
import 'package:yaabsa/ui/theme/theme_selection.dart';

void main() {
  test('YAABSA button variants share the design-system geometry', () {
    final theme = buildAppThemeData(
      brightness: Brightness.light,
      preset: AppThemePreset.yaabsa,
      customSeedColor: Colors.teal,
      useAmoledDark: false,
    );

    final state = <WidgetState>{};
    final styles = [
      theme.elevatedButtonTheme.style,
      theme.filledButtonTheme.style,
      theme.outlinedButtonTheme.style,
      theme.textButtonTheme.style,
    ];

    for (final style in styles) {
      expect(style?.shape?.resolve(state), YaabsaButtonStyles.shape);
      expect(style?.minimumSize?.resolve(state), YaabsaButtonStyles.minimumSize);
      expect(style?.padding?.resolve(state), YaabsaButtonStyles.padding);
    }
  });

  test('compact text actions keep their spacing and use the shared shape', () {
    final state = <WidgetState>{};
    final filePathStyle = YaabsaButtonStyles.compactFilePathAction;
    final metadataLinkStyle = YaabsaButtonStyles.inlineMetadataLink;

    expect(filePathStyle.shape?.resolve(state), YaabsaButtonStyles.shape);
    expect(filePathStyle.minimumSize?.resolve(state), const Size(0, 32));
    expect(filePathStyle.padding?.resolve(state), const EdgeInsets.symmetric(horizontal: 8, vertical: 4));
    expect(filePathStyle.tapTargetSize, MaterialTapTargetSize.shrinkWrap);

    expect(metadataLinkStyle.shape?.resolve(state), YaabsaButtonStyles.shape);
    expect(metadataLinkStyle.minimumSize?.resolve(state), const Size(0, 28));
    expect(metadataLinkStyle.padding?.resolve(state), const EdgeInsets.symmetric(vertical: 2));
    expect(metadataLinkStyle.tapTargetSize, MaterialTapTargetSize.shrinkWrap);
    expect(metadataLinkStyle.alignment, Alignment.centerLeft);
  });
}
