import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/player/common/cast_button.dart';
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
          return Text(fallbackTitle);
        }

        return Tooltip(
          message: device.name,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showCastDevicePicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cast_connected, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Flexible(child: Text(device.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        );
      },
    );
  }
}
