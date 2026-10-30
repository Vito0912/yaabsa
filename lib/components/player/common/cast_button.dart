import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/cast_device_sheet.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/cast/cast_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

Future<void> showCastDevicePicker(BuildContext context) async {
  if (!CastService.isSupportedPlatform) {
    _showCastMessage(context, 'Casting is unavailable on this platform');
    return;
  }

  final casting = audioHandler.casting;
  if (!casting.hasConnectedSession && audioHandler.isReaderNarration) {
    _showCastMessage(context, 'Casting is unavailable for book narration');
    return;
  }

  if (!casting.hasConnectedSession && audioHandler.currentMediaItem == null) {
    _showCastMessage(context, 'Nothing is currently playing to cast');
    return;
  }

  try {
    final selected = await showModalBottomSheet<CastDevice>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => CastDeviceSheet(casting: casting),
    );
    if (selected == null) {
      return;
    }

    await audioHandler.castToDevice(selected);
    if (context.mounted) {
      _showCastMessage(context, 'Connected to ${selected.name}');
    }
  } catch (error) {
    logger('Unable to cast: $error', tag: 'Casting', level: InfoLevel.warning);
    if (context.mounted) {
      _showCastMessage(context, 'Unable to cast: $error');
    }
  }
}

void _showCastMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class CastButton extends StatelessWidget {
  const CastButton({super.key, this.iconSize});

  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    if (!CastService.isSupportedPlatform) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<bool>(
      stream: audioHandler.casting.connected,
      initialData: audioHandler.casting.hasConnectedSession,
      builder: (context, snapshot) {
        final connected = snapshot.data ?? false;
        return IconButton(
          onPressed: () => showCastDevicePicker(context),
          tooltip: connected ? 'Manage cast device' : 'Connect to a cast device',
          iconSize: iconSize,
          icon: Icon(connected ? Icons.cast_connected : Icons.cast),
        );
      },
    );
  }
}
