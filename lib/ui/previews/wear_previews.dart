import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/media_play_button.dart';
import 'package:yaabsa/ui/components/media/audio_browse_icon.dart';
import 'package:yaabsa/ui/components/wear/wear_account_details.dart';
import 'package:yaabsa/ui/components/wear/wear_ambient_view.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_button.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_scaffold.dart';
import 'package:yaabsa/ui/components/wear/wear_confirmation_screen.dart';
import 'package:yaabsa/ui/components/wear/wear_list_item_content.dart';
import 'package:yaabsa/ui/components/wear/wear_player_controls.dart';
import 'package:yaabsa/ui/components/wear/wear_volume_control.dart';
import 'package:yaabsa/ui/theme/wear_theme.dart';

Widget wearPreviewWrapper(Widget child) {
  return Theme(data: buildWearTheme(ThemeData.dark(useMaterial3: true)), child: child);
}

@Preview(name: 'Wear browse curved / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearBrowseCurvedPreview() => const WearBrowsePreview(flatScrolling: false);

@Preview(name: 'Wear browse flat / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearBrowseFlatPreview() => const WearBrowsePreview(flatScrolling: true);

@Preview(name: 'Wear cover grid / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearCoverGridPreview() => const WearCoverGridPreview();

@Preview(name: 'Wear player controls / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearPlayerControlsPreview() => const WearPlayerControlsPreview();

@Preview(name: 'Wear volume / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearVolumePreview() => const WearVolumePreview();

@Preview(name: 'Wear settings / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearSettingsPreview() => const WearSettingsPreview();

@Preview(name: 'Wear confirmation / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearConfirmationPreview() => const WearConfirmationPreview();

@Preview(name: 'Wear ambient metadata / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearAmbientMetadataPreview() => const WearAmbientPreview(showMetadata: true);

@Preview(name: 'Wear ambient clock / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearAmbientClockPreview() => const WearAmbientPreview(showMetadata: false);

@Preview(name: 'Wear account / AMOLED', size: Size(227, 227), wrapper: wearPreviewWrapper)
Widget wearAccountPreview() => const WearAccountPreview();

class WearBrowsePreview extends StatelessWidget {
  const WearBrowsePreview({required this.flatScrolling, super.key});

  final bool flatScrolling;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      WearBrowseButton(
        title: 'A Lighthouse in the Fog',
        subtitle: 'Now playing',
        primary: true,
        icon: Icons.headphones,
        onPressed: () {},
      ),
      WearBrowseButton(
        title: 'Downloads',
        leading: const AudioBrowseIcon(name: 'download'),
        progress: 0.45,
        onPressed: () {},
      ),
      WearBrowseButton(
        title: 'Continue listening',
        leading: const AudioBrowseIcon(name: 'continue_ic'),
        onPressed: () {},
      ),
      WearBrowseButton(
        title: 'Libraries',
        leading: const AudioBrowseIcon(name: 'apps'),
        onPressed: () {},
      ),
    ];

    return WearBrowseScaffoldView(
      title: 'YAABSA',
      flatScrolling: flatScrolling,
      nowOverride: DateTime(2026, 1, 1, 14, 30),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}

class WearCoverGridPreview extends StatelessWidget {
  const WearCoverGridPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Widget buildGridRow(List<IconData> icons) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const columns = 3;
            final size = (constraints.maxWidth - (columns - 1) * 6) / columns;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < icons.length; index++) ...[
                  if (index > 0) const SizedBox(width: 6),
                  SizedBox.square(
                    dimension: size,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: colors.surfaceContainerHigh, shape: BoxShape.circle),
                      child: WearListItemContent(
                        child: Icon(icons[index], size: size * 0.48, color: colors.onSurfaceVariant),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      );
    }

    final rows = <Widget>[
      buildGridRow([Icons.headphones, Icons.menu_book, Icons.podcasts]),
      buildGridRow([Icons.library_music, Icons.auto_stories, Icons.mic]),
    ];

    return WearBrowseScaffoldView(
      title: 'Cover grid',
      flatScrolling: true,
      nowOverride: DateTime(2026, 1, 1, 14, 30),
      itemCount: rows.length,
      itemBuilder: (context, index) => rows[index],
    );
  }
}

class WearPlayerControlsPreview extends StatelessWidget {
  const WearPlayerControlsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WearPlaybackControlsView(
              isPlaying: true,
              rewindSeconds: 10,
              forwardSeconds: 30,
              progress: 0.35,
              onPlayPause: () {},
              onRewind: () {},
              onForward: () {},
            ),
            const SizedBox(height: 10),
            WearPlayerActionsView(onVolumePressed: () {}, onSettingsPressed: () {}),
            const SizedBox(height: 10),
            YaabsaMediaPlayButton(
              style: YaabsaMediaPlayButtonStyle.scalloped,
              size: 56,
              tooltip: 'Play',
              isPlaying: false,
              isFinished: false,
              isLoading: false,
              progress: 0.65,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class WearVolumePreview extends StatelessWidget {
  const WearVolumePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return WearVolumeControl(volume: 0.65, onChanged: (_) {});
  }
}

class WearSettingsPreview extends StatelessWidget {
  const WearSettingsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = <Widget>[
      WearBrowseButton(title: 'Playback speed', subtitle: '1.25×', icon: Icons.speed, onPressed: () {}),
      WearBrowseButton(
        title: 'Cover background',
        titleLines: 2,
        subtitle: 'On',
        icon: Icons.image_outlined,
        trailing: Icon(Icons.check_circle_rounded, size: 24, color: colors.primary),
        onPressed: () {},
      ),
      WearBrowseButton(
        title: 'Flat scrolling',
        titleLines: 2,
        subtitle: 'Off',
        icon: Icons.view_agenda_outlined,
        trailing: Icon(Icons.circle_outlined, size: 24, color: colors.onSurfaceVariant),
        onPressed: () {},
      ),
    ];

    return WearBrowseScaffoldView(
      title: 'Settings',
      flatScrolling: true,
      nowOverride: DateTime(2026, 1, 1, 14, 30),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}

class WearConfirmationPreview extends StatelessWidget {
  const WearConfirmationPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return WearConfirmationScreen(
      title: 'Sign out?',
      message: 'You will need to sign in again to stream on this watch.',
      confirmLabel: 'Sign out',
      icon: Icons.logout,
      destructive: true,
      flatScrolling: true,
      nowOverride: DateTime(2026, 1, 1, 14, 30),
    );
  }
}

class WearAmbientPreview extends StatelessWidget {
  const WearAmbientPreview({required this.showMetadata, super.key});

  final bool showMetadata;

  @override
  Widget build(BuildContext context) {
    return WearAmbientView(
      title: showMetadata ? 'A Lighthouse in the Fog' : null,
      author: showMetadata ? 'Avery Northstar' : null,
      nowOverride: DateTime(2026, 1, 1, 14, 30),
    );
  }
}

class WearAccountPreview extends StatelessWidget {
  const WearAccountPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const WearAccountIdentity(username: 'Preview Listener', roleLabel: 'Listener'),
      const WearAccountServerDetails(serverUrl: 'https://abs.example.com', reachable: true),
    ];
    return WearBrowseScaffoldView(
      title: 'Account',
      flatScrolling: true,
      nowOverride: DateTime(2026, 1, 1, 14, 30),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }
}
