import 'dart:async';

import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_provider.g.dart';

final Map<String, Library> _selectedLibraryCacheByUserId = {};

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
    final userId = ref.watch(activeUserIdProvider).value;

    if (userId == null) {
      logger('SelectedLibraryIdProvider: No active user, returning null stream.', tag: 'SelectedLibraryId');
      return Stream.value(null);
    }

    final stream = db.watchUserSetting(userId, 'selectedLibraryId').map((e) => e?.value);

    unawaited(_maybeAutoSelectFirstLibrary(userId));

    logger('SelectedLibraryIdProvider: Watching selected library ID for user $userId.', tag: 'SelectedLibraryId');
    return stream;
  }

  Future<void> _maybeAutoSelectFirstLibrary(String userId) async {
    final db = ref.read(appDatabaseProvider);
    final currentSelectedId = (await db.getUserSetting(userId, 'selectedLibraryId'))?.value;

    if (currentSelectedId == null) {
      try {
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
      } catch (e, s) {
        logger(
          'SelectedLibraryIdProvider: Failed to auto-select first library for user $userId: $e\\n$s',
          tag: 'SelectedLibraryId',
          level: InfoLevel.warning,
        );
      }
    }
  }

  Future<void> set(String? libraryId) async {
    final db = ref.read(appDatabaseProvider);
    final userId = ref.read(activeUserIdProvider).value;
    if (userId == null || libraryId == null) return;
    logger(
      'SelectedLibraryIdNotifier: Setting selected library ID to $libraryId for user $userId.',
      tag: 'SelectedLibraryId',
    );
    await db.setUserSetting(userId, 'selectedLibraryId', libraryId);
  }
}

@Riverpod(keepAlive: true)
Library? selectedLibrary(Ref ref) {
  final activeUserId = ref.watch(activeUserIdProvider).value;
  if (activeUserId == null) {
    _selectedLibraryCacheByUserId.clear();
    return null;
  }

  final cachedLibrary = _selectedLibraryCacheByUserId[activeUserId];
  final librariesAsync = ref.watch(userLibrariesProvider);
  final selectedIdAsync = ref.watch(selectedLibraryIdProvider);

  final libraries = librariesAsync.value;
  final selectedId = selectedIdAsync.value;

  final isLibrariesPending = libraries == null && (librariesAsync.isLoading || !librariesAsync.hasValue);
  final isSelectedIdPending = selectedId == null && (selectedIdAsync.isLoading || !selectedIdAsync.hasValue);
  if (isLibrariesPending || isSelectedIdPending) {
    return cachedLibrary;
  }

  if (libraries == null || libraries.isEmpty || selectedId == null) {
    _selectedLibraryCacheByUserId.remove(activeUserId);
    logger(
      'SelectedLibraryProvider: Libraries or selectedId is null/empty. Libraries: ${libraries?.length}, SelectedID: $selectedId',
      tag: 'SelectedLibrary',
    );
    return null;
  }

  try {
    final library = libraries.firstWhere((lib) => lib.id == selectedId);
    _selectedLibraryCacheByUserId[activeUserId] = library;
    logger(
      'SelectedLibraryProvider: Found selected library: ${library.name} (ID: ${library.id})',
      tag: 'SelectedLibrary',
    );
    return library;
  } catch (e) {
    if (librariesAsync.isLoading || selectedIdAsync.isLoading) {
      return cachedLibrary;
    }

    _selectedLibraryCacheByUserId.remove(activeUserId);
    logger(
      'SelectedLibraryProvider: Selected library ID "$selectedId" not found in user libraries. Error: $e',
      tag: 'SelectedLibrary',
    );
    return null;
  }
}
