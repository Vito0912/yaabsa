import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/screens/player/layout/player_component_settings_sheet.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('player component switches update the controlled layout profile', (tester) async {
    var profile = PlayerLayoutProfile.defaults(PlayerLayoutScreenSize.mobile);

    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: PlayerComponentSettingsSheet(
          componentType: PlayerComponentType.mediaInfo,
          profile: profile,
          onChanged: (updatedProfile) => profile = updatedProfile,
        ),
      ),
    );

    expect(profile.placementFor(PlayerComponentType.mediaInfo).showNarrator, isFalse);

    await tester.tap(find.text('Show narrator'));
    await tester.pumpAndSettle();

    expect(profile.placementFor(PlayerComponentType.mediaInfo).showNarrator, isTrue);
    expect(tester.takeException(), isNull);
  });
}
