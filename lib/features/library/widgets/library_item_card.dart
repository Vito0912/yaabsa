import 'package:material_ui/material_ui.dart';

class LibraryItemCard extends StatelessWidget {
  const LibraryItemCard({
    super.key,
    required this.cover,
    required this.title,
    this.subtitle,
    this.compact = false,
    this.isDesktop = false,
    this.canActivate = true,
    this.onTap,
    this.onLongPress,
    this.onContextMenu,
    this.onHoverChanged,
  });

  final Widget cover;
  final String title;
  final Widget? subtitle;
  final bool compact;
  final bool isDesktop;
  final bool canActivate;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<Offset>? onContextMenu;
  final ValueChanged<bool>? onHoverChanged;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cover,
        SizedBox(height: compact ? 6 : 8),
        Text(
          title,
          maxLines: compact ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: compact ? Theme.of(context).textTheme.bodyMedium : null,
        ),
        ?subtitle,
      ],
    );
    final tapEnabled = canActivate ? onTap : null;
    final longPressEnabled = canActivate ? onLongPress : null;

    return Padding(
      padding: EdgeInsets.all(compact ? 4 : 8),
      child: isDesktop
          ? MouseRegion(
              cursor: tapEnabled == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
              onEnter: onHoverChanged == null ? null : (_) => onHoverChanged!(true),
              onExit: onHoverChanged == null ? null : (_) => onHoverChanged!(false),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: tapEnabled,
                onLongPress: longPressEnabled,
                onSecondaryTapUp: onContextMenu == null ? null : (details) => onContextMenu!(details.globalPosition),
                child: content,
              ),
            )
          : InkWell(
              onTap: tapEnabled,
              onLongPress: longPressEnabled,
              borderRadius: BorderRadius.circular(16),
              child: content,
            ),
    );
  }
}
