part of '../bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoPreferences on BGAudioHandler {
  Future<InternalDownload?> _androidAutoStoredDownload(String itemId, {String? episodeId}) async {
    final user = await _androidAutoCurrentUser();
    if (user == null) {
      return null;
    }

    return _ref.read(appDatabaseProvider).getStoredDownload(itemId, user.id, episodeId: episodeId);
  }

  Future<User?> _androidAutoCurrentUser() async {
    final db = _ref.read(appDatabaseProvider);
    final activeUserId = (await db.getGlobalSetting('activeUserId'))?.value.trim();
    if (activeUserId == null || activeUserId.isEmpty) {
      return null;
    }

    final currentUserAsync = _ref.read(currentUserProvider);
    if (currentUserAsync.hasValue && currentUserAsync.value?.id == activeUserId) {
      return currentUserAsync.value;
    }

    try {
      final currentUser = await _ref.read(currentUserProvider.future);
      return currentUser?.id == activeUserId ? currentUser : null;
    } catch (_) {
      return null;
    }
  }

  Future<Library?> _androidAutoLibraryForId(String libraryId) async {
    final libraries = await _androidAutoIsAutomotiveSystem()
        ? _androidAutoBrowseCache.snapshot?.audioLibraries ?? await _androidAutoFetchLibraries(include: 'stats')
        : await _androidAutoFetchLibraries();
    for (final library in libraries) {
      if (library.id == libraryId) {
        return library;
      }
    }
    return null;
  }

  Future<bool> _androidAutoLibraryIsPodcast(String libraryId) async {
    final library = await _androidAutoLibraryForId(libraryId);
    return library?.mediaType == 'podcast';
  }

  Future<bool> _androidAutoLibrarySortDescending() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoLibrarySortDescending, defaultValue: false);
  }

  Future<bool> _androidAutoPodcastSortDescending() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoPodcastSortDescending, defaultValue: true);
  }

  Future<String> _androidAutoLibrarySortField() async {
    final user = await _androidAutoCurrentUser();
    final sortField = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(
          user?.id,
          SettingKeys.androidAutoLibrarySortField,
          defaultValue: _androidAutoSortFieldTitle,
        );

    if (!_androidAutoBookSortFieldToApiSort.containsKey(sortField)) {
      return _androidAutoSortFieldTitle;
    }

    return sortField;
  }

  Future<String> _androidAutoPodcastSortField() async {
    final user = await _androidAutoCurrentUser();
    final sortField = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(
          user?.id,
          SettingKeys.androidAutoPodcastSortField,
          defaultValue: _androidAutoSortFieldAdded,
        );

    if (!_androidAutoPodcastSortFieldToApiSort.containsKey(sortField)) {
      return _androidAutoSortFieldAdded;
    }

    return sortField;
  }

  Future<bool> _androidAutoSortDescendingForLibrary(String libraryId) async {
    if (await _androidAutoLibraryIsPodcast(libraryId)) {
      return _androidAutoPodcastSortDescending();
    }

    return _androidAutoLibrarySortDescending();
  }

  Future<String> _androidAutoLibrarySortApiField() async {
    final sortField = await _androidAutoLibrarySortField();
    return _androidAutoBookSortFieldToApiSort[sortField] ??
        _androidAutoBookSortFieldToApiSort[_androidAutoSortFieldTitle]!;
  }

  Future<String> _androidAutoPodcastSortApiField() async {
    final sortField = await _androidAutoPodcastSortField();
    return _androidAutoPodcastSortFieldToApiSort[sortField] ??
        _androidAutoPodcastSortFieldToApiSort[_androidAutoSortFieldAdded]!;
  }

  Future<String> _androidAutoSortApiFieldForLibrary(String libraryId) async {
    if (await _androidAutoLibraryIsPodcast(libraryId)) {
      return _androidAutoPodcastSortApiField();
    }

    return _androidAutoLibrarySortApiField();
  }

  Future<bool> _androidAutoGroupByLettersEnabled() async {
    final user = await _androidAutoCurrentUser();
    return _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(user?.id, SettingKeys.androidAutoGroupByLetters, defaultValue: true);
  }

  Future<bool> _androidAutoHasServerConnection() async {
    final status = _ref.read(serverStatusProvider);
    if (status.hasValue) {
      return status.value ?? false;
    }

    final api = _ref.read(absApiProvider);
    if (api == null) {
      return false;
    }

    try {
      await api.getMeApi().getPing();
      return true;
    } catch (_) {
      logger('Failed to ping server for Android Auto connection check', tag: 'AudioHandler', level: InfoLevel.warning);
      return false;
    }
  }
}
