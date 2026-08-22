import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:yaabsa/provider/player/queue_source_provider.dart';
import 'package:yaabsa/util/globals.dart' show audioHandler, downloadHandler, isAudioHandlerInitialized;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'smart_download_provider.g.dart';

const _continueShelfProfileId = '__continue_shelf__';

class SmartDownloadState {
  const SmartDownloadState({
    this.profiles = const <SmartDownloadProfile>[],
    this.isReconciling = false,
    this.lastReconciled,
    this.error,
  });

  final List<SmartDownloadProfile> profiles;
  final bool isReconciling;
  final DateTime? lastReconciled;
  final Object? error;

  SmartDownloadState copyWith({
    List<SmartDownloadProfile>? profiles,
    bool? isReconciling,
    DateTime? lastReconciled,
    Object? error,
    bool clearError = false,
  }) {
    return SmartDownloadState(
      profiles: profiles ?? this.profiles,
      isReconciling: isReconciling ?? this.isReconciling,
      lastReconciled: lastReconciled ?? this.lastReconciled,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class _StaleSmartDownloadReconcile implements Exception {
  const _StaleSmartDownloadReconcile();
}

@Riverpod(keepAlive: true)
class SmartDownloadManager extends _$SmartDownloadManager {
  Future<void>? _activeReconcile;
  Timer? _refreshDebounce;
  int _generation = 0;
  bool _reconcileRequested = false;
  bool _appReady = false;
  String? _pendingReconcileReason;
  final Set<String> _recentlyCompletedContinueReferences = <String>{};

  @override
  SmartDownloadState build() {
    ref.listen(currentUserProvider, (previous, next) {
      final previousUserId = previous?.value?.id;
      final nextUserId = next.value?.id;
      if (previousUserId == nextUserId) {
        return;
      }
      _generation++;
      _refreshDebounce?.cancel();
      _recentlyCompletedContinueReferences.clear();
      state = const SmartDownloadState();
      if (nextUserId != null) {
        requestReconcile(reason: 'active user changed');
      }
    });
    ref.listen(serverStatusProvider, (previous, next) {
      if (previous?.value == next.value) {
        return;
      }
      _generation++;
      if (next.value == true) {
        requestReconcile(reason: 'server reachable');
      } else {
        _refreshDebounce?.cancel();
        state = state.copyWith(isReconciling: false);
      }
    });
    ref.listen(userSettingsWatcherProvider, (previous, next) {
      if (previous?.value == next.value) {
        return;
      }
      requestReconcile(reason: 'user setting changed');
    });
    ref.listen(selectedLibraryProvider, (previous, next) {
      if (previous?.id == next?.id) {
        return;
      }
      requestReconcile(reason: 'selected library changed');
    });
    ref.onDispose(() {
      _generation++;
      _refreshDebounce?.cancel();
      _reconcileRequested = false;
    });
    return const SmartDownloadState();
  }

  Future<List<SmartDownloadProfile>> loadProfiles() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = state.copyWith(profiles: const <SmartDownloadProfile>[], clearError: true);
      return const <SmartDownloadProfile>[];
    }

    final dbProfiles = await ref.read(appDatabaseProvider).getSmartDownloadProfiles(user.id);
    final profiles = <SmartDownloadProfile>[];
    for (final row in dbProfiles) {
      SmartDownloadPolicy policy;
      try {
        final decoded = jsonDecode(row.policy);
        policy = SmartDownloadPolicy.fromJson(Map<String, dynamic>.from(decoded as Map));
      } catch (e) {
        logger('Ignoring invalid smart-download policy ${row.id}: $e', tag: 'SmartDownloadManager');
        policy = const SmartDownloadPolicy();
      }

      final sourceRows = await ref.read(appDatabaseProvider).getSmartDownloadSources(row.id);
      final sources = sourceRows.map(_sourceFromRow).whereType<MediaSourceDescriptor>().toList(growable: false);
      profiles.add(
        SmartDownloadProfile(
          id: row.id,
          userId: row.userId,
          name: row.name,
          enabled: row.enabled,
          policy: policy,
          sources: sources,
        ),
      );
    }
    state = state.copyWith(profiles: profiles, clearError: true);
    return profiles;
  }

  Future<void> saveProfile(SmartDownloadProfile profile) async {
    _generation++;
    final db = ref.read(appDatabaseProvider);
    await _deleteManagedDownloadsForRemovedSources(profile);
    await db.upsertSmartDownloadProfile(profile);
    await db.replaceSmartDownloadSources(profile.id, profile.sources);
    await loadProfiles();
    requestReconcile(reason: 'profile changed');
  }

  Future<void> deleteProfile(String profileId, String userId) async {
    _generation++;
    await _deleteManagedDownloadsForProfile(profileId: profileId, userId: userId);
    await ref.read(appDatabaseProvider).deleteSmartDownloadProfile(profileId, userId);
    await loadProfiles();
    requestReconcile(reason: 'profile removed');
  }

  Future<int> deleteListenedManagedDownloads({required String userId}) async {
    if (!isAudioHandlerInitialized) {
      return 0;
    }

    final db = ref.read(appDatabaseProvider);
    var progress = ref.read(mediaProgressProvider).asData?.value ?? const {};
    if (progress.isEmpty) {
      final cachedEntries = await db.getStoredMediaProgressByUser(userId);
      final cachedProgress = <String, MediaProgress>{};
      for (final entry in cachedEntries) {
        final decoded = _decodeProgressOrNull(entry.mediaProgress);
        if (decoded == null) continue;
        cachedProgress[mediaProgressKey(decoded.libraryItemId, decoded.episodeId)] = decoded;
      }
      progress = cachedProgress;
    }
    if (progress.isEmpty) {
      return 0;
    }
    final entries = await db.getStoredDownloadEntriesByUser(userId);
    final downloads = await db.getAllStoredDownloadsByUser(userId);
    var deleted = 0;
    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      final key = mediaProgressKey(entry.itemId, entry.episodeId);
      if (progress[key]?.isFinished != true || _isProtected(entry.itemId, entry.episodeId)) {
        continue;
      }
      if (await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      final download = downloads.where((candidate) {
        final itemId = candidate.item?.id ?? candidate.episode?.libraryItemId;
        return itemId == entry.itemId && candidate.episode?.id == entry.episodeId;
      }).firstOrNull;
      if (download == null) {
        continue;
      }
      await downloadHandler.deleteDownloadedItem(download, userId: userId);
      deleted++;
    }
    if (deleted > 0) {
      requestReconcile(reason: 'listened downloads removed');
    }
    return deleted;
  }

  Future<int> deleteContinueShelfDownloads({required String userId}) async {
    if (!isAudioHandlerInitialized) {
      return 0;
    }

    final db = ref.read(appDatabaseProvider);
    await downloadHandler.cancelSmartTasksForProfile(_continueShelfProfileId, userId: userId);
    final entries = await db.getStoredDownloadEntriesByUser(userId);
    final downloads = await db.getAllStoredDownloadsByUser(userId);
    var deleted = 0;

    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      final profileIds = _decodeProfileIds(entry.smartProfileIds);
      if (!profileIds.contains(_continueShelfProfileId)) {
        continue;
      }

      final remainingProfileIds = profileIds.where((id) => id != _continueShelfProfileId).toList(growable: false);
      if (remainingProfileIds.isNotEmpty) {
        await db.updateStoredDownloadSmartProfileIds(
          entry.itemId,
          userId,
          episodeId: entry.episodeId,
          smartProfileIds: remainingProfileIds,
        );
        continue;
      }

      if (_isProtected(entry.itemId, entry.episodeId) ||
          await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      final download = downloads.where((candidate) {
        final itemId = candidate.item?.id ?? candidate.episode?.libraryItemId;
        return itemId == entry.itemId && candidate.episode?.id == entry.episodeId;
      }).firstOrNull;
      if (download == null) {
        continue;
      }

      await downloadHandler.deleteDownloadedItem(download, userId: userId);
      deleted++;
    }

    if (deleted > 0) {
      requestReconcile(reason: 'Continue shelf downloads removed');
    }
    return deleted;
  }

  Future<bool> deleteFinishedContinueDownload({required String itemId, String? episodeId}) async {
    if (!isAudioHandlerInitialized) {
      return false;
    }

    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null || userId.isEmpty) {
      return false;
    }

    final db = ref.read(appDatabaseProvider);
    final entry = (await db.getStoredDownloadEntriesByUser(userId))
        .where(
          (candidate) =>
              candidate.itemId == itemId && candidate.episodeId == episodeId && candidate.downloadOrigin == 'smart',
        )
        .firstOrNull;
    if (entry == null) {
      return false;
    }

    final profileIds = _decodeProfileIds(entry.smartProfileIds);
    if (profileIds.length != 1 || profileIds.first != _continueShelfProfileId) {
      return false;
    }

    if (await downloadHandler.hasActiveTask(itemId, episodeId: episodeId)) {
      return false;
    }

    final download = await db.getStoredDownload(itemId, userId, episodeId: episodeId);
    if (download == null) {
      return false;
    }

    try {
      await downloadHandler.deleteDownloadedItem(download, userId: userId);
    } catch (e, s) {
      logger(
        'Failed to remove completed Continue download for $itemId: $e\n$s',
        tag: 'SmartDownloadManager',
        level: InfoLevel.warning,
      );
      return false;
    }
    _recentlyCompletedContinueReferences.add(_key(PlayableRef(itemId: itemId, episodeId: episodeId)));
    requestReconcile(reason: 'continue download completed');
    return true;
  }

