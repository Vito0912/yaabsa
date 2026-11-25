import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

class PlayerCastButtonPresentation extends StatelessWidget {
  const PlayerCastButtonPresentation({super.key, required this.connected, required this.onPressed, this.iconSize});

  final bool connected;
  final VoidCallback? onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return YaabsaActionIconButton(
      icon: connected ? Icons.cast_connected : Icons.cast,
      iconSize: iconSize ?? 24,
      buttonSize: 48,
      compact: false,
      tooltip: context.l10n.castDevices,
      onPressed: onPressed,
    );
  }
}

class PlayerCastStatusPresentation extends StatelessWidget {
  const PlayerCastStatusPresentation({super.key, required this.fallbackTitle, this.deviceName, this.onPressed});

  final String fallbackTitle;
  final String? deviceName;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final name = deviceName?.trim();
    if (name == null || name.isEmpty) {
      return Text(fallbackTitle);
    }

    return Tooltip(
      message: name,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cast_connected, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Flexible(child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
