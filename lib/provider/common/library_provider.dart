import 'package:buchshelfly/api/library/library.dart';
import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_provider.g.dart';

/// Provider to fetch all libraries for the current user.
@riverpod
Future<List<Library>> userLibraries(Ref ref) async {
  final api = ref.watch(absApiProvider);
  if (api == null) {
    logger(
      'UserLibrariesProvider: ABSApi is null, returning empty list.',
      tag: 'UserLibrariesProvider',
      level: InfoLevel.warning,
    );
    return [];
  }
  try {
    final librariesResponse = await api.getLibraryApi().getLibraries();
    if (librariesResponse.data != null) {
      return librariesResponse.data!.libraries;
    }
  } catch (e, s) {
    logger('Error fetching libraries: $e\\n$s', tag: 'UserLibrariesProvider');
  }
  return [];
}

@riverpod
class SelectedLibraryId extends _$SelectedLibraryId {
  @override
  Stream<String?> build() {
    final db = ref.watch(appDatabaseProvider);
    final userId = ref.watch(currentUserProvider).value?.id;

    if (userId == null) {
      logger('SelectedLibraryIdProvider: No active user, returning null stream.', tag: 'SelectedLibraryId');
      return Stream.value(null);
    }

    final stream = db.watchSelectedLibraryId(userId);

    _maybeAutoSelectFirstLibrary(userId);

    logger('SelectedLibraryIdProvider: Watching selected library ID for user $userId.', tag: 'SelectedLibraryId');
    return stream;
  }

  Future<void> _maybeAutoSelectFirstLibrary(String userId) async {
    final db = ref.read(appDatabaseProvider);
    final currentSelectedId = await db.getSelectedLibraryId(userId);

    if (currentSelectedId == null) {
      final libraries = await ref.read(userLibrariesProvider.future);
      if (libraries.isNotEmpty) {
        final firstLibraryId = libraries.first.id;
        logger(
          'SelectedLibraryIdProvider: No library selected for user $userId. Auto-selecting first library: $firstLibraryId.',
          tag: 'SelectedLibraryId',
        );
        await set(firstLibraryId);
      } else {
        logger(
          'SelectedLibraryIdProvider: No library selected for user $userId and no libraries available to auto-select.',
          tag: 'SelectedLibraryId',
        );
      }
    }
  }

  Future<void> set(String? libraryId) async {
    final db = ref.read(appDatabaseProvider);
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null || libraryId == null) return;
    logger(
      'SelectedLibraryIdNotifier: Setting selected library ID to $libraryId for user $userId.',
      tag: 'SelectedLibraryId',
    );
    await db.setSelectedLibraryId(userId, libraryId);
  }
}

@Riverpod(keepAlive: true)
Library? selectedLibrary(Ref ref) {
  final libraries = ref.watch(userLibrariesProvider).value;
  final selectedId = ref.watch(selectedLibraryIdProvider).value;

  if (libraries == null || libraries.isEmpty || selectedId == null) {
    logger(
      'SelectedLibraryProvider: Libraries or selectedId is null/empty. Libraries: ${libraries?.length}, SelectedID: $selectedId',
      tag: 'SelectedLibrary',
    );
    return null;
  }

  try {
    final library = libraries.firstWhere((lib) => lib.id == selectedId);
    logger(
      'SelectedLibraryProvider: Found selected library: ${library.name} (ID: ${library.id})',
      tag: 'SelectedLibrary',
    );
    return library;
  } catch (e) {
    logger(
      'SelectedLibraryProvider: Selected library ID "$selectedId" not found in user libraries. Error: $e',
      tag: 'SelectedLibrary',
    );
    return null;
  }
}