  MediaProgress? _decodeProgressOrNull(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return MediaProgress.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return null;
  }

  Future<void> _deleteManagedDownloadsForProfile({required String profileId, required String userId}) async {
    if (!isAudioHandlerInitialized) {
      return;
    }

    final db = ref.read(appDatabaseProvider);
    await downloadHandler.cancelSmartTasksForProfile(profileId, userId: userId);
    final entries = await db.getStoredDownloadEntriesByUser(userId);
    final downloads = await db.getAllStoredDownloadsByUser(userId);
    final enabledProfileIds = (await db.getSmartDownloadProfiles(userId))
        .where((profile) => profile.enabled && profile.id != profileId)
        .map((profile) => profile.id)
        .toSet();
    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      final profileIds = _decodeProfileIds(entry.smartProfileIds);
      if (!profileIds.contains(profileId)) {
        continue;
      }
      final otherClaimingProfileIds = (await db.getSmartDownloadClaimsForReference(
        entry.itemId,
        entry.episodeId,
      )).map((claim) => claim.profileId).where(enabledProfileIds.contains);
      final remainingProfileIds = <String>{
        ...profileIds.where((id) => id != profileId),
        ...otherClaimingProfileIds,
      }.toList(growable: false)..sort();
      if (remainingProfileIds.isNotEmpty) {
        await db.updateStoredDownloadSmartProfileIds(
          entry.itemId,
          userId,
          episodeId: entry.episodeId,
          smartProfileIds: remainingProfileIds,
        );
        continue;
      }
      if (_isProtected(entry.itemId, entry.episodeId) ||
          await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      final download = downloads.where((candidate) {
        final itemId = candidate.item?.id ?? candidate.episode?.libraryItemId;
        return itemId == entry.itemId && candidate.episode?.id == entry.episodeId;
      }).firstOrNull;
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: userId);
      }
    }
  }

  void requestReconcile({required String reason, Duration delay = const Duration(milliseconds: 350)}) {
    if (!_appReady) {
      _pendingReconcileReason = reason;
      return;
    }

    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(delay, () {
      unawaited(reconcile(reason: reason));
    });
  }

  void markAppReady() {
    if (_appReady) {
      return;
    }

    _appReady = true;
    final reason = _pendingReconcileReason;
    _pendingReconcileReason = null;
    if (reason != null) {
      requestReconcile(reason: reason, delay: const Duration(seconds: 1));
    }
  }

  Future<void> reconcile({required String reason}) {
    final active = _activeReconcile;
    if (active != null) {
      _reconcileRequested = true;
      return active;
    }

    final future = _reconcileInternal(reason: reason);
    _activeReconcile = future;
    return future.whenComplete(() {
      if (identical(_activeReconcile, future)) {
        _activeReconcile = null;
      }
      if (_reconcileRequested) {
        _reconcileRequested = false;
        requestReconcile(reason: 'coalesced update');
      }
    });
  }

  Future<void> _reconcileInternal({required String reason}) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null || kIsWeb) {
      return;
    }
    if (ref.read(serverStatusProvider).value == false) {
      return;
    }

    final generation = ++_generation;
    final userId = user.id;
    state = state.copyWith(isReconciling: true, clearError: true);
    try {
      final profiles = await loadProfiles();
      _throwIfReconcileStale(generation, userId);
      final desiredByReference = <String>{};
      final desiredByProfile = <String, Set<String>>{};
      final db = ref.read(appDatabaseProvider);
      final sourceRepository = ref.read(queueSourceRepositoryProvider);
      sourceRepository.clearCache();

      for (final profile in profiles.where((profile) => profile.enabled)) {
        if (generation != _generation) {
          state = state.copyWith(isReconciling: false);
          return;
        }
        final desired = <String>{};
        desiredByProfile[profile.id] = desired;
        final targetCount = profile.policy.targetCount.clamp(1, 100).toInt();

        for (final source in profile.sources) {
          var page = 0;
          var selectedForSource = 0;
          int? sourceRevision;
          final compactSnapshot = <QueueCandidate>[];
          while (selectedForSource < targetCount && page < 20) {
            final result = await sourceRepository.page(source, page: page, pageSize: queueSourcePageSize);
            _throwIfReconcileStale(generation, userId);
            sourceRevision ??= result.revision;
            if (compactSnapshot.length < queueSourcePageSize) {
              compactSnapshot.addAll(result.candidates.take(queueSourcePageSize - compactSnapshot.length));
            }
            final candidates = result.candidates;
            if (candidates.isEmpty) break;
            for (final candidate in candidates) {
              if (selectedForSource >= targetCount || candidate.isFinished) continue;
              if (!_withinAge(candidate, profile.policy.maxAgeDays)) continue;
              final key = _key(candidate.ref);
              if (!desired.add(key)) continue;
              selectedForSource++;
              desiredByReference.add(key);
              _throwIfReconcileStale(generation, userId);
              await db.upsertSmartDownloadClaim(
                SmartDownloadClaim(
                  profileId: profile.id,
                  ref: candidate.ref,
                  source: source,
                  estimatedBytes: candidate.estimatedBytes,
                ),
              );
            }
            if (candidates.length < queueSourcePageSize) break;
            page++;
          }
          await db.updateSmartDownloadSourceSnapshot(
            profile.id,
            source,
            revision: sourceRevision,
            candidateSnapshot: jsonEncode(
              compactSnapshot.map((candidate) => candidate.toJson()).toList(growable: false),
            ),
          );
          _throwIfReconcileStale(generation, userId);
        }

        final existingClaims = await db.getSmartDownloadClaims(profile.id);
        for (final claim in existingClaims) {
          final key = '${claim.itemId}::${claim.episodeId ?? ''}';
          if (!desired.contains(key)) {
            await db.deleteSmartDownloadClaim(profile.id, claim.itemId, episodeId: claim.episodeId);
            _throwIfReconcileStale(generation, userId);
          }
        }
      }

      final continueReferences = await _continueShelfReferences();
      _throwIfReconcileStale(generation, userId);
      desiredByReference.addAll(continueReferences.map(_key));
      await _enqueueDesired(
        profiles: profiles,
        desiredByProfile: desiredByProfile,
        userId: userId,
        generation: generation,
      );
      _throwIfReconcileStale(generation, userId);
      await _enqueueContinueReferences(userId: userId, references: continueReferences, generation: generation);
      _throwIfReconcileStale(generation, userId);
      await _cleanupUnclaimed(
        userId: userId,
        desiredByReference: desiredByReference,
        profiles: profiles,
        generation: generation,
      );
      _throwIfReconcileStale(generation, userId);
      state = state.copyWith(isReconciling: false, lastReconciled: DateTime.now(), clearError: true);
      logger('Smart-download reconciliation completed ($reason).', tag: 'SmartDownloadManager', level: InfoLevel.debug);
    } catch (e, s) {
      if (e is _StaleSmartDownloadReconcile || generation != _generation) {
        state = state.copyWith(isReconciling: false);
        return;
      }
      logger(
        'Smart-download reconciliation failed ($reason): $e\n$s',
        tag: 'SmartDownloadManager',
        level: InfoLevel.warning,
      );
      state = state.copyWith(isReconciling: false, error: e);
    }
  }

  Future<void> _enqueueDesired({
    required List<SmartDownloadProfile> profiles,
    required Map<String, Set<String>> desiredByProfile,
    required String userId,
    required int generation,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final stored = await db.getStoredDownloadEntriesByUser(userId);
    _throwIfReconcileStale(generation, userId);
    final storedDownloads = await db.getAllStoredDownloadsByUser(userId);
    _throwIfReconcileStale(generation, userId);
    final storedKeys = storedDownloads
        .where((download) => download.isComplete)
        .map(_downloadKey)
        .whereType<String>()
        .toSet();
    final activeReservations = await downloadHandler.activeSmartDownloadReservations(userId);
    _throwIfReconcileStale(generation, userId);
    final plannedKeys = <String>{};
    final profileIdsByKey = <String, Set<String>>{};
    final downloadTypeByKey = <String, String>{};
    for (final profile in profiles.where((profile) => profile.enabled)) {
      for (final key in desiredByProfile[profile.id] ?? const <String>{}) {
        profileIdsByKey.putIfAbsent(key, () => <String>{}).add(profile.id);
        downloadTypeByKey.update(
          key,
          (existing) => _mergeDownloadTypes(existing, profile.policy.downloadType),
          ifAbsent: () => profile.policy.downloadType,
        );
      }
    }

    for (final entry in stored.where((entry) => entry.downloadOrigin == 'smart')) {
      final key = '${entry.itemId}::${entry.episodeId ?? ''}';
      final claimingProfiles = profileIdsByKey[key];
      if (claimingProfiles == null || claimingProfiles.isEmpty) {
        continue;
      }
      final existingProfileIds = _decodeProfileIds(entry.smartProfileIds).toSet();
      final mergedProfileIds = <String>{...existingProfileIds, ...claimingProfiles}.toList()..sort();
      if (existingProfileIds.length == mergedProfileIds.length && existingProfileIds.containsAll(mergedProfileIds)) {
        continue;
      }
      await db.updateStoredDownloadSmartProfileIds(
        entry.itemId,
        userId,
        episodeId: entry.episodeId,
        smartProfileIds: mergedProfileIds,
      );
      _throwIfReconcileStale(generation, userId);
    }

    for (final profile in profiles.where((profile) => profile.enabled)) {
      _throwIfReconcileStale(generation, userId);
      final cap = profile.policy.maxStorageBytes;
      final selected = desiredByProfile[profile.id] ?? const <String>{};
      final claimRows = await db.getSmartDownloadClaims(profile.id);
      final claims = <String, SmartDownloadClaimEntry>{
        for (final claim in claimRows) '${claim.itemId}::${claim.episodeId ?? ''}': claim,
      };
      if (cap != null && cap > 0) {
        for (final key in selected.where(activeReservations.containsKey)) {
          if ((activeReservations[key] ?? 0) > 0) {
            continue;
          }
          final split = key.split('::');
          final itemId = split.first;
          final episodeId = split.length > 1 && split[1].isNotEmpty ? split[1] : null;
          final resolvedBytes = await downloadHandler.estimateDownloadBytes(
            itemId,
            episodeId: episodeId,
            downloadType: downloadTypeByKey[key] ?? profile.policy.downloadType,
          );
          _throwIfReconcileStale(generation, userId);
          if (resolvedBytes != null && resolvedBytes > 0) {
            activeReservations[key] = resolvedBytes;
          }
        }
      }
      var managedBytes = stored
          .where((entry) => entry.downloadOrigin == 'smart')
          .where((entry) => selected.contains('${entry.itemId}::${entry.episodeId ?? ''}'))
          .where((entry) => storedKeys.contains('${entry.itemId}::${entry.episodeId ?? ''}'))
          .fold<int>(0, (sum, entry) => sum + (entry.managedBytes ?? 0));
      managedBytes += activeReservations.entries
          .where((entry) => selected.contains(entry.key) && !storedKeys.contains(entry.key))
          .fold<int>(0, (sum, entry) => sum + entry.value);
      for (final key in selected) {
        if (plannedKeys.contains(key) || storedKeys.contains(key) || activeReservations.containsKey(key)) continue;
        final split = key.split('::');
        final itemId = split.first;
        final episodeId = split.length > 1 && split[1].isNotEmpty ? split[1] : null;
        final claim = claims[key];
        var estimatedBytes = claim?.estimatedBytes ?? 0;
        if (cap != null && cap > 0) {
          final resolvedBytes = await downloadHandler.estimateDownloadBytes(
            itemId,
            episodeId: episodeId,
            downloadType: downloadTypeByKey[key] ?? profile.policy.downloadType,
          );
          _throwIfReconcileStale(generation, userId);
          if (resolvedBytes != null && resolvedBytes > estimatedBytes) {
            estimatedBytes = resolvedBytes;
          }
          if (estimatedBytes <= 0 || managedBytes + estimatedBytes > cap) {
            continue;
          }
        }
        if (await downloadHandler.hasActiveTask(itemId, episodeId: episodeId)) continue;
        _throwIfReconcileStale(generation, userId);
        plannedKeys.add(key);
        await downloadHandler.downloadFile(
          itemId,
          episodeId: episodeId,
          downloadType: downloadTypeByKey[key] ?? profile.policy.downloadType,
          acquisitionOrigin: 'smart',
          smartProfileIds: (profileIdsByKey[key] ?? <String>{profile.id}).toList(growable: false)..sort(),
          estimatedBytes: estimatedBytes > 0 ? estimatedBytes : null,
          requiredUserId: userId,
        );
        _throwIfReconcileStale(generation, userId);
        activeReservations[key] = estimatedBytes;
        managedBytes += estimatedBytes;
      }
    }
  }

  Future<Set<PlayableRef>> _continueShelfReferences() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null ||
        !ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(user.id, SettingKeys.downloadContinueListeningAndSeries, defaultValue: false)) {
      return <PlayableRef>{};
    }

    final library = ref.read(selectedLibraryProvider);
    if (library == null) {
      return <PlayableRef>{};
    }

    final personalized = await _loadPersonalizedLibrary(library.id);
    final continueListeningItems = personalized?.continueListening?.entities ?? const <LibraryItem>[];
    final continueSeriesItems = personalized?.continueSeries?.entities ?? const <LibraryItem>[];
    if (continueListeningItems.isEmpty && continueSeriesItems.isEmpty) {
      return <PlayableRef>{};
    }

    Map<String, MediaProgress> progress;
    try {
      progress = ref.read(mediaProgressProvider).asData?.value ?? await ref.read(mediaProgressProvider.future);
    } catch (_) {
      progress = const <String, MediaProgress>{};
    }

    final references = <PlayableRef>{};
    final seenItemIds = <String>{};
    for (final item in continueListeningItems) {
      if (seenItemIds.add(item.id)) {
        references.addAll(await _continueItemReferences(item, progress));
      }
    }
    for (final item in continueSeriesItems) {
      if (seenItemIds.add(item.id)) {
        references.addAll(await _continueItemReferences(item, progress));
      }
    }
    return references;
  }

  Future<Set<PlayableRef>> _continueItemReferences(LibraryItem item, Map<String, MediaProgress> progress) async {
    if (item.mediaType == 'podcast' || item.media?.podcastMedia != null) {
      return _continuePodcastReferences(item, progress);
    }

    final currentReference = PlayableRef(itemId: item.id);
    final currentProgress = progress[mediaProgressKey(item.id)];
    final references = <PlayableRef>{};
    if (currentProgress?.isFinished != true && !_recentlyCompletedContinueReferences.contains(_key(currentReference))) {
      references.add(currentReference);
    }
    return references;
  }

  Future<PersonalizedLibrary?> _loadPersonalizedLibrary(String libraryId) async {
    try {
      return await ref.read(personalizedLibraryProvider(libraryId).future);
    } catch (e, s) {
      logger(
        'Could not load Continue Listening for smart downloads: $e\n$s',
        tag: 'SmartDownloadManager',
        level: InfoLevel.debug,
      );
      return null;
    }
  }

  Future<Set<PlayableRef>> _continuePodcastReferences(
    LibraryItem shelfItem,
    Map<String, MediaProgress> progress,
  ) async {
    var item = shelfItem;
    final shelfEpisodes = item.media?.podcastMedia?.episodes ?? const <Episode>[];
    if (shelfEpisodes.length < 2) {
      try {
        item = await ref.read(libraryItemProvider(item.id).future);
      } catch (_) {}
    }

    final episodes = (item.media?.podcastMedia?.episodes ?? shelfEpisodes)
        .where((episode) => episode.audioFile != null)
        .toList(growable: false);
    if (episodes.isEmpty) {
      return <PlayableRef>{};
    }

    final currentProgress =
        progress.values
            .where(
              (entry) =>
                  entry.libraryItemId == item.id &&
                  entry.episodeId != null &&
                  entry.episodeId!.isNotEmpty &&
                  !entry.isFinished,
            )
            .toList(growable: false)
          ..sort((left, right) => (right.lastUpdate ?? 0).compareTo(left.lastUpdate ?? 0));
    final finishedProgress =
        progress.values
            .where(
              (entry) =>
                  entry.libraryItemId == item.id &&
                  entry.episodeId != null &&
                  entry.episodeId!.isNotEmpty &&
                  entry.isFinished,
            )
            .toList(growable: false)
          ..sort((left, right) => (right.lastUpdate ?? 0).compareTo(left.lastUpdate ?? 0));
    final activeProgress = currentProgress.firstOrNull;
    if (activeProgress == null && finishedProgress.isNotEmpty) {
      return <PlayableRef>{};
    }
    final currentEpisodeId = activeProgress?.episodeId ?? episodes.first.id;
    final currentReference = PlayableRef(itemId: item.id, episodeId: currentEpisodeId);
    final references = <PlayableRef>{};
    if (!_recentlyCompletedContinueReferences.contains(_key(currentReference))) {
      references.add(currentReference);
    }
    return references;
  }

  Future<void> _enqueueContinueReferences({
    required String userId,
    required Set<PlayableRef> references,
    required int generation,
  }) async {
    if (references.isEmpty) {
      return;
    }
    final db = ref.read(appDatabaseProvider);
    final storedKeys = (await db.getAllStoredDownloadsByUser(userId))
        .where((download) => download.isComplete)
        .map(_downloadKey)
        .whereType<String>()
        .toSet();
    _throwIfReconcileStale(generation, userId);
    final activeKeys = (await downloadHandler.activeSmartDownloadReservations(userId)).keys.toSet();
    _throwIfReconcileStale(generation, userId);
    final preferredType = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(userId, SettingKeys.downloadTypePreference, defaultValue: 'askEveryTime');
    final downloadType = preferredType == 'askEveryTime' ? null : preferredType;

    for (final reference in references) {
      _throwIfReconcileStale(generation, userId);
      final key = _key(reference);
      if (storedKeys.contains(key) || activeKeys.contains(key)) {
        continue;
      }
      if (await downloadHandler.hasActiveTask(reference.itemId, episodeId: reference.episodeId)) {
        continue;
      }
      _throwIfReconcileStale(generation, userId);
      await downloadHandler.downloadFile(
        reference.itemId,
        episodeId: reference.episodeId,
        downloadType: downloadType,
        acquisitionOrigin: 'smart',
        smartProfileIds: const <String>[_continueShelfProfileId],
        requiredUserId: userId,
      );
      activeKeys.add(key);
    }
  }

  Future<void> _deleteManagedDownloadsForRemovedSources(SmartDownloadProfile profile) async {
    if (!isAudioHandlerInitialized) {
      return;
    }

    final db = ref.read(appDatabaseProvider);
    final previousSources = await db.getSmartDownloadSources(profile.id);
    final currentSourceKeys = profile.sources.map(_descriptorSourceKey).toSet();
    final removedSourceKeys = previousSources
        .map(_storedSourceKey)
        .where((key) => !currentSourceKeys.contains(key))
        .toSet();
    if (removedSourceKeys.isEmpty) {
      return;
    }

    final claims = await db.getSmartDownloadClaims(profile.id);
    final removedReferences = claims
        .where((claim) => removedSourceKeys.contains('${claim.sourceType}::${claim.sourceId}'))
        .map((claim) => '${claim.itemId}::${claim.episodeId ?? ''}')
        .toSet();
    for (final source in previousSources.where((source) => removedSourceKeys.contains(_storedSourceKey(source)))) {
      removedReferences.addAll(_snapshotReferences(source.candidateSnapshot));
    }
    if (removedReferences.isEmpty && currentSourceKeys.isEmpty) {
      final entries = await db.getStoredDownloadEntriesByUser(profile.userId);
      for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
        final profileIds = _decodeProfileIds(entry.smartProfileIds);
        if (profileIds.length == 1 && profileIds.first == profile.id) {
          removedReferences.add('${entry.itemId}::${entry.episodeId ?? ''}');
        }
      }
    }
    if (removedReferences.isEmpty) {
      return;
    }

    await downloadHandler.cancelSmartTasksForReferences(
      userId: profile.userId,
      references: removedReferences,
      profileId: profile.id,
    );

    final entries = await db.getStoredDownloadEntriesByUser(profile.userId);
    final downloads = await db.getAllStoredDownloadsByUser(profile.userId);
    final enabledProfileIds = (await db.getSmartDownloadProfiles(profile.userId))
        .where((storedProfile) => storedProfile.enabled && storedProfile.id != profile.id)
        .map((storedProfile) => storedProfile.id)
        .toSet();
    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      final reference = '${entry.itemId}::${entry.episodeId ?? ''}';
      if (!removedReferences.contains(reference)) {
        continue;
      }
      final profileIds = _decodeProfileIds(entry.smartProfileIds);
      if (!profileIds.contains(profile.id)) {
        continue;
      }
      final otherClaimingProfileIds = (await db.getSmartDownloadClaimsForReference(
        entry.itemId,
        entry.episodeId,
      )).map((claim) => claim.profileId).where(enabledProfileIds.contains);
      final remainingProfileIds = <String>{
        ...profileIds.where((id) => id != profile.id),
        ...otherClaimingProfileIds,
      }.toList(growable: false)..sort();
      if (remainingProfileIds.isNotEmpty) {
        await db.updateStoredDownloadSmartProfileIds(
          entry.itemId,
          profile.userId,
          episodeId: entry.episodeId,
          smartProfileIds: remainingProfileIds,
        );
        continue;
      }
      if (_isProtected(entry.itemId, entry.episodeId) ||
          await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) {
        continue;
      }
      final download = downloads.where((candidate) {
        final itemId = candidate.item?.id ?? candidate.episode?.libraryItemId;
        return itemId == entry.itemId && candidate.episode?.id == entry.episodeId;
      }).firstOrNull;
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: profile.userId);
      }
    }
  }

  Future<void> _cleanupUnclaimed({
    required String userId,
    required Set<String> desiredByReference,
    required List<SmartDownloadProfile> profiles,
    required int generation,
  }) async {
    if (!isAudioHandlerInitialized) {
      return;
    }

    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final profilesById = <String, SmartDownloadProfile>{for (final profile in profiles) profile.id: profile};
    final entries = await db.getStoredDownloadEntriesByUser(userId);
    _throwIfReconcileStale(generation, userId);
    for (final entry in entries.where((entry) => entry.downloadOrigin == 'smart')) {
      _throwIfReconcileStale(generation, userId);
      final key = '${entry.itemId}::${entry.episodeId ?? ''}';
      if (desiredByReference.contains(key) || _isProtected(entry.itemId, entry.episodeId)) continue;
      if (await downloadHandler.hasActiveTask(entry.itemId, episodeId: entry.episodeId)) continue;
      _throwIfReconcileStale(generation, userId);
      final graceHours = _graceHoursForEntry(entry.smartProfileIds, profilesById);
      final graceMillis = Duration(hours: graceHours).inMilliseconds;
      final completedAt = entry.completedAt ?? 0;
      if (completedAt <= 0) continue;
      if (completedAt > 0 && now - completedAt < graceMillis) continue;
      final download = await db.getStoredDownload(entry.itemId, userId, episodeId: entry.episodeId);
      _throwIfReconcileStale(generation, userId);
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: userId);
        _throwIfReconcileStale(generation, userId);
      }
    }
  }

  int _graceHoursForEntry(String rawProfileIds, Map<String, SmartDownloadProfile> profilesById) {
    try {
      final values = _decodeProfileIds(rawProfileIds)
          .map((id) => profilesById[id]?.policy.deleteAfterHours)
          .whereType<int>()
          .where((hours) => hours >= 0)
          .toList(growable: false);
      if (values.isNotEmpty) {
        return values.reduce((left, right) => left < right ? left : right);
      }
    } catch (_) {}
    return 24;
  }

  List<String> _decodeProfileIds(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<String>().where((id) => id.trim().isNotEmpty).toList(growable: false);
      }
    } catch (_) {}
    return const <String>[];
  }

  Set<String> _snapshotReferences(String? rawSnapshot) {
    if (rawSnapshot == null || rawSnapshot.isEmpty) {
      return <String>{};
    }
    try {
      final decoded = jsonDecode(rawSnapshot);
      if (decoded is! List) {
        return <String>{};
      }
      return decoded
          .whereType<Map>()
          .map((candidate) => candidate['ref'])
          .whereType<Map>()
          .map((ref) {
            final itemId = ref['itemId'];
            final episodeId = ref['episodeId'];
            if (itemId is! String || itemId.isEmpty) {
              return null;
            }
            return '$itemId::${episodeId is String ? episodeId : ''}';
          })
          .whereType<String>()
          .toSet();
    } catch (_) {
      return <String>{};
    }
  }

  bool _isProtected(String itemId, String? episodeId) {
    final current = audioHandler.currentMediaItem;
    if (current != null && current.itemId == itemId && current.episodeId == episodeId) {
      return true;
    }
    return audioHandler.isInQueue(itemId, episodeId: episodeId);
  }

  bool _withinAge(QueueCandidate candidate, int? maxAgeDays) {
    if (maxAgeDays == null || maxAgeDays <= 0) return true;
    final timestamp = candidate.publishedAt ?? candidate.addedAt;
    if (timestamp == null || timestamp <= 0) return true;
    final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
    return age <= Duration(days: maxAgeDays);
  }

  String? _downloadKey(InternalDownload download) {
    final itemId = download.item?.id ?? download.episode?.libraryItemId;
    if (itemId == null || itemId.isEmpty) {
      return null;
    }
    return '$itemId::${download.episode?.id ?? ''}';
  }

  String _mergeDownloadTypes(String left, String right) {
    if (left == right) {
      return left;
    }
    return 'both';
  }

  void _throwIfReconcileStale(int generation, String userId) {
    if (generation != _generation || ref.read(currentUserProvider).value?.id != userId) {
      throw const _StaleSmartDownloadReconcile();
    }
  }

  MediaSourceDescriptor? _sourceFromRow(SmartDownloadSourceEntry row) {
    final type = MediaSourceType.values.where((value) => value.name == row.sourceType).firstOrNull;
    if (type == null) return null;
    return MediaSourceDescriptor(
      type: type,
      sourceId: row.sourceId,
      libraryId: row.libraryId,
      displayName: row.displayName,
      descending: row.descending,
      revision: row.sourceRevision,
    );
  }

  String _key(PlayableRef ref) => '${ref.itemId}::${ref.episodeId ?? ''}';

  String _descriptorSourceKey(MediaSourceDescriptor source) => '${source.type.name}::${source.sourceId}';

  String _storedSourceKey(SmartDownloadSourceEntry source) => '${source.sourceType}::${source.sourceId}';
}
