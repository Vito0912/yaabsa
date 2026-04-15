import 'dart:convert';
import 'dart:io';

import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

@DataClassName('GlobalSettingEntry')
class GlobalSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('UserSettingEntry')
class UserSettings extends Table {
  TextColumn get userId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {userId, key};
}

@DataClassName('StoredUserEntry')
class StoredUsers extends Table {
  TextColumn get id => text()();
  TextColumn get userDataJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StoredSyncEntry')
class StoredSyncs extends Table {
  TextColumn get sessionId => text()();
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get episodeId => text().nullable()();

  RealColumn get currentTime => real()();
  RealColumn get timeListened => real()();
  RealColumn get duration => real()();

  BoolColumn get sessionLocal => boolean()();
  DateTimeColumn get lastUpdated => dateTime()();

  TextColumn get mediaProgress => text()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

@DataClassName('StoredDownloadsEntry')
class StoredDownloads extends Table {
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get episodeId => text().nullable()();

  TextColumn get download => text()();

  @override
  Set<Column> get primaryKey => {itemId, userId, episodeId};

  @override
  List<Set<Column>> get uniqueKeys => [
    {itemId, userId},
  ];
}

@DataClassName('PlayerHistoryEntry')
class PlayerHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get episodeId => text().nullable()();

  TextColumn get type => text()();
  RealColumn get currentTime => real()();

  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();

  // TODO: Indexes for performance
}

@DriftDatabase(tables: [GlobalSettings, UserSettings, StoredUsers, StoredSyncs, StoredDownloads, PlayerHistory])
class AppDatabase extends _$AppDatabase {
  AppDatabase({AuthSecretStore? authSecretStore})
    : _authSecretStore = authSecretStore ?? AuthSecretStore(),
      super(_openConnection());

  AppDatabase.connect(DatabaseConnection connection, {AuthSecretStore? authSecretStore})
    : _authSecretStore = authSecretStore ?? AuthSecretStore(),
      super(connection.executor);

