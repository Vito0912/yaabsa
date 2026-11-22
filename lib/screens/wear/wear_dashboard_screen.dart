import 'package:yaabsa/ui/components/media/audio_browse_icon.dart';
import 'package:yaabsa/screens/wear/wear_settings_screen.dart';
import 'package:yaabsa/screens/wear/components/wear_cover.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/provider/wear/wear_browse_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/screens/wear/wear_browse_screen.dart';
import 'package:yaabsa/screens/wear/wear_player_screen.dart';
import 'package:yaabsa/screens/wear/wear_account_screen.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';

class WearDashboardScreen extends ConsumerWidget {
  const WearDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void browse(String title, CompactBrowseSection section) {
      ref.invalidate(wearBrowseProvider(compactBrowseQuery(section)));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WearBrowseScreen(title: title, query: compactBrowseQuery(section)),
        ),
      );
    }

    return StreamBuilder<MediaItem?>(
      stream: wearAudioHandler.mediaItem,
      initialData: wearAudioHandler.mediaItem.value,
      builder: (context, snapshot) {
        final children = <Widget>[
          if (snapshot.data != null)
            WearBrowseButton(
              title: snapshot.data!.title,
              subtitle: 'Now playing',
              primary: true,
              leading: WearCover(uri: snapshot.data!.artUri),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WearPlayerScreen()));
              },
            ),
          WearBrowseButton(
            title: 'Downloads',
            leading: const AudioBrowseIcon(name: 'download'),
            onPressed: () => browse('Downloads', CompactBrowseSection.downloads),
          ),
          WearBrowseButton(
            title: 'Continue listening',
            leading: const AudioBrowseIcon(name: 'continue_ic'),
            onPressed: () => browse('Continue listening', CompactBrowseSection.continueListening),
          ),
          WearBrowseButton(
            title: 'Libraries',
            leading: const AudioBrowseIcon(name: 'apps'),
            onPressed: () => browse('Libraries', CompactBrowseSection.libraries),
          ),
          WearBrowseButton(
            title: 'Settings',
            icon: Icons.settings_outlined,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WearSettingsScreen()));
            },
          ),
          WearBrowseButton(
            title: 'Account',
            icon: Icons.account_circle_outlined,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WearAccountScreen()));
            },
          ),
        ];
        return WearBrowseScaffold(itemCount: children.length, itemBuilder: (context, index) => children[index]);
      },
    );
  }
}
