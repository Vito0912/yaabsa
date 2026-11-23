import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/permissions.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/audio_file_download_mode.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/handler/download_handler.dart';
import 'package:yaabsa/util/setting_key.dart';

const testUserId = 'user';

User downloadUser(String id) {
  return User(
    id: id,
    username: id,
    email: null,
    type: 'user',
    token: 'token',
    permissions: const Permissions(
      download: true,
      update: true,
      delete: true,
      upload: true,
      accessAllLibraries: true,
      accessAllTags: true,
      accessExplicitContent: true,
    ),
  );
}

class DownloadTestDatabase extends AppDatabase {
  DownloadTestDatabase() : super.connect(DatabaseConnection(NativeDatabase.memory()));

  int progressReads = 0;
  int listeningReads = 0;
  int storedReads = 0;
  int downloadResolutions = 0;
  int claimWrites = 0;
  final completeDownloads = <String, InternalDownload>{};

  @override
  Future<List<StoredMediaProgressEntry>> getStoredMediaProgressByUser(String userId) {
    progressReads++;
    return super.getStoredMediaProgressByUser(userId);
  }

  @override
  Future<List<ListeningDownloadProgressEntry>> getListeningDownloadProgress(String userId) {
    listeningReads++;
    return super.getListeningDownloadProgress(userId);
  }

  @override
  Future<List<StoredDownloadsEntry>> getStoredDownloadEntriesByUser(String userId) {
    storedReads++;
    return super.getStoredDownloadEntriesByUser(userId);
  }

  @override
  Future<List<InternalDownload>> resolveStoredDownloadEntries(Iterable<StoredDownloadsEntry> entries) async {
    downloadResolutions++;
    return entries.map((entry) => completeDownloads[entry.itemId]).whereType<InternalDownload>().toList();
  }

  @override
  Future<InternalDownload?> getStoredDownload(
    String itemId,
    String userId, {
    String? episodeId,
    bool allowIncomplete = false,
  }) async {
    return completeDownloads[itemId];
  }

  @override
  Future<void> upsertSmartDownloadClaim(SmartDownloadClaim claim) {
    claimWrites++;
    return super.upsertSmartDownloadClaim(claim);
  }

  Future<void> addComplete(String itemId, List<String> profileIds, {int bytes = 80, int? completedAt}) async {
    completeDownloads[itemId] = CompleteTestDownload(itemId);
    await into(storedDownloads).insert(
      StoredDownloadsCompanion.insert(
        itemId: itemId,
        userId: testUserId,
        download: '{}',
        downloadOrigin: const Value('smart'),
        smartProfileIds: Value('[${profileIds.map((id) => '"$id"').join(',')}]'),
        managedBytes: Value(bytes),
        completedAt: Value(completedAt ?? 1),
      ),
    );
  }
}

class CompleteTestDownload implements InternalDownload {
  CompleteTestDownload(this.itemId, {this.downloadType = 'audiobook'});

  final String itemId;

  @override
  final String downloadType;

  @override
  LibraryItem get item => LibraryItem(id: itemId, ino: itemId, media: null, libraryFiles: null);

  @override
  Episode? get episode => null;

  @override
  bool get isComplete => true;

