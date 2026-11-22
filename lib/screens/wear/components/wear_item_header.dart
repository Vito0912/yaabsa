import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/wear/components/wear_cover.dart';
import 'package:yaabsa/screens/wear/components/wear_item_progress.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';

class WearItemHeader extends StatelessWidget {
  const WearItemHeader({required this.entry, required this.showCover, super.key});

  final CompactBrowseEntry entry;
  final bool showCover;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final subtitle = entry.subtitle?.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showCover) ...[
            LayoutBuilder(
              builder: (context, constraints) {
                final coverSize = (constraints.maxWidth * 0.5).clamp(72.0, 104.0);

                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: WearCover(uri: entry.coverUri, size: coverSize),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
          ],
          Semantics(
            header: true,
            child: Text(
              entry.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, height: 1.2, fontWeight: FontWeight.w700, color: colors.onSurface),
            ),
          ),
          if (subtitle != null && subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.3, color: colors.onSurfaceVariant),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: WearItemProgress(itemId: entry.itemId!, episodeId: entry.episodeId),
          ),
        ],
      ),
    );
  }
}
