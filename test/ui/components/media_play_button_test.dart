import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  for (final size in [36.0, 40.0]) {
    testWidgets('progress ring is the outside edge at $size px', (tester) async {
      await tester.pumpWidget(
        YaabsaPreviewApp(
          child: YaabsaMediaPlayButton(
            size: size,
            tooltip: 'Play',
            isPlaying: false,
            isFinished: false,
            isLoading: false,
            onPressed: () {},
            progress: 0.42,
          ),
        ),
      );

      expect(tester.getSize(find.byKey(const ValueKey('yaabsa-media-play-background'))), Size(size - 8, size - 8));
      expect(tester.getSize(find.byKey(const ValueKey('yaabsa-media-play-progress-ring'))), Size(size, size));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('finished state hides the progress ring and fills the button', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaMediaPlayButton(
          size: 36,
          tooltip: 'Replay',
          isPlaying: false,
          isFinished: true,
          isLoading: false,
          onPressed: () {},
          progress: 1,
        ),
      ),
    );

    expect(find.byKey(const ValueKey('yaabsa-media-play-progress-ring')), findsNothing);
    expect(tester.getSize(find.byKey(const ValueKey('yaabsa-media-play-background'))), const Size(36, 36));
  });

  testWidgets('loading retains a circular background', (tester) async {
    await tester.pumpWidget(
      YaabsaPreviewApp(
        child: YaabsaMediaPlayButton(
          size: 36,
          tooltip: 'Loading',
          isPlaying: false,
          isFinished: false,
          isLoading: true,
          onPressed: null,
        ),
      ),
    );

    final background = tester.widget<Container>(find.byKey(const ValueKey('yaabsa-media-play-background')));
    expect(background.decoration, isA<BoxDecoration>());
    expect((background.decoration! as BoxDecoration).shape, BoxShape.circle);
    expect(tester.takeException(), isNull);
  });
}
