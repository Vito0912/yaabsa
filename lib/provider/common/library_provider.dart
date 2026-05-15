import 'dart:async';
import 'dart:convert';

import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_provider.g.dart';

final Map<String, Library> _selectedLibraryCacheByUserId = {};
final Map<String, List<Library>> _userLibrariesCacheByUserId = {};
final Set<String> _selectedLibrarySnapshotHydratedUserIds = <String>{};

const String _selectedLibrarySnapshotSettingKey = 'selectedLibrarySnapshot';

/// Provider to fetch all libraries for the current user.
@riverpod
Future<List<Library>> userLibraries(Ref ref) async {
  final activeUserId = ref.watch(currentUserProvider).value?.id;

  final api = ref.watch(absApiProvider);
  if (api == null) {
    if (activeUserId != null) {
      final cachedLibraries = _userLibrariesCacheByUserId[activeUserId];
      if (cachedLibraries != null) {
        logger(
          'UserLibrariesProvider: ABSApi is null, using ${cachedLibraries.length} cached libraries for user $activeUserId.',
          tag: 'UserLibrariesProvider',
          level: InfoLevel.warning,
        );
        return cachedLibraries;
      }
    }

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
      final libraries = List<Library>.unmodifiable(librariesResponse.data!.libraries);
      if (activeUserId != null) {
        _userLibrariesCacheByUserId[activeUserId] = libraries;
      }
      return libraries;
    }
  } catch (e, s) {
    logger('Error fetching libraries: $e\\n$s', tag: 'UserLibrariesProvider');

    if (activeUserId != null) {
      final cachedLibraries = _userLibrariesCacheByUserId[activeUserId];
      if (cachedLibraries != null) {
        logger(
          'UserLibrariesProvider: Using ${cachedLibraries.length} cached libraries after fetch error for user $activeUserId.',
          tag: 'UserLibrariesProvider',
          level: InfoLevel.warning,
        );
        return cachedLibraries;
      }
    }
  }

  return [];
}

@riverpod
class SelectedLibraryId extends _$SelectedLibraryId {
  @override
  Stream<String?> build() {
    final db = ref.watch(appDatabaseProvider);
    final userId = ref.watch(activeUserIdProvider).value;
    final librariesAsync = ref.watch(userLibrariesProvider);

    if (userId == null) {
      _selectedLibraryCacheByUserId.clear();
      _selectedLibrarySnapshotHydratedUserIds.clear();
      logger('SelectedLibraryIdProvider: No active user, returning null stream.', tag: 'SelectedLibraryId');
      return Stream.value(null);
    }

    if (_selectedLibrarySnapshotHydratedUserIds.add(userId)) {
      unawaited(_hydrateSelectedLibraryCache(userId: userId));
    }

    final stream = db.watchUserSetting(userId, 'selectedLibraryId').map((e) => e?.value);

    if (librariesAsync.hasValue) {
      final libraries = librariesAsync.value ?? const <Library>[];
      unawaited(_ensureSelectionForLibraries(userId: userId, libraries: libraries));
    }

    logger('SelectedLibraryIdProvider: Watching selected library ID for user $userId.', tag: 'SelectedLibraryId');
    return stream;
  }

  Future<void> _ensureSelectionForLibraries({required String userId, required List<Library> libraries}) async {
    final db = ref.read(appDatabaseProvider);
    final currentSelectedId = (await db.getUserSetting(userId, 'selectedLibraryId'))?.value;

    if (libraries.isEmpty) {
      return;
    }

    final hasValidSelection = currentSelectedId != null && libraries.any((library) => library.id == currentSelectedId);

    final resolvedLibrary = hasValidSelection
        ? libraries.firstWhere((library) => library.id == currentSelectedId)
        : libraries.first;

    _selectedLibraryCacheByUserId[userId] = resolvedLibrary;
    await _persistSelectedLibrarySnapshot(userId: userId, library: resolvedLibrary);

    if (hasValidSelection) {
      return;
    }

    final fallbackLibraryId = resolvedLibrary.id;

    if (currentSelectedId == null) {
      logger(
        'SelectedLibraryIdProvider: No library selected for user $userId. Auto-selecting first library: $fallbackLibraryId.',
        tag: 'SelectedLibraryId',
      );
    } else {
      logger(
        'SelectedLibraryIdProvider: Selected library "$currentSelectedId" is unavailable for user $userId. Falling back to first library: $fallbackLibraryId.',
        tag: 'SelectedLibraryId',
        level: InfoLevel.warning,
      );
    }

    await db.setUserSetting(userId, 'selectedLibraryId', fallbackLibraryId);
  }

