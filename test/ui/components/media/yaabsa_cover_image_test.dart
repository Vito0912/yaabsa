import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/previews/media_previews.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';

void main() {
  late final MemoryImage artwork;

  setUpAll(() async {
    final imageBytes = await File('assets/logo_blue_fill.png').readAsBytes();
    artwork = MemoryImage(imageBytes);
  });

  testWidgets('uses the feature placeholder when artwork is unavailable', (tester) async {
    const fallback = Text('Cover unavailable');

    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: YaabsaCoverImage(
            image: null,
            width: 96,
            height: 128,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            placeholder: fallback,
          ),
        ),
      ),
    );

    expect(find.text('Cover unavailable'), findsOneWidget);
    expect(tester.getSize(find.byType(YaabsaCoverImage)), const Size(96, 128));
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('cover preview includes one decoded local artwork image', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CoverImagesPreview(artwork: artwork)),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump();

    final rawImage = tester.widget<RawImage>(find.byType(RawImage));

    expect(rawImage.image, isNotNull);
    expect(find.text('Artwork'), findsOneWidget);
    expect(find.text('Unavailable artwork'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
