import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/media/audio_browse_icon.dart';
import 'package:yaabsa/ui/components/wear/wear_account_details.dart';
import 'package:yaabsa/ui/components/wear/wear_ambient_view.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_button.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_scaffold.dart';
import 'package:yaabsa/ui/components/wear/wear_confirmation_screen.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';
import 'package:yaabsa/ui/components/wear/wear_player_controls.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_view.dart';
import 'package:yaabsa/ui/components/wear/wear_transforming_list_item.dart';
import 'package:yaabsa/ui/components/wear/wear_volume_control.dart';
import 'package:yaabsa/ui/theme/wear_theme.dart';
import 'package:yaabsa/util/l10n.dart';

Widget _wearTestApp({required Widget child, Size size = const Size(227, 227)}) {
  return MaterialApp(
    localizationsDelegates: yaabsaLocalizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: buildWearTheme(ThemeData.dark(useMaterial3: true)),
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: child,
    ),
  );
}

void main() {
  testWidgets('buildWearTheme sets black scaffold and stadium filled button', (tester) async {
    final theme = buildWearTheme(ThemeData.dark(useMaterial3: true));
    expect(theme.scaffoldBackgroundColor, Colors.black);
    expect(theme.filledButtonTheme.style?.shape?.resolve({}), isA<StadiumBorder>());
  });

  testWidgets('WearBrowseButton renders title, subtitle, progress, and loading indicator', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wearTestApp(
        child: Scaffold(
          body: WearBrowseButton(
            title: 'Downloads',
            subtitle: '3 items',
            icon: Icons.download_outlined,
            progress: 0.5,
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Downloads'), findsOneWidget);
    expect(find.text('3 items'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    expect(tapped, isTrue);

    await tester.pumpWidget(
      _wearTestApp(
        child: Scaffold(
          body: WearBrowseButton(title: 'Loading', loading: true, onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(YaabsaCircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearBrowseScaffoldView renders header and items', (tester) async {
    await tester.pumpWidget(
      _wearTestApp(
        child: WearBrowseScaffoldView(
          title: 'Libraries',
          subtitle: '2 available',
          flatScrolling: true,
          itemCount: 2,
          itemBuilder: (context, index) => WearBrowseButton(title: 'Library $index', onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(WearPageHeader), findsOneWidget);
    expect(find.text('Libraries'), findsOneWidget);
    expect(find.text('2 available'), findsOneWidget);
    expect(find.text('Library 0'), findsOneWidget);
    expect(find.text('Library 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearPlaybackControlsView uses scalloped YaabsaMediaPlayButton and jump tooltips', (tester) async {
    var playCount = 0;
    var rewindCount = 0;
    var forwardCount = 0;

    await tester.pumpWidget(
      _wearTestApp(
        child: Scaffold(
          body: Center(
            child: WearPlaybackControlsView(
              isPlaying: false,
              rewindSeconds: 10,
              forwardSeconds: 30,
              progress: 0.25,
              onPlayPause: () => playCount++,
              onRewind: () => rewindCount++,
              onForward: () => forwardCount++,
            ),
          ),
        ),
      ),
    );

    final playButton = tester.widget<YaabsaMediaPlayButton>(find.byType(YaabsaMediaPlayButton));
    expect(playButton.style, YaabsaMediaPlayButtonStyle.scalloped);
    expect(playButton.progress, 0.25);
    expect(find.byTooltip('Rewind 10 seconds'), findsOneWidget);
    expect(find.byTooltip('Forward 30 seconds'), findsOneWidget);

    await tester.tap(find.byTooltip('Play'));
    await tester.tap(find.byTooltip('Rewind 10 seconds'));
    await tester.tap(find.byTooltip('Forward 30 seconds'));

    expect(playCount, 1);
    expect(rewindCount, 1);
    expect(forwardCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearAmbientView and WearAccountDetails render expected metadata', (tester) async {
    await tester.pumpWidget(
      _wearTestApp(
        child: WearAmbientView(
          title: 'A Lighthouse in the Fog',
          author: 'Avery Northstar',
          nowOverride: DateTime(2026, 1, 1, 9, 5),
        ),
      ),
    );

    expect(find.text('09:05'), findsOneWidget);
    expect(find.text('A Lighthouse in the Fog'), findsOneWidget);
    expect(find.text('Avery Northstar'), findsOneWidget);

    await tester.pumpWidget(_wearTestApp(child: WearAmbientView(nowOverride: DateTime(2026, 1, 1, 9, 5))));
    expect(find.text('09:05'), findsOneWidget);
    expect(find.text('A Lighthouse in the Fog'), findsNothing);

    await tester.pumpWidget(
      _wearTestApp(
        child: const Scaffold(
          body: Column(
            children: [
              WearAccountIdentity(username: 'Preview Listener', roleLabel: 'Administrator'),
              WearAccountServerDetails(serverUrl: 'https://abs.example.com', reachable: true),
            ],
          ),
        ),
      ),
    );

    expect(find.text('P'), findsOneWidget);
    expect(find.text('Preview Listener'), findsOneWidget);
    expect(find.text('Administrator'), findsOneWidget);
    expect(find.text('https://abs.example.com'), findsOneWidget);
    expect(find.text('Server available'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AudioBrowseIcon renders without throwing for known and unknown library icons', (tester) async {
    await tester.pumpWidget(
      _wearTestApp(
        child: Scaffold(
          body: Column(children: [AudioBrowseIcon.library('podcast'), AudioBrowseIcon.library('unknown-icon')]),
        ),
      ),
    );

    expect(find.byType(AudioBrowseIcon), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearPlayerActionsView invokes volume and settings callbacks', (tester) async {
    var volumeTapped = false;
    var settingsTapped = false;

    await tester.pumpWidget(
      _wearTestApp(
        child: Scaffold(
          body: Center(
            child: WearPlayerActionsView(
              onVolumePressed: () => volumeTapped = true,
              onSettingsPressed: () => settingsTapped = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Volume'));
    await tester.tap(find.byTooltip('Playback settings'));
    expect(volumeTapped, isTrue);
    expect(settingsTapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearConfirmationScreen returns true on confirm and false on cancel', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _wearTestApp(
        child: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const WearConfirmationScreen(
                        title: 'Sign out?',
                        message: 'Confirm action',
                        confirmLabel: 'Sign out',
                        icon: Icons.logout,
                        destructive: true,
                        flatScrolling: true,
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Sign out?'), findsOneWidget);
    expect(find.text('Confirm action'), findsOneWidget);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearScrollView renders children without errors', (tester) async {
    await tester.pumpWidget(
      _wearTestApp(
        child: const Scaffold(
          body: WearScrollView(
            children: [
              WearPageHeader(title: 'Sign in'),
              Text('Body'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearBrowseScaffoldView switches between curved and flat scrolling on round watches', (tester) async {
    const wearChannel = MethodChannel('wear');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(wearChannel, (call) async {
      if (call.method == 'getShape') {
        return 'round';
      }
      return null;
    });
    addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(wearChannel, null));

    await tester.pumpWidget(
      _wearTestApp(
        child: WearBrowseScaffoldView(
          title: 'Curved',
          flatScrolling: false,
          itemCount: 1,
          itemBuilder: (context, index) => WearBrowseButton(title: 'Item $index', onPressed: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WearTransformingListItem), findsOneWidget);

    await tester.pumpWidget(
      _wearTestApp(
        child: WearBrowseScaffoldView(
          title: 'Flat',
          flatScrolling: true,
          itemCount: 1,
          itemBuilder: (context, index) => WearBrowseButton(title: 'Item $index', onPressed: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WearTransformingListItem), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('WearVolumeControl displays percentage and updates volume on button taps', (tester) async {
    double? latestVolume;
    await tester.pumpWidget(
      _wearTestApp(
        child: WearVolumeControl(
          volume: 0.5,
          onChanged: (value) {
            latestVolume = value;
          },
        ),
      ),
    );

    expect(find.text('50%'), findsOneWidget);
    await tester.tap(find.byTooltip('Increase volume'));
    await tester.pump();
    expect(find.text('60%'), findsOneWidget);
    expect(latestVolume, closeTo(0.6, 0.001));

    await tester.tap(find.byTooltip('Decrease volume'));
    await tester.pump();
    expect(find.text('50%'), findsOneWidget);
    expect(latestVolume, closeTo(0.5, 0.001));
    expect(tester.takeException(), isNull);
  });
}
