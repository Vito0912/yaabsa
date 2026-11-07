import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/settings/smart_download_source_editor.dart';
import 'package:yaabsa/models/queue_source.dart';

import 'smart_download_test_support.dart';

const _library = Library(
  id: 'books',
  name: 'Books',
  displayOrder: 0,
  icon: 'books',
  mediaType: 'book',
  provider: 'local',
  createdAt: 0,
  settings: LibrarySettings(),
);

void main() {
  late DownloadTestDatabase db;
  late ProviderContainer container;
  late GoRouter router;
  MediaSourceDescriptor? saved;

  setUp(() async {
    db = DownloadTestDatabase();
    container = await downloadTestContainer(db, DownloadTestProgress(), library: _library);
    saved = null;
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  saved = await showDialog<MediaSourceDescriptor>(
                    context: context,
                    builder: (context) => const SmartDownloadSourceEditor(),
                  );
                },
                child: const Text('Open editor'),
              ),
            );
          },
        ),
      ],
    );
  });

  tearDown(() async {
    router.dispose();
    container.dispose();
    await db.close();
  });

  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();
  }

  YaabsaDropdownField<MediaSourceType> sourceField(WidgetTester tester) {
    return tester.widget(find.byWidgetPredicate((widget) => widget is YaabsaDropdownField<MediaSourceType>));
  }

  YaabsaDropdownField<String> libraryField(WidgetTester tester) {
    return tester.widget(
      find.byWidgetPredicate((widget) => widget is YaabsaDropdownField<String> && widget.label == 'Library'),
    );
  }

  testWidgets('new source types default to All and require no search selection', (tester) async {
    await open(tester);

    for (final type in [
      MediaSourceType.continueListening,
      MediaSourceType.continueSeries,
      MediaSourceType.continueReading,
      MediaSourceType.listeningThreshold,
    ]) {
      sourceField(tester).onChanged!(type);
      await tester.pumpAndSettle();

      final library = libraryField(tester);
      expect(library.value, allLibrariesSourceId);
      expect(library.items.where((item) => item.value == allLibrariesSourceId), hasLength(1));
      expect(
        find.byWidgetPredicate((widget) => widget is StyledTextField && widget.label == 'Search sources'),
        findsNothing,
      );
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Add')).onPressed, isNotNull);

      library.onChanged!('books');
      await tester.pumpAndSettle();
      expect(libraryField(tester).value, 'books');
    }
  });

  testWidgets('leaving an All-library source restores a concrete library for search sources', (tester) async {
    await open(tester);
    sourceField(tester).onChanged!(MediaSourceType.continueListening);
    await tester.pumpAndSettle();
    sourceField(tester).onChanged!(MediaSourceType.series);
    await tester.pumpAndSettle();

    expect(libraryField(tester).value, 'books');
    expect(libraryField(tester).items.where((item) => item.value == allLibrariesSourceId), isEmpty);
    expect(
      find.byWidgetPredicate((widget) => widget is StyledTextField && widget.label == 'Search sources'),
      findsOneWidget,
    );
  });

  testWidgets('a progress source saves its threshold and All-library scope', (tester) async {
    await open(tester);
    sourceField(tester).onChanged!(MediaSourceType.listeningThreshold);
    await tester.pumpAndSettle();
    final trigger = tester.widget<YaabsaDropdownField<ListeningDownloadTrigger>>(
      find.byWidgetPredicate((widget) => widget is YaabsaDropdownField<ListeningDownloadTrigger>),
    );
    trigger.onChanged!(ListeningDownloadTrigger.progress);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byWidgetPredicate((widget) => widget is StyledTextField && widget.label == 'Book progress (%)'),
      '17',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    expect(saved?.type, MediaSourceType.listeningThreshold);
    expect(saved?.libraryId, allLibrariesSourceId);
    expect(saved?.sourceId, '$allLibrariesSourceId::progress');
    expect(saved?.listeningTrigger, ListeningDownloadTrigger.progress);
    expect(saved?.listeningThreshold, 17);
  });
}
