import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerQueueItemPresentation extends StatelessWidget {
  const PlayerQueueItemPresentation({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.autoQueued = false,
    this.onRemove,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool autoQueued;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: leading,
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (autoQueued)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(Icons.playlist_add_check_rounded, size: 18, color: Theme.of(context).colorScheme.secondary),
              ),
            YaabsaActionIconButton(
              icon: Icons.close_rounded,
              iconSize: 24,
              buttonSize: 48,
              compact: false,
              tooltip: context.l10n.actionRemoveFromQueue,
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
