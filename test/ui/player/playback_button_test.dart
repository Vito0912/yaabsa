import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/player/widgets/playback_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';

void main() {
  testWidgets('playback states render and invoke commands without audio initialization', (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      YaabsaPreviewApp(child: PlaybackButton(isPlaying: false, isLoading: false, onPressed: () => presses++)),
    );
    await tester.tap(find.byTooltip('Play'));
    expect(presses, 1);

    await tester.pumpWidget(
      const YaabsaPreviewApp(child: PlaybackButton(isPlaying: true, isLoading: false, onPressed: null)),
    );
    expect(find.byTooltip('Pause'), findsOneWidget);
    expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed, isNull);

    await tester.pumpWidget(
      const YaabsaPreviewApp(child: PlaybackButton(isPlaying: false, isLoading: true, onPressed: null)),
    );
    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    final loadingButton = tester.widget<IconButton>(find.byType(IconButton));
    final loadingShape = loadingButton.style!.shape!.resolve(const <WidgetState>{});
    final loadingBackground = loadingButton.style!.backgroundColor!.resolve(const <WidgetState>{WidgetState.disabled});
    final colorScheme = Theme.of(tester.element(find.byType(PlaybackButton))).colorScheme;
    expect(loadingButton.onPressed, isNull);
    expect(loadingShape, isA<CircleBorder>());
    expect(loadingBackground, colorScheme.primary);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });
}
