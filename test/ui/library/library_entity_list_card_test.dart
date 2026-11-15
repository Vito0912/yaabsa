import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/library/widgets/library_entity_list_card.dart';

void main() {
  testWidgets('library entity row presents shared details and activation', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              LibraryEntityListCard(
                leading: const Icon(Icons.person_outline_rounded),
                title: 'Mara Ellery',
                subtitle: '  14 books  ',
                description: 'Coastal histories and quiet mysteries.',
                onTap: () => tapCount++,
              ),
              LibraryEntityListCard(
                leading: const Icon(Icons.record_voice_over_rounded),
                title: 'Jonas Vale',
                subtitle: '8 audiobooks',
                description: 'Hidden in compact mode.',
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Mara Ellery'), findsOneWidget);
    expect(find.text('14 books'), findsOneWidget);
    expect(find.text('Coastal histories and quiet mysteries.'), findsOneWidget);
    expect(find.text('Jonas Vale'), findsOneWidget);
    expect(find.text('Hidden in compact mode.'), findsNothing);

    await tester.tap(find.text('Mara Ellery'));
    expect(tapCount, 1);
  });
}
