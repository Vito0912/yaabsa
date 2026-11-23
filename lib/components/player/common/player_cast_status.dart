import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/cast_button.dart';
import 'package:yaabsa/features/player/widgets/player_cast_presentation.dart';
import 'package:yaabsa/util/globals.dart';

class PlayerCastStatus extends StatelessWidget {
  const PlayerCastStatus({super.key, required this.fallbackTitle});

  final String fallbackTitle;

  @override
  Widget build(BuildContext context) {
    final casting = audioHandler.casting;
    return StreamBuilder<bool>(
      stream: casting.connected,
      initialData: casting.hasConnectedSession,
      builder: (context, connection) {
        final device = casting.activeDevice;
        if (connection.data != true || device == null) {
          return PlayerCastStatusPresentation(fallbackTitle: fallbackTitle);
        }

        return PlayerCastStatusPresentation(
          fallbackTitle: fallbackTitle,
          deviceName: device.name,
          onPressed: () => showCastDevicePicker(context),
        );
      },
    );
  }
}
