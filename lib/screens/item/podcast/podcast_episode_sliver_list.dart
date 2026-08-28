import 'package:material_ui/material_ui.dart';

class PodcastEpisodeSliverList extends StatelessWidget {
  const PodcastEpisodeSliverList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.horizontalPadding,
    required this.maxWidth,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double horizontalPadding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final childCount = itemCount == 0 ? 0 : (itemCount * 2) - 1;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: const Divider(height: 1),
                ),
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: itemBuilder(context, index ~/ 2),
              ),
            );
          },
          childCount: childCount,
          addAutomaticKeepAlives: false,
          semanticIndexCallback: (_, index) => index.isEven ? index ~/ 2 : null,
        ),
      ),
    );
  }
}
