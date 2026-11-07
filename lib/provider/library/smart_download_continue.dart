part of 'smart_download_provider.dart';

extension _SmartDownloadContinue on SmartDownloadManager {
  bool _continueDownloadsEnabled(String userId) {
    return _managerRef
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(userId, SettingKeys.downloadContinueListeningAndSeries, defaultValue: false);
  }

  Future<Set<PlayableRef>> _continueShelfReferences(_SmartDownloadSnapshot snapshot) async {
    final user = _managerRef.read(currentUserProvider).value;
    if (user == null || !_continueDownloadsEnabled(user.id)) {
      return <PlayableRef>{};
    }

    final library = _managerRef.read(selectedLibraryProvider);
    if (library == null) {
      return <PlayableRef>{};
    }

    final personalized = await _loadPersonalizedLibrary(library.id);
    final continueListeningItems = personalized?.continueListening?.entities ?? const <LibraryItem>[];
    final continueSeriesItems = personalized?.continueSeries?.entities ?? const <LibraryItem>[];
    if (continueListeningItems.isEmpty && continueSeriesItems.isEmpty) {
      return <PlayableRef>{};
    }

    final references = <PlayableRef>{};
    final seenItemIds = <String>{};
    for (final item in continueListeningItems) {
      if (seenItemIds.add(item.id)) {
        references.addAll(await _continueItemReferences(item, snapshot));
      }
    }
    for (final item in continueSeriesItems) {
      if (seenItemIds.add(item.id)) {
        references.addAll(await _continueItemReferences(item, snapshot));
      }
    }
    return references;
  }

  Future<Set<PlayableRef>> _continueItemReferences(LibraryItem item, _SmartDownloadSnapshot snapshot) async {
    if (item.mediaType == 'podcast' || item.media?.podcastMedia != null) {
      return _continuePodcastReferences(item, snapshot);
    }

    final currentReference = PlayableRef(itemId: item.id);
    final currentProgress = snapshot.progressByKey[mediaProgressKey(item.id)];
    final references = <PlayableRef>{};
    if (currentProgress?.isFinished != true && !_recentlyCompletedContinueReferences.contains(_key(currentReference))) {
      references.add(currentReference);
    }
    return references;
  }

  Future<PersonalizedLibrary?> _loadPersonalizedLibrary(String libraryId) async {
    try {
      return await _managerRef.read(personalizedLibraryProvider(libraryId).future);
    } catch (e, s) {
      logger(
        'Could not load Continue Listening for smart downloads: $e\n$s',
        tag: 'SmartDownloadManager',
        level: InfoLevel.debug,
      );
      return null;
    }
  }

  Future<Set<PlayableRef>> _continuePodcastReferences(LibraryItem shelfItem, _SmartDownloadSnapshot snapshot) async {
    final activeProgress = snapshot.activePodcastProgress[shelfItem.id];
    if (activeProgress == null && snapshot.finishedPodcastItems.contains(shelfItem.id)) {
      return <PlayableRef>{};
    }

    var episodeId = activeProgress?.episodeId;
    if (episodeId == null) {
      var episodes = shelfItem.media?.podcastMedia?.episodes ?? const <Episode>[];
      if (!episodes.any((episode) => episode.audioFile != null)) {
        try {
          final item = await _managerRef.read(libraryItemProvider(shelfItem.id).future);
          episodes = item.media?.podcastMedia?.episodes ?? episodes;
        } catch (_) {}
      }

      episodeId = episodes.where((episode) => episode.audioFile != null).firstOrNull?.id;
    }
    if (episodeId == null) {
      return <PlayableRef>{};
    }

    final reference = PlayableRef(itemId: shelfItem.id, episodeId: episodeId);
    if (_recentlyCompletedContinueReferences.contains(_key(reference))) {
      return <PlayableRef>{};
    }

    return <PlayableRef>{reference};
  }

  Future<void> _enqueueContinueReferences({
    required String userId,
    required Set<PlayableRef> references,
    required int generation,
    required _SmartDownloadSnapshot snapshot,
  }) async {
    if (references.isEmpty) {
      return;
    }
    final preferredType = _managerRef
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(userId, SettingKeys.downloadTypePreference, defaultValue: 'askEveryTime');
    final downloadType = preferredType == 'askEveryTime' ? null : preferredType;

    for (final reference in references) {
      _throwIfReconcileStale(generation, userId);
      final key = _key(reference);
      if (snapshot.completeKeys.contains(key) ||
          snapshot.activeReferences.contains(key) ||
          _retryAfter.containsKey(key)) {
        continue;
      }
      try {
        await downloadHandler.downloadFile(
          reference.itemId,
          episodeId: reference.episodeId,
          downloadType: downloadType,
          acquisitionOrigin: 'smart',
          smartProfileIds: const <String>[_continueShelfProfileId],
          requiredUserId: userId,
        );
      } on NoDownloadableFilesException {
        _throwIfReconcileStale(generation, userId);
        continue;
      }

      snapshot.activeReferences.add(key);
    }
  }
}