  Future<void> _hydrateSelectedLibraryCache({required String userId}) async {
    final db = ref.read(appDatabaseProvider);

    try {
      final rawSnapshot = (await db.getUserSetting(userId, _selectedLibrarySnapshotSettingKey))?.value;
      if (rawSnapshot == null || rawSnapshot.trim().isEmpty) {
        return;
      }

      final decoded = jsonDecode(rawSnapshot);
      if (decoded is! Map) {
        return;
      }

      final library = Library.fromJson(Map<String, dynamic>.from(decoded));
      _selectedLibraryCacheByUserId[userId] = library;
      ref.invalidate(selectedLibraryProvider);
    } catch (e, s) {
      logger(
        'SelectedLibraryIdProvider: Failed to hydrate selected library snapshot for user $userId: $e\n$s',
        tag: 'SelectedLibraryId',
        level: InfoLevel.warning,
      );
    }
  }

  Future<void> _persistSelectedLibrarySnapshot({required String userId, required Library library}) async {
    final db = ref.read(appDatabaseProvider);
    final encodedSnapshot = jsonEncode(library.toJson());

    try {
      final existingSnapshot = (await db.getUserSetting(userId, _selectedLibrarySnapshotSettingKey))?.value;
      if (existingSnapshot == encodedSnapshot) {
        return;
      }

      await db.setUserSetting(userId, _selectedLibrarySnapshotSettingKey, encodedSnapshot);
    } catch (e, s) {
      logger(
        'SelectedLibraryIdProvider: Failed to persist selected library snapshot for user $userId: $e\n$s',
        tag: 'SelectedLibraryId',
        level: InfoLevel.warning,
      );
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

    final libraries = ref.read(userLibrariesProvider).value ?? const <Library>[];
    for (final library in libraries) {
      if (library.id == libraryId) {
        _selectedLibraryCacheByUserId[userId] = library;
        await _persistSelectedLibrarySnapshot(userId: userId, library: library);
        break;
      }
    }
  }
}

@Riverpod(keepAlive: true)
Library? selectedLibrary(Ref ref) {
  final activeUserId = ref.watch(activeUserIdProvider).value;
  if (activeUserId == null) {
    _selectedLibraryCacheByUserId.clear();
    _selectedLibrarySnapshotHydratedUserIds.clear();
    return null;
  }

  final cachedLibrary = _selectedLibraryCacheByUserId[activeUserId];
  final librariesAsync = ref.watch(userLibrariesProvider);
  final selectedIdAsync = ref.watch(selectedLibraryIdProvider);

  final libraries = librariesAsync.value;
  final selectedId = selectedIdAsync.value;

  final isLibrariesPending = libraries == null && (librariesAsync.isLoading || !librariesAsync.hasValue);
  final isSelectedIdPending = selectedId == null && (selectedIdAsync.isLoading || !selectedIdAsync.hasValue);
  final hasTransientFailure = librariesAsync.hasError || selectedIdAsync.hasError;

  if (isLibrariesPending || isSelectedIdPending || hasTransientFailure) {
    return cachedLibrary;
  }

  if (libraries == null || libraries.isEmpty) {
    if (cachedLibrary != null) {
      logger(
        'SelectedLibraryProvider: Libraries unavailable, using cached selected library ${cachedLibrary.id}.',
        tag: 'SelectedLibrary',
        level: InfoLevel.debug,
      );
      return cachedLibrary;
    }

    _selectedLibraryCacheByUserId.remove(activeUserId);
    logger(
      'SelectedLibraryProvider: Libraries unavailable and no cache. Libraries: ${libraries?.length}',
      tag: 'SelectedLibrary',
    );
    return null;
  }

  if (selectedId == null) {
    if (cachedLibrary != null) {
      logger(
        'SelectedLibraryProvider: Selected library ID unavailable, using cached selected library ${cachedLibrary.id}.',
        tag: 'SelectedLibrary',
        level: InfoLevel.debug,
      );
      return cachedLibrary;
    }

    _selectedLibraryCacheByUserId.remove(activeUserId);
    logger('SelectedLibraryProvider: Selected library ID is null and no cache exists.', tag: 'SelectedLibrary');
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

    if (cachedLibrary != null) {
      logger(
        'SelectedLibraryProvider: Selected library ID "$selectedId" not found in fetched libraries. Using cached selected library ${cachedLibrary.id}.',
        tag: 'SelectedLibrary',
        level: InfoLevel.warning,
      );
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
