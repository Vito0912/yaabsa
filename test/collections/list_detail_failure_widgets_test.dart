import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/main/collection_detail_view.dart';
import 'package:yaabsa/screens/main/playlist_detail_view.dart';

import 'collection_test_support.dart';
import '../playlists/playlist_test_support.dart' as playlists;

class _SettingsWatcher extends UserSettingsWatcher {
  @override
  Stream<int> build() => Stream.value(0);
}

ProviderContainer _container(ABSApi api) {
  return ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      absApiProvider.overrideWithValue(api),
      selectedLibraryProvider.overrideWithValue(null),
      currentUserProvider.overrideWith((ref) => Stream.value(null)),
      serverStatusProvider.overrideWith((ref) => Stream.value(true)),
      userSettingsWatcherProvider.overrideWith(_SettingsWatcher.new),
    ],
  );
}

Future<void> _mount(WidgetTester tester, ProviderContainer container, Widget view) async {
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: Scaffold(body: view)),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final status in [403, 404]) {
    testWidgets('collection detail hides retained data after a $status reload', (tester) async {
      final server = CollectionTestServer([collection('a')]);
      final container = _container(server.api);
      addTearDown(container.dispose);
      final provider = collectionByIdProvider('library', 'a');
      container.listen(provider, (_, _) {});
      await container.read(provider.future);

      server.readStatusById['a'] = status;
      await expectLater(container.refresh(provider.future), throwsException);
      expect(container.read(provider).hasError, isTrue);
      expect(container.read(provider).hasValue, isTrue);

      await _mount(tester, container, const CollectionDetailView(collectionId: 'a', libraryId: 'library'));
      expect(
        find.text(status == 404 ? 'Collection is no longer available' : 'Collection details could not be loaded'),
        findsOneWidget,
      );
      expect(find.text('a'), findsNothing);
    });

    testWidgets('playlist detail hides retained data after a $status reload', (tester) async {
      final server = playlists.PlaylistTestServer([playlists.playlist('a')]);
      final container = _container(server.api);
      addTearDown(container.dispose);
      final provider = playlistByIdProvider('library', 'a');
      container.listen(provider, (_, _) {});
      await container.read(provider.future);

      server.readStatusById['a'] = status;
      await expectLater(container.refresh(provider.future), throwsException);
      expect(container.read(provider).hasError, isTrue);
      expect(container.read(provider).hasValue, isTrue);

      await _mount(tester, container, const PlaylistDetailView(playlistId: 'a', libraryId: 'library'));
      expect(
        find.text(status == 404 ? 'Playlist is no longer available' : 'Playlist details could not be loaded'),
        findsOneWidget,
      );
      expect(find.text('a'), findsNothing);
    });
  }
}
