import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/previews/ui_lab.dart';

void main() {
  const sizes = [
    Size(320, 640),
    Size(390, 844),
    Size(800, 1100),
    Size(1100, 800),
    Size(1280, 800),
    Size(1600, 900),
    Size(800, 450),
  ];
  const scenarios = [
    'Player',
    'Mini player',
    'Player collections',
    'Player empty states',
    'Player timer',
    'Player speed',
    'Player subtitles',
    'Player casting',
    'Player bookmarks',
    'Player actions',
    'Player metadata',
    'Player transport buttons',
    'Playback states',
    'Player seek timeline',
    'Player horizontal volume',
    'Player vertical volume',
    'Shared side actions',
    'Series and narrator sort headers',
    'Prominent library playback',
    'Player layout',
    'Player component settings',
    'Settings',
    'Administration users',
    'Administration access',
    'Reader annotations',
    'Statistics',
    'Statistics states',
    'Statistics compact',
    'Statistics loading',
    'Statistics without activity',
    'Statistics achievements',
    'Statistics advanced',
    'Statistics year in review',
    'Statistics sessions',
    'Statistics totals',
    'Statistics panels',
    'Statistics metrics',
    'Statistics 7 day chart',
    'Statistics year chart',
    'Statistics recent activity map',
    'Statistics year activity map',
    'Statistics ranked listening',
    'Statistics empty states',
    'Statistics messages',
    'Statistics surface cards',
    'Upload workspace',
    'Library',
    'Library grid',
    'Book information actions',
    'Podcast header',
    'Podcast episode controls',
    'Podcast filter controls',
    'Library playback actions',
    'Library sorting',
    'Library filters',
    'Collections & playlists',
    'Collections & playlists lists',
    'Library entities',
    'Lists & tables',
    'Listening sessions',
    'Upload controls',
    'Upload drop zone',
    'Upload metadata',
    'Upload item',
    'Upload path conflicts',
    'Upload advanced options',
    'Dialogs',
    'Inputs',
  ];
  const responsiveScenarios = [
    'Administration users',
    'Library',
    'Library grid',
    'Listening sessions',
    'Player',
    'Player metadata',
    'Statistics',
    'Statistics 7 day chart',
    'Statistics recent activity map',
    'Upload workspace',
  ];

  for (final size in sizes) {
    testWidgets('UI Lab renders each scenario at $size with large text', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = 1.8;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final scenariosToRender = size == const Size(390, 844) || size == const Size(1280, 800)
          ? scenarios
          : responsiveScenarios;

      for (final scenario in scenariosToRender) {
        await tester.pumpWidget(
          ProviderScope(
            child: UiLab(key: ValueKey(scenario), initialScenario: scenario),
          ),
        );
        await tester.pump();
        final exception = tester.takeException();
        expect(exception, isNull, reason: '$scenario: $exception');
        expect(find.text('UI Lab: $scenario'), findsOneWidget);
      }
      await tester.pumpWidget(const SizedBox());
    });
  }
}
