import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/player/queue_source_provider.dart';
import 'package:yaabsa/util/globals.dart' show audioHandler, downloadHandler, isAudioHandlerInitialized;
import 'package:yaabsa/util/handler/download_handler.dart' show NoDownloadableFilesException;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'smart_download_provider.g.dart';
part 'smart_download_threshold.dart';
part 'smart_download_retry.dart';
part 'smart_download_snapshot.dart';
part 'smart_download_profile_cleanup.dart';
part 'smart_download_cleanup.dart';
part 'smart_download_enqueue.dart';
part 'smart_download_reconcile.dart';

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
  Stopwatch? _foregroundReconcileCooldown;
  Timer? _retryTimer;
  final Map<String, DateTime> _retryAfter = <String, DateTime>{};
  final Map<String, CandidatePage> _sourcePages = <String, CandidatePage>{};
  DateTime? _sourcePagesExpireAt;
  int _sourceCacheGeneration = 0;
  int _generation = 0;
  bool _reconcileRequested = false;
  bool _appReady = false;
  String? _pendingReconcileReason;
  String? _downloadSettingsSignature;
  final Set<String> _thresholdReady = <String>{};

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
      _foregroundReconcileCooldown = null;
      _thresholdReady.clear();
      _retryTimer?.cancel();
      _retryAfter.clear();
      _clearSourcePages();
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
      final userId = ref.read(currentUserProvider).value?.id;
      final settings = ref.read(settingsManagerProvider.notifier);
      final signature = jsonEncode([
        userId,
        settings.getUserSetting<bool>(userId, SettingKeys.downloadOnlyOnWifi, defaultValue: true),
      ]);
      if (_downloadSettingsSignature == signature) {
        return;
      }

      _downloadSettingsSignature = signature;
      requestReconcile(reason: 'download setting changed', refreshSources: false);
    });
    ref.onDispose(() {
      _generation++;
      _refreshDebounce?.cancel();
      _retryTimer?.cancel();
      _retryAfter.clear();
      _reconcileRequested = false;
    });
    return const SmartDownloadState();
  }

  Ref get _managerRef => ref;

  SmartDownloadState get _managerState => state;

  void _setManagerState(SmartDownloadState value) {
    state = value;
  }

  List<SmartDownloadProfile> get _managerProfiles => state.profiles;

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
        final decoded = Map<String, dynamic>.from(jsonDecode(row.policy) as Map);
        policy = SmartDownloadPolicy.fromJson(decoded);
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
    if (!ref.mounted || ref.read(currentUserProvider).value?.id != user.id) {
      return const <SmartDownloadProfile>[];
    }

    state = state.copyWith(profiles: profiles, clearError: true);
    return profiles;
  }

  Future<void> saveProfile(SmartDownloadProfile profile) async {
    if (profile.enabled) {
      await downloadHandler.prepareAutomaticDownloads();
    }

    _generation++;
    _thresholdReady.removeWhere((key) => key.startsWith('${profile.id}::'));
    final db = ref.read(appDatabaseProvider);
    await _deleteManagedDownloadsForRemovedSources(profile);
    await db.upsertSmartDownloadProfile(profile);
    if (!profile.enabled && isAudioHandlerInitialized) {
      await downloadHandler.cancelSmartTasksForProfile(profile.id, userId: profile.userId);
    }
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
    var progress = ref.read(mediaProgressProvider.notifier).snapshot;
    if (progress.isEmpty) {
      final cachedEntries = await db.getStoredMediaProgressByUser(userId);
      final cachedProgress = <String, MediaProgress>{};
      for (final entry in cachedEntries) {
        final decoded = _decodeProgressOrNull(entry.mediaProgress);
        if (decoded == null) {
          continue;
        }
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

  MediaProgress? _decodeProgressOrNull(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return MediaProgress.fromJson(Map<String, dynamic>.from(decoded));
      }
    } catch (_) {}
    return null;
  }

  void _clearSourcePages() {
    _sourceCacheGeneration++;
    _sourcePages.clear();
    _sourcePagesExpireAt = null;
  }

  void requestReconcile({
    required String reason,
    Duration delay = const Duration(milliseconds: 350),
    bool refreshSources = true,
  }) {
    if (reason == 'app foreground' && _appReady) {
      final cooldown = _foregroundReconcileCooldown;
      if (cooldown != null && cooldown.elapsed < const Duration(minutes: 1)) {
        return;
      }

      _foregroundReconcileCooldown = Stopwatch()..start();
    }

    if (refreshSources) {
      _clearSourcePages();
    }
    if (!_appReady) {
      _pendingReconcileReason = reason;
      return;
    }

    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(delay, () {
      unawaited(reconcile(reason: reason, refreshSources: false));
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

  Future<void> reconcile({required String reason, bool refreshSources = true}) {
    if (refreshSources) {
      _clearSourcePages();
    }
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
        requestReconcile(reason: 'coalesced update', refreshSources: false);
      }
    });
  }

  bool _withinAge(QueueCandidate candidate, int? maxAgeDays) {
    if (maxAgeDays == null || maxAgeDays <= 0) {
      return true;
    }
    final timestamp = candidate.publishedAt ?? candidate.addedAt;
    if (timestamp == null || timestamp <= 0) {
      return true;
    }
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

  String _key(PlayableRef ref) => '${ref.itemId}::${ref.episodeId ?? ''}';

  String _descriptorSourceKey(MediaSourceDescriptor source) => '${source.type.name}::${source.sourceId}';

  String _storedSourceKey(SmartDownloadSourceEntry source) => '${source.sourceType}::${source.sourceId}';
}
