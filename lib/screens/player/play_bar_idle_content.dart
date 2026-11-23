import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/features/player/widgets/mini_player_cover.dart';
import 'package:yaabsa/features/player/widgets/mini_player_metadata_presentation.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';

class PlayBarIdleContent extends StatelessWidget {
  const PlayBarIdleContent({
    super.key,
    required this.snapshot,
    required this.isMobile,
    required this.requestHeaders,
    required this.attachedToBottom,
    required this.mobileCoverSize,
    required this.mobileCoverRadius,
    required this.desktopCoverWidth,
    required this.desktopCoverRadius,
  });

  final LastPlayedMiniPlayerSnapshot snapshot;
  final bool isMobile;
  final Map<String, String> requestHeaders;
  final bool attachedToBottom;
  final double mobileCoverSize;
  final double mobileCoverRadius;
  final double desktopCoverWidth;
  final double desktopCoverRadius;

  @override
  Widget build(BuildContext context) {
    final coverRadius = desktopCoverRadius;
    final coverUri = libraryItemCoverUri(snapshot.cover);
    final metadata = MiniPlayerMetadataPresentation(title: snapshot.title, subtitle: _subtitleFor(snapshot));

    if (isMobile) {
      return Row(
        children: [
          SizedBox(
            width: mobileCoverSize,
            height: mobileCoverSize,
            child: MiniPlayerCover(coverUri: coverUri, borderRadius: mobileCoverRadius, requestHeaders: requestHeaders),
          ),
          const SizedBox(width: 10),
          Expanded(child: metadata),
          const ControlButton(),
        ],
      );
    }

    return Row(
      children: [
        SizedBox(
          width: desktopCoverWidth,
          height: desktopCoverWidth,
          child: MiniPlayerCover(coverUri: coverUri, borderRadius: coverRadius, requestHeaders: requestHeaders),
        ),
        const SizedBox(width: 10),
        Expanded(child: metadata),
        const ControlButton(),
      ],
    );
  }

  String? _subtitleFor(LastPlayedMiniPlayerSnapshot snapshot) {
    final parts = <String>[
      if (snapshot.subtitle != null && snapshot.subtitle!.trim().isNotEmpty) snapshot.subtitle!.trim(),
      if (snapshot.author != null && snapshot.author!.trim().isNotEmpty) snapshot.author!.trim(),
    ];

    if (parts.isEmpty) {
      return null;
    }

    return parts.join(' - ');
  }
}
