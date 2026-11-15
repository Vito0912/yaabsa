import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_sliver_list.dart';

void main() {
  testWidgets('episode list leaves space after its preceding header', (tester) async {
    final headerKey = GlobalKey();
    final episodeKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(key: headerKey, height: 100)),
              PodcastEpisodeSliverList(
                itemCount: 1,
                horizontalPadding: 16,
                maxWidth: 800,
                itemBuilder: (context, index) => SizedBox(key: episodeKey, height: 40),
              ),
            ],
          ),
        ),
      ),
    );

    final headerBottom = tester.getBottomLeft(find.byKey(headerKey)).dy;
    final episodeTop = tester.getTopLeft(find.byKey(episodeKey)).dy;

    expect(episodeTop - headerBottom, 16);
    expect(tester.takeException(), isNull);
  });
}
