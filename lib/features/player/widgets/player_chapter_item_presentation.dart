import 'package:material_ui/material_ui.dart';

class PlayerChapterItemPresentation extends StatelessWidget {
  const PlayerChapterItemPresentation({
    super.key,
    required this.title,
    required this.timeRange,
    this.selected = false,
    this.onPressed,
  });

  final String title;
  final String timeRange;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(timeRange),
        selected: selected,
        selectedTileColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
        onTap: onPressed,
      ),
    );
  }
}