  final AuthSecretStore _authSecretStore;

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from <= 1) {
        await m.createTable(storedSyncs);
      }
      if (from <= 8) {
        await m.drop(storedSyncs);
        await m.createTable(storedSyncs);
      }
      if (from <= 10) {
        await m.createTable(storedDownloads);
      }
      if (from <= 11) {
        await m.drop(storedDownloads);
        await m.createTable(storedDownloads);
      }
      if (from <= 12) {
        await m.drop(storedDownloads);
        await m.createTable(storedDownloads);
      }
      if (from <= 13) {
        await m.createTable(playerHistory);
      }
    },
    beforeOpen: (details) async {},
  );

  // Player history management
  Future<void> addPlayerHistory(PlayerHistoryCompanion companion) {
    return into(playerHistory).insert(companion, mode: InsertMode.insertOrIgnore);
  }

  Stream<List<PlayerHistoryEntry>> watchPlayerHistoryByItem(String itemId, String userId, {String? episodeId}) {
    final query = select(playerHistory)..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId));
    if (episodeId != null) {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.created)]);
    return query.watch();
  }

  // Download management
  Future<List<InternalDownload>> getAllStoredDownloads() async {
    final entries = await select(storedDownloads).get();
    return entries.map((e) => InternalDownload.fromJson(jsonDecode(e.download))).toList();
  }

  Future<List<InternalDownload>> getAllStoredDownloadsByUser(String userId) async {
    final entries = await (select(storedDownloads)..where((tbl) => tbl.userId.equals(userId))).get();
    return entries.map((e) => InternalDownload.fromJson(jsonDecode(e.download))).toList();
  }

  Future<List<InternalDownload>> getAllStoredDownloadsByUserForLibrary(String userId, String libraryId) async {
    final entries = await (select(storedDownloads)..where((tbl) => tbl.userId.equals(userId))).get();
    // TODO: Podcast
    return entries
        .map((e) => InternalDownload.fromJson(jsonDecode(e.download)))
        .toList()
        .where((d) => d.item?.libraryId == libraryId)
        .toList();
  }

  Future<InternalDownload?> getStoredDownload(String itemId, String userId, {String? episodeId}) async {
    final query = select(storedDownloads)..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId));
    if (episodeId != null) {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    }
    final entry = await query.getSingleOrNull();
    if (entry != null) {
      final download = InternalDownload.fromJson(jsonDecode(entry.download));
      if (download.isComplete) {
        return download;
      } else {
        logger(
          'Incomplete download found for itemId: $itemId, userId: $userId, episodeId: $episodeId (target tracks: ${download.numberOfTracks}, downloaded tracks: ${download.numberOfDownloadedTracks}).',
          tag: 'AppDatabase',
          level: InfoLevel.warning,
        );
      }
    }
    return null;
  }

  Future<void> addOrUpdateStoredDownload(StoredDownloadsCompanion companion) {
    return transaction(() async {
      final insertResult = await into(storedDownloads).insert(companion, mode: InsertMode.insertOrIgnore);

      print('Insert result: $insertResult');

      // TODO: Find why the f it returns 3, 0 and somethimes 1
      if (insertResult >= 0) {
        Expression<bool> whereClause =
            storedDownloads.itemId.equals(companion.itemId.value) &
            storedDownloads.userId.equals(companion.userId.value);

        if (companion.episodeId.present && companion.episodeId.value != null) {
          whereClause = whereClause & storedDownloads.episodeId.equals(companion.episodeId.value!);
        } else {
          whereClause = whereClause & storedDownloads.episodeId.isNull();
        }
        final existing = await (select(storedDownloads)..where((tbl) => whereClause)).getSingle();

        final oldDownload = InternalDownload.fromJson(jsonDecode(existing.download));
        final newDownload = InternalDownload.fromJson(jsonDecode(companion.download.value));

        final List<InternalTrack> mergedTracks = [
          ...oldDownload.tracks,
          ...newDownload.tracks.where((track) => !oldDownload.tracks.contains(track)),
        ];
        final updatedDownload = oldDownload.copyWith(tracks: mergedTracks);

        await (update(storedDownloads)..where((tbl) => whereClause)).write(
          StoredDownloadsCompanion(download: Value(jsonEncode(updatedDownload.toJson()))),
        );
      }
    });
  }

  Future<void> deleteStoredDownload(String itemId, String userId, {String? episodeId}) {
    final query = delete(storedDownloads)..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId));
    if (episodeId != null) {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    }
    return query.go();
  }

  // Sync management
  Future<void> addOrUpdateSync(StoredSyncsCompanion companion) {
    return into(storedSyncs).insert(
      companion,
      mode: InsertMode.insertOrIgnore,
      onConflict: DoUpdate(
        (old) => StoredSyncsCompanion.custom(
          timeListened: old.timeListened + Variable<double>(companion.timeListened.value),
          currentTime: Variable<double>(companion.currentTime.value),
          lastUpdated: Variable<DateTime>(companion.lastUpdated.value),
          sessionLocal: Variable<bool>(companion.sessionLocal.value),
          mediaProgress: Variable<String>(companion.mediaProgress.value),
        ),
        target: [storedSyncs.sessionId],
      ),
    );
  }

  Future<void> deleteSync(String sessionId) {
    final query = delete(storedSyncs)..where((tbl) => tbl.sessionId.equals(sessionId));
    return query.go();
  }

  Future<StoredSyncEntry?> getSync(String sessionId) async {
    final query = select(storedSyncs)..where((tbl) => tbl.sessionId.equals(sessionId));
    final entry = await query.getSingleOrNull();
    return entry;
  }

  Future<List<StoredSyncEntry>> getAllSyncs() async {
    return await select(storedSyncs).get();
  }

  // Basic setting operations
  Stream<GlobalSettingEntry?> watchGlobalSetting(String key) {
    return (select(globalSettings)..where((tbl) => tbl.key.equals(key))).watchSingleOrNull().distinct();
  }

  Future<void> setGlobalSetting(String key, String value) {
    final companion = GlobalSettingsCompanion(key: Value(key), value: Value(value));
    return into(globalSettings).insert(companion, mode: InsertMode.replace);
  }

  Future<GlobalSettingEntry?> getGlobalSetting(String key) {
    return (select(globalSettings)..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
  }

  Stream<UserSettingEntry?> watchUserSetting(String userId, String key) {
    return (select(
      userSettings,
    )..where((tbl) => tbl.userId.equals(userId) & tbl.key.equals(key))).watchSingleOrNull().distinct();
  }

  Future<void> setUserSetting(String userId, String key, String value) {
    final companion = UserSettingsCompanion(userId: Value(userId), key: Value(key), value: Value(value));
    return into(userSettings).insert(companion, mode: InsertMode.replace);
  }

  Future<UserSettingEntry?> getUserSetting(String userId, String key) {
    return (select(userSettings)..where((tbl) => tbl.userId.equals(userId) & tbl.key.equals(key))).getSingleOrNull();
  }

  Future<Map<String, String>> getAllGlobalSettings() async {
    final entries = await select(globalSettings).get();
    return Map.fromEntries(entries.map((e) => MapEntry(e.key, e.value)));
  }

  Future<Map<String, Map<String, String>>> getAllUserSettings() async {
    final entries = await select(userSettings).get();
    final result = <String, Map<String, String>>{};
    for (final entry in entries) {
      result.putIfAbsent(entry.userId, () => {})[entry.key] = entry.value;
    }
    return result;
  }

  // User management
  Stream<List<User>> watchAllStoredUsers() {
    return select(storedUsers).watch().asyncMap((rows) async {
      logger(
        'storedUsers stream emitted ${rows.length} StoredUserEntry items.',
        tag: 'AppDatabase',
        level: InfoLevel.debug,
      );

      final userList = <User>[];
      for (final row in rows) {
        try {
          final decodedUser = User.fromJson(jsonDecode(row.userDataJson));
          userList.add(await _hydrateUserWithAuthSecrets(decodedUser));
        } catch (e, s) {
          logger(
            'ERROR decoding User from JSON. Row ID: ${row.id}, JSON: ${row.userDataJson}. Error: $e. Stack: $s',
            tag: 'AppDatabase',
            level: InfoLevel.error,
          );
        }
      }

      return userList;
    }).distinct();
  }

  Future<List<User>> getAllStoredUsers() async {
    final rows = await select(storedUsers).get();
    final users = <User>[];
    for (final row in rows) {
      try {
        final decodedUser = User.fromJson(jsonDecode(row.userDataJson));
        users.add(await _hydrateUserWithAuthSecrets(decodedUser));
      } catch (e, s) {
        logger(
          'ERROR decoding User from JSON. Row ID: ${row.id}, JSON: ${row.userDataJson}. Error: $e. Stack: $s',
          tag: 'AppDatabase',
          level: InfoLevel.error,
        );
      }
    }
    return users;
  }

  Future<void> addOrUpdateStoredUser(User user) async {
    logger(
      '[AppDatabase] addOrUpdateStoredUser called for user ID: ${user.id}, username: ${user.username}, isActive: ${user.isActive}, server: ${user.server?.url}',
      tag: 'AppDatabase',
      level: InfoLevel.debug,
    );

    try {
      final mergedSecrets = await _mergeAuthSecretsForUser(user);
      await _authSecretStore.writeForUser(
        user.id,
        legacyToken: mergedSecrets.legacyToken,
        accessToken: mergedSecrets.accessToken,
        refreshToken: mergedSecrets.refreshToken,
        apiKey: mergedSecrets.apiKey,
        clearMissing: true,
      );

      final userToStore = _sanitizeUserForStorage(user);
      final companion = StoredUsersCompanion(
        id: Value(userToStore.id),
        userDataJson: Value(jsonEncode(userToStore.toJson())),
      );

      await into(storedUsers).insert(companion, mode: InsertMode.replace);

      logger(
        'addOrUpdateStoredUser completed successfully for user ID: ${user.id}',
        tag: 'AppDatabase',
        level: InfoLevel.info,
      );
    } catch (e, s) {
      logger(
        'addOrUpdateStoredUser ERROR for user ID: ${user.id}. Error: $e. Stack: $s',
        tag: 'AppDatabase',
        level: InfoLevel.error,
      );
      rethrow;
    }
  }

  Future<void> deleteStoredUser(String userId) async {
    await (delete(storedUsers)..where((tbl) => tbl.id.equals(userId))).go();
    await _authSecretStore.deleteForUser(userId);
  }

  Future<User?> getStoredUser(String userId) async {
    final row = await (select(storedUsers)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (row != null) {
      final decodedUser = User.fromJson(jsonDecode(row.userDataJson));
      return _hydrateUserWithAuthSecrets(decodedUser);
    }
    return null;
  }

  Future<AuthSecrets> getUserAuthSecrets(String userId) {
    return _authSecretStore.read(userId);
  }

  Future<void> saveUserAuthSecrets(
    String userId, {
    String? legacyToken,
    String? accessToken,
    String? refreshToken,
    String? apiKey,
    bool clearMissing = false,
  }) {
    return _authSecretStore.writeForUser(
      userId,
      legacyToken: legacyToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
      apiKey: apiKey,
      clearMissing: clearMissing,
    );
  }

  Future<void> clearUserAuthSecrets(String userId) {
    return _authSecretStore.deleteForUser(userId);
  }

  Future<void> setActiveUserId(String newActiveUserId) async {
    const activeUserIdKey = 'activeUserId';
    final allCurrentUsers = await select(storedUsers).get();

    await batch((b) {
      for (final userRow in allCurrentUsers) {
        final user = User.fromJson(jsonDecode(userRow.userDataJson));
        bool shouldBeActive = user.id == newActiveUserId;
        if (user.isActive != shouldBeActive) {
          final updatedUser = user.copyWith(isActive: shouldBeActive);
          b.replace(
            storedUsers,
            StoredUsersCompanion(id: Value(updatedUser.id), userDataJson: Value(jsonEncode(updatedUser.toJson()))),
          );
        }
      }
    });
    await setGlobalSetting(activeUserIdKey, newActiveUserId);
  }

  Future<void> clearActiveUserId() {
    const activeUserIdKey = 'activeUserId';
    return (delete(globalSettings)..where((tbl) => tbl.key.equals(activeUserIdKey))).go();
  }

  Future<AuthSecrets> _mergeAuthSecretsForUser(User user) async {
    final existing = await _authSecretStore.read(user.id);
    return AuthSecrets(
      legacyToken: user.token ?? existing.legacyToken,
      accessToken: user.accessToken ?? existing.accessToken,
      refreshToken: user.refreshToken ?? existing.refreshToken,
      apiKey: user.apiKey ?? existing.apiKey,
    );
  }

  Future<User> _hydrateUserWithAuthSecrets(User user) async {
    final merged = await _mergeAuthSecretsForUser(user);

    final hasPlainTextSecrets =
        user.token != null || user.accessToken != null || user.refreshToken != null || user.apiKey != null;

    if (hasPlainTextSecrets) {
      await _authSecretStore.writeForUser(
        user.id,
        legacyToken: merged.legacyToken,
        accessToken: merged.accessToken,
        refreshToken: merged.refreshToken,
        apiKey: merged.apiKey,
        clearMissing: true,
      );

      final sanitized = _sanitizeUserForStorage(user);
      await into(storedUsers).insert(
        StoredUsersCompanion(id: Value(sanitized.id), userDataJson: Value(jsonEncode(sanitized.toJson()))),
        mode: InsertMode.replace,
      );
    }

    return user.copyWith(
      token: merged.legacyToken,
      accessToken: merged.accessToken,
      refreshToken: merged.refreshToken,
      apiKey: merged.apiKey,
    );
  }

  User _sanitizeUserForStorage(User user) {
    return User(
      id: user.id,
      username: user.username,
      email: user.email,
      type: user.type,
      token: null,
      accessToken: null,
      refreshToken: null,
      apiKey: null,
      mediaProgress: null,
      seriesHideFromContinueListening: user.seriesHideFromContinueListening,
      bookmarks: null,
      isActive: user.isActive,
      isLocked: user.isLocked,
      lastSeen: user.lastSeen,
      createdAt: user.createdAt,
      permissions: user.permissions,
      librariesAccessible: user.librariesAccessible,
      itemTagsSelected: user.itemTagsSelected,
      hasOpenIdLink: user.hasOpenIdLink,
      setting: user.setting,
      server: user.server,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, appName, 'app_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final authSecretStore = ref.watch(authSecretStoreProvider);
  return AppDatabase(authSecretStore: authSecretStore);
}