  @override
  bool isCompleteForType(String requestedType) => requestedType != 'ebook';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DownloadTestHandler implements DownloadHandler {
  late DownloadTestDatabase db;
  final events = <String>[];
  final queuedOwners = <String, List<String>>{};
  final queuedTypes = <String, String?>{};
  final estimates = <String, int?>{};
  final estimateReads = <String, int>{};
  final active = <String>{};
  final reservations = <String, int>{};
  int taskReads = 0;
  int duplicateChecks = 0;

  void reset(DownloadTestDatabase database) {
    db = database;
    events.clear();
    queuedOwners.clear();
    queuedTypes.clear();
    estimates.clear();
    estimateReads.clear();
    active.clear();
    reservations.clear();
    taskReads = 0;
    duplicateChecks = 0;
  }

  @override
  Future<AutomaticDownloadTasks> automaticDownloadTasks(String userId) async {
    taskReads++;
    return AutomaticDownloadTasks(activeReferences: {...active}, smartReservations: {...reservations});
  }

  @override
  Future<bool> hasActiveTask(String itemId, {String? episodeId}) async {
    duplicateChecks++;
    return active.contains('$itemId::${episodeId ?? ''}');
  }

  @override
  Future<int?> estimateDownloadBytes(String itemId, {String? episodeId, String downloadType = 'both'}) async {
    estimateReads.update(itemId, (count) => count + 1, ifAbsent: () => 1);
    return estimates.containsKey(itemId) ? estimates[itemId] : 50;
  }

  @override
  Future<void> downloadFile(
    String itemId, {
    String? episodeId,
    String? downloadType,
    AudioFileDownloadMode audioFileMode = AudioFileDownloadMode.all,
    int? audioFileCount,
    Set<String>? fileInodes,
    String acquisitionOrigin = 'manual',
    List<String> smartProfileIds = const [],
    int? estimatedBytes,
    String? requiredUserId,
    bool requestNotificationPermission = true,
  }) async {
    events.add('queue:$itemId');
    queuedOwners[itemId] = smartProfileIds;
    queuedTypes[itemId] = downloadType;
    active.add('$itemId::${episodeId ?? ''}');
  }

  @override
  Future<DeleteStoredDownloadResult> deleteDownloadedItem(InternalDownload download, {required String userId}) async {
    final itemId = download.item!.id;
    events.add('delete:$itemId');
    await (db.delete(db.storedDownloads)..where((row) => row.itemId.equals(itemId))).go();
    db.completeDownloads.remove(itemId);
    return DeleteStoredDownloadResult(
      itemId: itemId,
      episodeId: null,
      attemptedFiles: 1,
      deletedFiles: 1,
      failedFiles: 0,
    );
  }

  @override
  Future<int> cancelSmartTasksForReferences({
    required String userId,
    required Set<String> references,
    String? profileId,
  }) async {
    active.removeAll(references);
    reservations.removeWhere((key, value) => references.contains(key));
    return references.length;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DownloadTestAudioHandler implements BGAudioHandler {
  final protectedItems = <String>{};

  @override
  InternalMedia? get currentMediaItem => null;

  @override
  bool isInQueue(String itemId, {String? episodeId}) => protectedItems.contains(itemId);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DownloadTestProgress extends MediaProgressNotifier {
  final cached = <String, MediaProgress>{};
  int snapshotReads = 0;

  @override
  Future<void> build() async {}

  @override
  MediaProgress? progressForKey(String key) => cached[key];

  @override
  List<MediaProgress> progressForLibraryItem(String itemId) {
    return cached.values.where((entry) => entry.libraryItemId == itemId).toList();
  }

  @override
  Map<String, MediaProgress> get snapshot {
    snapshotReads++;
    return Map.unmodifiable(cached);
  }
}

class DownloadTestSettings extends SettingsManager {
  final values = <String, Object>{};

  @override
  Stream<int> build() => Stream.value(0);

  @override
  T getUserSetting<T>(String? userId, String key, {T? defaultValue}) {
    final value = values[key];
    if (value != null) {
      return value as T;
    }
    if (key == SettingKeys.downloadTypePreference) {
      return 'askEveryTime' as T;
    }
    return defaultValue as T;
  }
}

Future<ProviderContainer> downloadTestContainer(
  DownloadTestDatabase db,
  DownloadTestProgress progress, {
  DownloadTestSettings? settings,
  ABSApi? api,
  Library? library,
  List<Library>? libraries,
  PersonalizedLibrary? personalized,
  Map<String, PersonalizedLibrary>? personalizedByLibrary,
  Map<String, LibraryItem> items = const {},
}) async {
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      if (api != null) absApiProvider.overrideWithValue(api),
      currentUserProvider.overrideWith((ref) => Stream.value(downloadUser(testUserId))),
      serverStatusProvider.overrideWith((ref) => Stream.value(true)),
      selectedLibraryProvider.overrideWith((ref) => library),
      userLibrariesProvider.overrideWith((ref) async => libraries ?? [?library]),
      userSettingsWatcherProvider.overrideWith(() => DownloadTestSettingsWatcher()),
      settingsManagerProvider.overrideWith(() => settings ?? DownloadTestSettings()),
      mediaProgressProvider.overrideWith(() => progress),
      for (final entry in items.entries) libraryItemProvider(entry.key).overrideWith((ref) async => entry.value),
      for (final entry in {
        if (library != null && personalized != null) library.id: personalized,
        ...?personalizedByLibrary,
      }.entries)
        personalizedLibraryProvider(entry.key).overrideWith(() => DownloadTestShelves(entry.value)),
    ],
  );
  container.listen(currentUserProvider, (_, _) {});
  await container.read(currentUserProvider.future);
  container.listen(serverStatusProvider, (_, _) {});
  await container.read(serverStatusProvider.future);
  return container;
}

class DownloadTestSettingsWatcher extends UserSettingsWatcher {
  @override
  Stream<int> build() => const Stream.empty();
}

class DownloadSourceServer {
  DownloadSourceServer(this.collections) {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          requests.add(request);
          final id = request.uri.pathSegments.last;
          final collection = collections.firstWhere((collection) => collection.id == id);
          handler.resolve(Response(requestOptions: request, statusCode: 200, data: jsonDecode(jsonEncode(collection))));
        },
      ),
    );
    api = ABSApi(dio: dio, interceptors: []);
  }

  final List<Collection> collections;
  final requests = <RequestOptions>[];
  late final ABSApi api;
}

class DownloadTestShelves extends PersonalizedLibraryNotifier {
  DownloadTestShelves(this.shelves);

  final PersonalizedLibrary shelves;
  int loads = 0;

  @override
  Future<PersonalizedLibrary?> build(String libraryId) async {
    loads++;
    return shelves;
  }
}
