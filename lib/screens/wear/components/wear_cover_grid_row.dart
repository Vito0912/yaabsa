import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/wear/components/wear_cover.dart';
import 'package:yaabsa/ui/components/wear/wear_list_item_content.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';

class WearCoverGridRow extends StatelessWidget {
  const WearCoverGridRow({required this.entries, required this.columns, required this.onOpen, super.key});

  final List<CompactBrowseEntry> entries;
  final int columns;
  final ValueChanged<CompactBrowseEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = (constraints.maxWidth - (columns - 1) * 6) / columns;
          final covers = <Widget>[];
          for (final entry in entries) {
            if (covers.isNotEmpty) {
              covers.add(const SizedBox(width: 6));
            }

            final label = entry.subtitle?.isNotEmpty == true ? '${entry.title}, ${entry.subtitle}' : entry.title;
            covers.add(
              Semantics(
                button: true,
                label: label,
                child: Tooltip(
                  message: entry.title,
                  excludeFromSemantics: true,
                  child: SizedBox.square(
                    dimension: size,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHigh,
                            shape: BoxShape.circle,
                          ),
                        ),
                        WearListItemContent(
                          child: WearCover(uri: entry.coverUri, size: size, circular: true),
                        ),
                        Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(customBorder: const CircleBorder(), onTap: () => onOpen(entry)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return Row(mainAxisAlignment: MainAxisAlignment.center, children: covers);
        },
      ),
    );
  }
}
