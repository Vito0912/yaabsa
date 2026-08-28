import 'dart:convert';
import 'dart:io';

import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drift/drift.dart';
import 'package:yaabsa/database/connection/connection.dart' as impl;
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

@DataClassName('BookPlaybackSpeedEntry')
class BookPlaybackSpeeds extends Table {
  TextColumn get userId => text()();
  TextColumn get itemId => text()();
  RealColumn get speed => real()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, itemId};
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

@DataClassName('StoredMediaProgressEntry')
class StoredMediaProgress extends Table {
  TextColumn get progressId => text()();
  TextColumn get userId => text()();
  TextColumn get itemId => text()();
  TextColumn get episodeId => text().nullable()();

  DateTimeColumn get lastUpdated => dateTime()();
  TextColumn get mediaProgress => text()();

  @override
  Set<Column> get primaryKey => {progressId};
}

@DataClassName('StoredBookmarkSyncEntry')
class StoredBookmarkSyncs extends Table {
  TextColumn get userId => text()();
  TextColumn get itemId => text()();
  IntColumn get time => integer()();

  TextColumn get title => text().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, itemId, time};
}

@DataClassName('StoredDownloadsEntry')
class StoredDownloads extends Table {
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get episodeId => text().nullable()();

  TextColumn get download => text()();
  TextColumn get downloadOrigin => text().withDefault(const Constant('manual'))();
  TextColumn get smartProfileIds => text().withDefault(const Constant('[]'))();
  IntColumn get managedBytes => integer().nullable()();
  IntColumn get completedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {itemId, userId, episodeId};
}

@DataClassName('StoredDownloadFileEntry')
class StoredDownloadFiles extends Table {
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get episodeId => text().nullable()();
  TextColumn get fileKey => text()();

  TextColumn get trackJson => text().nullable()();
  TextColumn get auxiliaryPath => text().nullable()();
  TextColumn get sidecarPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {itemId, userId, episodeId, fileKey};
}

@DataClassName('SmartDownloadProfileEntry')
class SmartDownloadProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get policy => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id, userId};
}

@DataClassName('SmartDownloadSourceEntry')
class SmartDownloadSources extends Table {
  TextColumn get profileId => text()();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text()();
  TextColumn get libraryId => text()();
  TextColumn get displayName => text().nullable()();
  BoolColumn get descending => boolean().withDefault(const Constant(false))();
  IntColumn get sourceRevision => integer().nullable()();
  TextColumn get candidateSnapshot => text().nullable()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {profileId, sourceType, sourceId};
}

@DataClassName('SmartDownloadClaimEntry')
class SmartDownloadClaims extends Table {
  TextColumn get profileId => text()();
  TextColumn get referenceKey => text()();
  TextColumn get itemId => text()();
  TextColumn get episodeId => text().nullable()();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text()();
  TextColumn get state => text()();
  IntColumn get estimatedBytes => integer().nullable()();
  IntColumn get completedAt => integer().nullable()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {profileId, referenceKey};
}

@DataClassName('PlayerHistoryEntry')
class PlayerHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemId => text()();
  TextColumn get userId => text()();
  TextColumn get episodeId => text().nullable()();

  TextColumn get type => text()();
  RealColumn get currentTime => real()();
  TextColumn get detailsJson => text().nullable()();

  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();

  List<Index> get indexes => [
    Index(
      'player_history_item_user_created_idx',
      'CREATE INDEX player_history_item_user_created_idx ON player_history (item_id, user_id, created DESC)',
    ),
    Index(
      'player_history_item_user_episode_created_idx',
      'CREATE INDEX player_history_item_user_episode_created_idx ON player_history (item_id, user_id, episode_id, created DESC)',
    ),
  ];
}

class _StoredDownloadCacheEntry {
  const _StoredDownloadCacheEntry({required this.signature, required this.value});

  final String signature;
  final Future<InternalDownload?> value;
}

const int _storedDownloadStorageVersion = 2;
const String _storedDownloadStorageVersionKey = '_storageVersion';
const String _storedDownloadStorageBaseKey = 'base';

@DriftDatabase(
  tables: [
    GlobalSettings,
    UserSettings,
    BookPlaybackSpeeds,
    StoredUsers,
    StoredSyncs,
    StoredMediaProgress,
    StoredBookmarkSyncs,
    StoredDownloads,
    StoredDownloadFiles,
    SmartDownloadProfiles,
    SmartDownloadSources,
    SmartDownloadClaims,
    PlayerHistory,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase({AuthSecretStore? authSecretStore})
    : _authSecretStore = authSecretStore ?? AuthSecretStore(),
      super(impl.openConnection());

  AppDatabase.connect(DatabaseConnection connection, {AuthSecretStore? authSecretStore})
    : _authSecretStore = authSecretStore ?? AuthSecretStore(),
      super(connection.executor);

  final AuthSecretStore _authSecretStore;
  final Map<String, _StoredDownloadCacheEntry> _storedDownloadCache = <String, _StoredDownloadCacheEntry>{};
  final Map<String, Future<InternalDownload?>> _storedDownloadBaseCache = <String, Future<InternalDownload?>>{};
  bool? _storedDownloadFilesAvailable;

  @override
  int get schemaVersion => 24;

  Future<void> _addColumnIfMissing(Migrator migrator, TableInfo table, GeneratedColumn column) async {
    final tableName = table.actualTableName.replaceAll('"', '""');
    final columns = await migrator.database.customSelect('PRAGMA table_info("$tableName")').get();
    final columnName = column.$name.toLowerCase();
    final columnExists = columns.any((row) => row.read<String>('name').toLowerCase() == columnName);
    if (!columnExists) {
      await migrator.addColumn(table, column);
    }
  }

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
      if (from <= 14) {
        await m.createTable(storedMediaProgress);
      }
      if (from <= 15) {
        await m.createTable(bookPlaybackSpeeds);
      }
      if (from <= 16) {
        await customStatement(
          'CREATE INDEX IF NOT EXISTS player_history_item_user_created_idx '
          'ON player_history (item_id, user_id, created DESC)',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS player_history_item_user_episode_created_idx '
          'ON player_history (item_id, user_id, episode_id, created DESC)',
        );
      }
      if (from <= 17) {
        await m.createTable(storedBookmarkSyncs);
      }
      if (from <= 18) {
        await customStatement('ALTER TABLE stored_downloads RENAME TO _stored_downloads_old;');
        await m.createTable(storedDownloads);
        await customStatement(
          'INSERT INTO stored_downloads (item_id, user_id, episode_id, download) '
          'SELECT item_id, user_id, episode_id, download FROM _stored_downloads_old;',
        );
        await customStatement('DROP TABLE _stored_downloads_old;');
      }
      if (from >= 14 && from <= 19) {
        await _addColumnIfMissing(m, playerHistory, playerHistory.detailsJson);
      }
      if (from <= 20) {
        await m.createTable(smartDownloadProfiles);
        await m.createTable(smartDownloadSources);
        await m.createTable(smartDownloadClaims);
        if (from > 18) {
          await _addColumnIfMissing(m, storedDownloads, storedDownloads.downloadOrigin);
          await _addColumnIfMissing(m, storedDownloads, storedDownloads.smartProfileIds);
          await _addColumnIfMissing(m, storedDownloads, storedDownloads.managedBytes);
          await _addColumnIfMissing(m, storedDownloads, storedDownloads.completedAt);
        }
      }
      if (from == 21) {
        await _addColumnIfMissing(m, smartDownloadSources, smartDownloadSources.displayName);
      }
      if (from <= 22) {
        await m.createTable(storedDownloadFiles);
      }
      if (from >= 21 && from <= 23) {
        await customStatement('ALTER TABLE smart_download_claims RENAME TO _smart_download_claims_old;');
        await m.createTable(smartDownloadClaims);
        await customStatement(
          'INSERT OR REPLACE INTO smart_download_claims '
          '(profile_id, reference_key, item_id, episode_id, source_type, source_id, state, '
          'estimated_bytes, completed_at, updated_at) '
          "SELECT profile_id, item_id || '::' || COALESCE(episode_id, ''), item_id, episode_id, "
          'source_type, source_id, state, estimated_bytes, completed_at, updated_at '
          'FROM _smart_download_claims_old ORDER BY updated_at ASC;',
        );
        await customStatement('DROP TABLE _smart_download_claims_old;');
      }
    },
    beforeOpen: (details) async {},
  );

  // Player history management
  Future<void> addPlayerHistory(PlayerHistoryCompanion companion) {
    return into(playerHistory).insert(companion, mode: InsertMode.insertOrIgnore);
  }

  Stream<List<PlayerHistoryEntry>> watchPlayerHistoryByItem(
    String itemId,
    String userId, {
    String? episodeId,
    int limit = 1200,
  }) {
    final query = select(playerHistory)..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId));
    if (episodeId != null) {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    } else {
      query.where((tbl) => tbl.episodeId.isNull());
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.created)]);
    if (limit > 0) {
      query.limit(limit);
    }
    return query.watch();
  }

  Expression<bool> _storedDownloadWhereExpression({
    required String itemId,
    required String userId,
    required String? episodeId,
  }) {
    var whereClause = storedDownloads.itemId.equals(itemId) & storedDownloads.userId.equals(userId);
    if (episodeId != null) {
      whereClause = whereClause & storedDownloads.episodeId.equals(episodeId);
    } else {
      whereClause = whereClause & storedDownloads.episodeId.isNull();
    }
    return whereClause;
  }

  Expression<bool> _storedDownloadFileWhereExpression({
    required String itemId,
    required String userId,
    required String? episodeId,
  }) {
    var whereClause = storedDownloadFiles.itemId.equals(itemId) & storedDownloadFiles.userId.equals(userId);
    if (episodeId != null) {
      whereClause = whereClause & storedDownloadFiles.episodeId.equals(episodeId);
    } else {
      whereClause = whereClause & storedDownloadFiles.episodeId.isNull();
    }
    return whereClause;
  }

  Future<List<StoredDownloadFileEntry>> _getStoredDownloadFiles({
    required String itemId,
    required String userId,
    required String? episodeId,
  }) {
    return (select(
      storedDownloadFiles,
    )..where((tbl) => _storedDownloadFileWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId))).get();
  }

  InternalDownload _withStoredDownloadFiles(InternalDownload base, List<StoredDownloadFileEntry> files) {
    final tracks = <InternalTrack>[];
    final auxiliaryPaths = <String>{};
    final sidecarPaths = <String>{};

    for (final file in files) {
      final trackJson = file.trackJson;
      if (trackJson != null) {
        try {
          final decoded = jsonDecode(trackJson);
          if (decoded is Map) {
            tracks.add(InternalTrack.fromJson(Map<String, dynamic>.from(decoded)));
          }
        } catch (e, s) {
          logger(
            'Failed to decode stored download file ${file.fileKey}: $e\n$s',
            tag: 'AppDatabase',
            level: InfoLevel.warning,
          );
        }
      }

      final auxiliaryPath = file.auxiliaryPath;
      if (auxiliaryPath != null && auxiliaryPath.trim().isNotEmpty) {
        auxiliaryPaths.add(auxiliaryPath);
      }

      final sidecarPath = file.sidecarPath;
      if (sidecarPath != null && sidecarPath.trim().isNotEmpty) {
        sidecarPaths.add(sidecarPath);
      }
    }

    tracks.sort((left, right) => left.index.compareTo(right.index));
    return base.copyWith(
      tracks: tracks,
      auxiliaryFilePaths: auxiliaryPaths.toList(growable: false)..sort(),
      sidecarPaths: sidecarPaths.toList(growable: false)..sort(),
    );
  }

  InternalDownload? _decodeDownloadJsonOrNull(
    String rawJson, {
    required String itemId,
    required String userId,
    required String? episodeId,
  }) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is Map) {
        final decodedMap = Map<String, dynamic>.from(decoded);
        final base = decodedMap[_storedDownloadStorageBaseKey];
        if (decodedMap[_storedDownloadStorageVersionKey] == _storedDownloadStorageVersion && base is Map) {
          return InternalDownload.fromJson(Map<String, dynamic>.from(base));
        }
        return InternalDownload.fromJson(decodedMap);
      }
      throw const FormatException('Stored download payload is not a JSON object');
    } catch (e, s) {
      logger(
        'Failed to decode stored download itemId=$itemId userId=$userId episodeId=$episodeId: $e\n$s',
        tag: 'AppDatabase',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  bool _isNormalizedStoredDownload(String rawJson) {
    return rawJson.trimLeft().startsWith('{"$_storedDownloadStorageVersionKey":$_storedDownloadStorageVersion,');
  }

  bool _isStoredDownloadFilesUnavailable(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('stored_download_files') &&
        (message.contains('no such table') || message.contains('no such column') || message.contains('does not exist'));
  }

  String _encodeNormalizedStoredDownload(InternalDownload download, {bool includeInlineFiles = false}) {
    final compactDownload = includeInlineFiles
        ? download
        : download.copyWith(
            tracks: const <InternalTrack>[],
            auxiliaryFilePaths: const <String>[],
            sidecarPaths: const <String>[],
          );
    return jsonEncode(<String, dynamic>{
      _storedDownloadStorageVersionKey: _storedDownloadStorageVersion,
      _storedDownloadStorageBaseKey: compactDownload.toJson(),
    });
  }

  String _storedDownloadCacheKey(StoredDownloadsEntry entry) {
    return '${entry.userId}\u0000${entry.itemId}\u0000${entry.episodeId ?? ''}';
  }

  String _storedDownloadCacheSignature(StoredDownloadsEntry entry) {
    return [
      entry.download,
      entry.downloadOrigin,
      entry.smartProfileIds,
      entry.managedBytes,
      entry.completedAt,
    ].join('\u0000');
  }

  Future<InternalDownload?> _decodeStoredDownloadOrNull(StoredDownloadsEntry entry) {
    final key = _storedDownloadCacheKey(entry);
    final signature = _storedDownloadCacheSignature(entry);
    final cached = _storedDownloadCache[key];
    if (cached?.signature == signature) {
      return cached!.value;
    }

    final value = _decodeStoredDownloadUncached(entry);
    _storedDownloadCache[key] = _StoredDownloadCacheEntry(signature: signature, value: value);
    return value;
  }

  Future<InternalDownload?> _decodeNormalizedStoredDownloadBase(StoredDownloadsEntry entry) {
    final cached = _storedDownloadBaseCache[entry.download];
    if (cached != null) {
      return cached;
    }

    final value = Future<InternalDownload?>.value(
      _decodeDownloadJsonOrNull(entry.download, itemId: entry.itemId, userId: entry.userId, episodeId: entry.episodeId),
    );
    _storedDownloadBaseCache[entry.download] = value;
    return value;
  }

  Future<InternalDownload?> _decodeStoredDownloadUncached(StoredDownloadsEntry entry) async {
    final decoded = _isNormalizedStoredDownload(entry.download)
        ? await _decodeNormalizedStoredDownloadBase(entry)
        : _decodeDownloadJsonOrNull(
            entry.download,
            itemId: entry.itemId,
            userId: entry.userId,
            episodeId: entry.episodeId,
          );
    if (decoded == null) {
      return null;
    }

    var storedDownload = decoded;
    if (_isNormalizedStoredDownload(entry.download)) {
      if (_storedDownloadFilesAvailable != false) {
        try {
          final files = await _getStoredDownloadFiles(
            itemId: entry.itemId,
            userId: entry.userId,
            episodeId: entry.episodeId,
          );
          _storedDownloadFilesAvailable = true;
          if (files.isNotEmpty) {
            storedDownload = _withStoredDownloadFiles(storedDownload, files);
          }
        } catch (e) {
          if (!_isStoredDownloadFilesUnavailable(e)) {
            rethrow;
          }
          _storedDownloadFilesAvailable = false;
          logger(
            'Stored download file table is unavailable. Using inline download fallback: $e',
            tag: 'AppDatabase',
            level: InfoLevel.warning,
          );
        }
      }
    }

    final resolvedDownload = await storedDownload.resolvePaths();

    final validTracks = (await Future.wait(
      resolvedDownload.tracks.map((track) async {
        final trackUrl = track.url;
        return trackUrl != null && await _storedPathExists(trackUrl) ? track : null;
      }),
    )).whereType<InternalTrack>().toList(growable: false);

    final validAuxiliaryPaths = (await Future.wait(
      resolvedDownload.auxiliaryFilePaths.map((path) async => await _storedPathExists(path) ? path : null),
    )).whereType<String>().toSet().toList(growable: false)..sort();

    final validSidecarPaths = (await Future.wait(
      resolvedDownload.sidecarPaths.map((path) async => await _storedPathExists(path) ? path : null),
    )).whereType<String>().toSet().toList(growable: false)..sort();

    final coverPath = resolvedDownload.coverPath;
    final validCoverPath = coverPath != null && await _storedPathExists(coverPath) ? coverPath : null;

    return resolvedDownload.copyWith(
      tracks: validTracks,
      auxiliaryFilePaths: validAuxiliaryPaths,
      sidecarPaths: validSidecarPaths,
      coverPath: validCoverPath,
      downloadOrigin: entry.downloadOrigin,
      smartProfileIds: _decodeSmartProfileIds(entry.smartProfileIds),
      managedBytes: entry.managedBytes,
      completedAt: entry.completedAt,
    );
  }

  List<String> _decodeSmartProfileIds(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<String>().where((id) => id.trim().isNotEmpty).toList(growable: false);
      }
    } catch (_) {}
    return const <String>[];
  }

  Future<List<InternalDownload>> _decodeStoredDownloads(Iterable<StoredDownloadsEntry> entries) async {
    final downloads = <InternalDownload>[];
    for (final entry in entries) {
      final parsed = await _decodeStoredDownloadOrNull(entry);
      if (parsed != null) {
        downloads.add(parsed);
      }
      await Future<void>.delayed(Duration.zero);
    }
    return downloads;
  }

  bool _sameStringSet(Set<String> left, Set<String> right) {
    return left.length == right.length && left.containsAll(right);
  }

  Future<bool> _storedPathExists(String rawPath) async {
    if (kIsWeb) {
      return false;
    }
    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return false;
    }

    if (Platform.isWindows && RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(trimmed)) {
      return File(trimmed).exists();
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed == null || parsed.scheme.isEmpty) {
      return File(trimmed).exists();
    }

    if (parsed.scheme == 'file') {
      try {
        return await File.fromUri(parsed).exists();
      } catch (_) {
        return false;
      }
    }

    // Non-file URIs (for example SAF on Android) cannot be verified synchronously here.
    return true;
  }

  // Download management
  Future<List<InternalDownload>> getAllStoredDownloads() async {
    final entries = await select(storedDownloads).get();
    return _decodeStoredDownloads(entries);
  }

  Future<List<InternalDownload>> getAllStoredDownloadsByUser(String userId) async {
    final entries = await (select(storedDownloads)..where((tbl) => tbl.userId.equals(userId))).get();
    return _decodeStoredDownloads(entries);
  }

  Future<List<StoredDownloadsEntry>> getStoredDownloadEntriesByUser(String userId) {
    return (select(storedDownloads)..where((tbl) => tbl.userId.equals(userId))).get();
  }

  Future<List<SmartDownloadClaimEntry>> getSmartDownloadClaimsForReference(String itemId, String? episodeId) {
    final query = select(smartDownloadClaims)..where((tbl) => tbl.itemId.equals(itemId));
    if (episodeId == null) {
      query.where((tbl) => tbl.episodeId.isNull());
    } else {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    }
    return query.get();
  }

  Future<void> deleteSmartDownloadClaimsForProfile(String profileId) {
    return (delete(smartDownloadClaims)..where((tbl) => tbl.profileId.equals(profileId))).go();
  }

  Future<void> deleteSmartDownloadClaim(String profileId, String itemId, {String? episodeId}) {
    final query = delete(smartDownloadClaims)
      ..where((tbl) => tbl.profileId.equals(profileId) & tbl.itemId.equals(itemId));
    if (episodeId == null) {
      query.where((tbl) => tbl.episodeId.isNull());
    } else {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    }
    return query.go();
  }

  Future<List<InternalDownload>> getAllStoredDownloadsByUserForLibrary(String userId, String libraryId) async {
    final entries = await (select(storedDownloads)..where((tbl) => tbl.userId.equals(userId))).get();
    return (await _decodeStoredDownloads(entries)).where((d) => d.item?.libraryId == libraryId).toList();
  }

  Stream<List<InternalDownload>> watchStoredDownloadsByUser(String userId) {
    final query = select(storedDownloads)..where((tbl) => tbl.userId.equals(userId));
    return query.watch().distinct(_sameStoredDownloadEntries).asyncMap(_decodeStoredDownloads);
  }

  Stream<List<InternalDownload>> watchStoredDownloadsByUserForItem(String userId, String itemId) {
    final query = select(storedDownloads)..where((tbl) => tbl.userId.equals(userId) & tbl.itemId.equals(itemId));
    return query.watch().distinct(_sameStoredDownloadEntries).asyncMap(_decodeStoredDownloads);
  }

  bool _sameStoredDownloadEntries(List<StoredDownloadsEntry> left, List<StoredDownloadsEntry> right) {
    if (left.length != right.length) {
      return false;
    }
    for (var index = 0; index < left.length; index++) {
      final leftEntry = left[index];
      final rightEntry = right[index];
      if (leftEntry.itemId != rightEntry.itemId ||
          leftEntry.userId != rightEntry.userId ||
          leftEntry.episodeId != rightEntry.episodeId ||
          leftEntry.download != rightEntry.download ||
          leftEntry.downloadOrigin != rightEntry.downloadOrigin ||
          leftEntry.smartProfileIds != rightEntry.smartProfileIds ||
          leftEntry.managedBytes != rightEntry.managedBytes ||
          leftEntry.completedAt != rightEntry.completedAt) {
        return false;
      }
    }
    return true;
  }

  Stream<Set<String>> watchCompletedDownloadItemIdsByUser(String userId) {
    final query = select(storedDownloads)..where((tbl) => tbl.userId.equals(userId));
    return query
        .watch()
        .distinct(_sameStoredDownloadEntries)
        .asyncMap((entries) async {
          final itemIds = <String>{};
          for (final entry in entries) {
            final parsed = await _decodeStoredDownloadOrNull(entry);
            if (parsed?.isComplete ?? false) {
              if (entry.episodeId == null) {
                itemIds.add(entry.itemId);
              } else {
                itemIds.add(entry.episodeId!);
              }
            }
          }
          return itemIds;
        })
        .distinct(_sameStringSet);
  }

  Future<InternalDownload?> getStoredDownload(String itemId, String userId, {String? episodeId}) async {
    final query = select(storedDownloads)..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId));
    if (episodeId != null) {
      query.where((tbl) => tbl.episodeId.equals(episodeId));
    }
    if (episodeId == null) {
      query.limit(1);
    }
    final entry = await query.getSingleOrNull();
    if (entry != null) {
      final download = await _decodeStoredDownloadOrNull(entry);
      if (download == null) {
        return null;
      }
      if (download.isComplete) {
        return download;
      } else {
        logger(
          'Incomplete download found for itemId: $itemId, userId: $userId, episodeId: $episodeId (target files: ${download.numberOfFiles}, downloaded files: ${download.numberOfDownloadedFiles}).',
          tag: 'AppDatabase',
          level: InfoLevel.warning,
        );
      }
    }
    return null;
  }

  InternalDownload _mergeDownloads(InternalDownload? oldDownload, InternalDownload newDownload) {
    if (oldDownload == null) {
      return newDownload;
    }

    final mergedByIndex = <int, InternalTrack>{};
    for (final track in oldDownload.tracks) {
      mergedByIndex[track.index] = track;
    }
    for (final track in newDownload.tracks) {
      final current = mergedByIndex[track.index];
      if (current == null || track.url != null) {
        mergedByIndex[track.index] = track;
      }
    }

    final mergedTracks = mergedByIndex.values.toList()..sort((left, right) => left.index.compareTo(right.index));

    final mergedAuxiliaryPaths = <String>{
      ...oldDownload.auxiliaryFilePaths.where((path) => path.trim().isNotEmpty),
      ...newDownload.auxiliaryFilePaths.where((path) => path.trim().isNotEmpty),
    }.toList(growable: false)..sort();

    final mergedSidecarPaths = <String>{
      ...oldDownload.sidecarPaths.where((path) => path.trim().isNotEmpty),
      ...newDownload.sidecarPaths.where((path) => path.trim().isNotEmpty),
    }.toList(growable: false)..sort();

    final expectedCountCandidates = <int>{
      if (oldDownload.expectedFileCount != null && oldDownload.expectedFileCount! > 0) oldDownload.expectedFileCount!,
      if (newDownload.expectedFileCount != null && newDownload.expectedFileCount! > 0) newDownload.expectedFileCount!,
    };

    final mergedExpectedFileCount = expectedCountCandidates.isEmpty
        ? null
        : expectedCountCandidates.reduce((left, right) => left > right ? left : right);

    final String mergedDownloadType;
    if (oldDownload.downloadType == 'both' || newDownload.downloadType == 'both') {
      mergedDownloadType = 'both';
    } else if (oldDownload.downloadType != newDownload.downloadType) {
      mergedDownloadType = 'both';
    } else {
      mergedDownloadType = oldDownload.downloadType;
    }

    return oldDownload.copyWith(
      item: newDownload.item ?? oldDownload.item,
      episode: newDownload.episode ?? oldDownload.episode,
      tracks: mergedTracks,
      expectedFileCount: mergedExpectedFileCount,
      auxiliaryFilePaths: mergedAuxiliaryPaths,
      saf: oldDownload.saf || newDownload.saf,
      downloadBasePath: newDownload.downloadBasePath ?? oldDownload.downloadBasePath,
      coverPath: newDownload.coverPath ?? oldDownload.coverPath,
      sidecarPaths: mergedSidecarPaths,
      downloadType: mergedDownloadType,
    );
  }

  String _mergeDownloadOrigin(String existing, String requested) {
    if (existing == 'manual' || requested == 'manual') {
      return 'manual';
    }
    return 'smart';
  }

  String _mergeSmartProfileIds(String existing, String requested) {
    Set<String> decode(String value) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.whereType<String>().where((id) => id.trim().isNotEmpty).toSet();
        }
      } catch (_) {}
      return <String>{};
    }

    return jsonEncode(<String>{...decode(existing), ...decode(requested)}.toList()..sort());
  }

  int? _nextStoredDownloadCompletedAt(int? requested, int? existing) {
    if (requested == null) {
      return existing;
    }
    if (existing == null || requested > existing) {
      return requested;
    }
    return existing + 1;
  }

  Future<InternalDownload?> _downloadForStorageMerge(StoredDownloadsEntry entry) async {
    final decoded = _isNormalizedStoredDownload(entry.download)
        ? await _decodeNormalizedStoredDownloadBase(entry)
        : _decodeDownloadJsonOrNull(
            entry.download,
            itemId: entry.itemId,
            userId: entry.userId,
            episodeId: entry.episodeId,
          );
    if (decoded == null || !_isNormalizedStoredDownload(entry.download)) {
      return decoded;
    }

    if (_storedDownloadFilesAvailable == false) {
      return decoded;
    }

    try {
      final files = await _getStoredDownloadFiles(
        itemId: entry.itemId,
        userId: entry.userId,
        episodeId: entry.episodeId,
      );
      _storedDownloadFilesAvailable = true;
      return files.isEmpty ? decoded : _withStoredDownloadFiles(decoded, files);
    } catch (e) {
      if (_isStoredDownloadFilesUnavailable(e)) {
        _storedDownloadFilesAvailable = false;
        return decoded;
      }
      rethrow;
    }
  }

  Future<void> _replaceStoredDownloadFile({
    required String itemId,
    required String userId,
    required String? episodeId,
    required String fileKey,
    required InternalDownload download,
  }) async {
    final whereClause = _storedDownloadFileWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId);
    await (delete(storedDownloadFiles)..where((tbl) => whereClause & tbl.fileKey.equals(fileKey))).go();

    InternalTrack? track;
    for (final candidate in download.tracks) {
      if (candidate.url != null && candidate.url!.trim().isNotEmpty) {
        track = candidate;
        break;
      }
    }

    String? auxiliaryPath;
    for (final candidate in download.auxiliaryFilePaths) {
      if (candidate.trim().isNotEmpty) {
        auxiliaryPath = candidate;
        break;
      }
    }

    String? sidecarPath;
    for (final candidate in download.sidecarPaths) {
      if (candidate.trim().isNotEmpty) {
        sidecarPath = candidate;
        break;
      }
    }

    await into(storedDownloadFiles).insert(
      StoredDownloadFilesCompanion(
        itemId: Value(itemId),
        userId: Value(userId),
        episodeId: Value(episodeId),
        fileKey: Value(fileKey),
        trackJson: Value(track == null ? null : jsonEncode(track.toJson())),
        auxiliaryPath: Value(auxiliaryPath),
        sidecarPath: Value(sidecarPath),
      ),
    );
  }

  Future<void> _insertStoredDownloadFilesFromDownload({
    required String itemId,
    required String userId,
    required String? episodeId,
    required InternalDownload download,
  }) async {
    var ordinal = 0;
    for (final track in download.tracks.where((track) => track.url?.trim().isNotEmpty ?? false)) {
      await _replaceStoredDownloadFile(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        fileKey: 'legacy-track-${track.index}-${ordinal++}',
        download: download.copyWith(
          tracks: <InternalTrack>[track],
          auxiliaryFilePaths: const <String>[],
          sidecarPaths: const <String>[],
        ),
      );
    }

    for (final path in download.auxiliaryFilePaths.where((path) => path.trim().isNotEmpty)) {
      await _replaceStoredDownloadFile(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        fileKey: 'legacy-auxiliary-${ordinal++}',
        download: download.copyWith(
          tracks: const <InternalTrack>[],
          auxiliaryFilePaths: <String>[path],
          sidecarPaths: const <String>[],
        ),
      );
    }

    for (final path in download.sidecarPaths.where((path) => path.trim().isNotEmpty)) {
      await _replaceStoredDownloadFile(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        fileKey: 'legacy-sidecar-${ordinal++}',
        download: download.copyWith(
          tracks: const <InternalTrack>[],
          auxiliaryFilePaths: const <String>[],
          sidecarPaths: <String>[path],
        ),
      );
    }
  }

  Future<void> _addOrUpdateStoredDownloadFileNormalized({
    required String itemId,
    required String userId,
    required String? episodeId,
    required String fileKey,
    required InternalDownload download,
    required String downloadOrigin,
    required List<String> smartProfileIds,
    required int? managedBytes,
    required int? completedAt,
  }) async {
    await transaction(() async {
      final requestedWhereClause = _storedDownloadWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId);
      final exactRows = await (select(storedDownloads)..where((tbl) => requestedWhereClause)).get();
      final rowsToMerge = <StoredDownloadsEntry>[...exactRows];

      if (rowsToMerge.isEmpty && episodeId == null) {
        final legacyRows =
            await (select(storedDownloads)
                  ..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId))
                  ..limit(1))
                .get();
        rowsToMerge.addAll(legacyRows);
      }

      if (exactRows.length == 1 && _isNormalizedStoredDownload(rowsToMerge.first.download)) {
        final existing = rowsToMerge.first;
        final mergedOrigin = _mergeDownloadOrigin(existing.downloadOrigin, downloadOrigin);
        final mergedProfileIds = _mergeSmartProfileIds(existing.smartProfileIds, jsonEncode(smartProfileIds));
        await (update(storedDownloads)..where((tbl) => requestedWhereClause)).write(
          StoredDownloadsCompanion(
            downloadOrigin: Value(mergedOrigin),
            smartProfileIds: Value(mergedProfileIds),
            managedBytes: managedBytes == null ? Value(existing.managedBytes) : Value(managedBytes),
            completedAt: Value(_nextStoredDownloadCompletedAt(completedAt, existing.completedAt)),
          ),
        );
        await _replaceStoredDownloadFile(
          itemId: itemId,
          userId: userId,
          episodeId: episodeId,
          fileKey: fileKey,
          download: download,
        );
        _storedDownloadCache.remove('$userId\u0000$itemId\u0000${episodeId ?? ''}');
        return;
      }

      InternalDownload mergedDownload = download;
      var mergedOrigin = downloadOrigin;
      var mergedProfileIds = jsonEncode(smartProfileIds);
      int? mergedManagedBytes = managedBytes;
      int? mergedCompletedAt = completedAt;

      for (final existing in rowsToMerge) {
        final existingDownload = await _downloadForStorageMerge(existing);
        if (existingDownload != null) {
          mergedDownload = _mergeDownloads(existingDownload, mergedDownload);
        }
        mergedOrigin = _mergeDownloadOrigin(mergedOrigin, existing.downloadOrigin);
        mergedProfileIds = _mergeSmartProfileIds(mergedProfileIds, existing.smartProfileIds);
        mergedManagedBytes ??= existing.managedBytes;
        mergedCompletedAt = _nextStoredDownloadCompletedAt(mergedCompletedAt, existing.completedAt);
      }

      for (final existing in rowsToMerge) {
        _storedDownloadBaseCache.remove(existing.download);
        final existingWhereClause = _storedDownloadWhereExpression(
          itemId: existing.itemId,
          userId: existing.userId,
          episodeId: existing.episodeId,
        );
        await (delete(storedDownloads)..where((tbl) => existingWhereClause)).go();
        final existingFileWhereClause = _storedDownloadFileWhereExpression(
          itemId: existing.itemId,
          userId: existing.userId,
          episodeId: existing.episodeId,
        );
        await (delete(storedDownloadFiles)..where((tbl) => existingFileWhereClause)).go();
      }

      await into(storedDownloads).insert(
        StoredDownloadsCompanion(
          itemId: Value(itemId),
          userId: Value(userId),
          episodeId: Value(episodeId),
          download: Value(_encodeNormalizedStoredDownload(mergedDownload, includeInlineFiles: true)),
          downloadOrigin: Value(mergedOrigin),
          smartProfileIds: Value(mergedProfileIds),
          managedBytes: Value(mergedManagedBytes),
          completedAt: Value(mergedCompletedAt),
        ),
      );

      if (rowsToMerge.isEmpty) {
        await _replaceStoredDownloadFile(
          itemId: itemId,
          userId: userId,
          episodeId: episodeId,
          fileKey: fileKey,
          download: download,
        );
      } else {
        await _insertStoredDownloadFilesFromDownload(
          itemId: itemId,
          userId: userId,
          episodeId: episodeId,
          download: mergedDownload,
        );
      }
      _storedDownloadCache.remove('$userId\u0000$itemId\u0000${episodeId ?? ''}');
    });
  }

  Future<void> _addOrUpdateStoredDownloadFileFallback({
    required String itemId,
    required String userId,
    required String? episodeId,
    required InternalDownload download,
    required String downloadOrigin,
    required List<String> smartProfileIds,
    required int? managedBytes,
    required int? completedAt,
  }) async {
    await addOrUpdateStoredDownload(
      StoredDownloadsCompanion(
        itemId: Value(itemId),
        userId: Value(userId),
        episodeId: Value(episodeId),
        download: Value(jsonEncode(download.toJson())),
        downloadOrigin: Value(downloadOrigin),
        smartProfileIds: Value(jsonEncode(smartProfileIds)),
        managedBytes: Value(managedBytes),
        completedAt: Value(completedAt),
      ),
    );
    _storedDownloadCache.remove('$userId\u0000$itemId\u0000${episodeId ?? ''}');
  }

  Future<void> addOrUpdateStoredDownloadFile({
    required String itemId,
    required String userId,
    required String? episodeId,
    required String fileKey,
    required InternalDownload download,
    required String downloadOrigin,
    required List<String> smartProfileIds,
    required int? managedBytes,
    required int? completedAt,
  }) async {
    if (_storedDownloadFilesAvailable == false) {
      await _addOrUpdateStoredDownloadFileFallback(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        download: download,
        downloadOrigin: downloadOrigin,
        smartProfileIds: smartProfileIds,
        managedBytes: managedBytes,
        completedAt: completedAt,
      );
      return;
    }

    try {
      await _addOrUpdateStoredDownloadFileNormalized(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        fileKey: fileKey,
        download: download,
        downloadOrigin: downloadOrigin,
        smartProfileIds: smartProfileIds,
        managedBytes: managedBytes,
        completedAt: completedAt,
      );
      _storedDownloadFilesAvailable = true;
    } catch (e) {
      if (!_isStoredDownloadFilesUnavailable(e)) {
        rethrow;
      }
      _storedDownloadFilesAvailable = false;
      logger(
        'Stored download file table is unavailable. Falling back to legacy download storage: $e',
        tag: 'AppDatabase',
        level: InfoLevel.warning,
      );
      await _addOrUpdateStoredDownloadFileFallback(
        itemId: itemId,
        userId: userId,
        episodeId: episodeId,
        download: download,
        downloadOrigin: downloadOrigin,
        smartProfileIds: smartProfileIds,
        managedBytes: managedBytes,
        completedAt: completedAt,
      );
    }
  }

  Future<void> addOrUpdateStoredDownload(StoredDownloadsCompanion companion) {
    return transaction(() async {
      final requestedEpisodeId = companion.episodeId.present ? companion.episodeId.value : null;
      final requestedWhereClause = _storedDownloadWhereExpression(
        itemId: companion.itemId.value,
        userId: companion.userId.value,
        episodeId: requestedEpisodeId,
      );

      final existingRows = await (select(storedDownloads)..where((tbl) => requestedWhereClause)).get();

      if (existingRows.isEmpty) {
        StoredDownloadsEntry? legacyExisting;
        if (requestedEpisodeId == null) {
          final legacyRows =
              await (select(storedDownloads)
                    ..where(
                      (tbl) => tbl.itemId.equals(companion.itemId.value) & tbl.userId.equals(companion.userId.value),
                    )
                    ..limit(1))
                  .get();
          if (legacyRows.isNotEmpty) {
            legacyExisting = legacyRows.first;
          }
        }

        if (legacyExisting == null) {
          await into(storedDownloads).insert(companion);
          return;
        }

        final newDownload = _decodeDownloadJsonOrNull(
          companion.download.value,
          itemId: companion.itemId.value,
          userId: companion.userId.value,
          episodeId: requestedEpisodeId,
        );
        if (newDownload == null) return;

        final oldDownload = _decodeDownloadJsonOrNull(
          legacyExisting.download,
          itemId: legacyExisting.itemId,
          userId: legacyExisting.userId,
          episodeId: legacyExisting.episodeId,
        );
        final updatedDownload = _mergeDownloads(oldDownload, newDownload);

        final legacyWhereClause = _storedDownloadWhereExpression(
          itemId: legacyExisting.itemId,
          userId: legacyExisting.userId,
          episodeId: legacyExisting.episodeId,
        );
        await (update(storedDownloads)..where((tbl) => legacyWhereClause)).write(
          StoredDownloadsCompanion(
            download: Value(jsonEncode(updatedDownload.toJson())),
            downloadOrigin: Value(
              _mergeDownloadOrigin(
                legacyExisting.downloadOrigin,
                companion.downloadOrigin.present ? companion.downloadOrigin.value : 'manual',
              ),
            ),
            smartProfileIds: Value(
              _mergeSmartProfileIds(
                legacyExisting.smartProfileIds,
                companion.smartProfileIds.present ? companion.smartProfileIds.value : '[]',
              ),
            ),
            managedBytes: companion.managedBytes.present ? companion.managedBytes : Value(legacyExisting.managedBytes),
            completedAt: companion.completedAt.present ? companion.completedAt : Value(legacyExisting.completedAt),
          ),
        );
        return;
      }

      final existing = existingRows.first;
      final newDownload = _decodeDownloadJsonOrNull(
        companion.download.value,
        itemId: companion.itemId.value,
        userId: companion.userId.value,
        episodeId: requestedEpisodeId,
      );
      if (newDownload == null) return;

      var oldDownload = _decodeDownloadJsonOrNull(
        existing.download,
        itemId: existing.itemId,
        userId: existing.userId,
        episodeId: existing.episodeId,
      );
      var mergedDownload = _mergeDownloads(oldDownload, newDownload);

      if (existingRows.length > 1) {
        var mergedOrigin = _mergeDownloadOrigin(
          existing.downloadOrigin,
          companion.downloadOrigin.present ? companion.downloadOrigin.value : 'manual',
        );
        var mergedProfileIds = _mergeSmartProfileIds(
          existing.smartProfileIds,
          companion.smartProfileIds.present ? companion.smartProfileIds.value : '[]',
        );
        for (var i = 1; i < existingRows.length; i++) {
          final duplicate = existingRows[i];
          mergedOrigin = _mergeDownloadOrigin(mergedOrigin, duplicate.downloadOrigin);
          mergedProfileIds = _mergeSmartProfileIds(mergedProfileIds, duplicate.smartProfileIds);
          final duplicateDownload = _decodeDownloadJsonOrNull(
            duplicate.download,
            itemId: duplicate.itemId,
            userId: duplicate.userId,
            episodeId: duplicate.episodeId,
          );
          if (duplicateDownload != null) {
            mergedDownload = _mergeDownloads(mergedDownload, duplicateDownload);
          }
        }

        await (delete(storedDownloads)..where((tbl) => requestedWhereClause)).go();
        await into(storedDownloads).insert(
          StoredDownloadsCompanion(
            itemId: Value(companion.itemId.value),
            userId: Value(companion.userId.value),
            episodeId: Value(requestedEpisodeId),
            download: Value(jsonEncode(mergedDownload.toJson())),
            downloadOrigin: Value(mergedOrigin),
            smartProfileIds: Value(mergedProfileIds),
            managedBytes: companion.managedBytes,
            completedAt: companion.completedAt,
          ),
        );
      } else {
        await (update(storedDownloads)..where((tbl) => requestedWhereClause)).write(
          StoredDownloadsCompanion(
            download: Value(jsonEncode(mergedDownload.toJson())),
            downloadOrigin: Value(
              _mergeDownloadOrigin(
                existing.downloadOrigin,
                companion.downloadOrigin.present ? companion.downloadOrigin.value : 'manual',
              ),
            ),
            smartProfileIds: Value(
              _mergeSmartProfileIds(
                existing.smartProfileIds,
                companion.smartProfileIds.present ? companion.smartProfileIds.value : '[]',
              ),
            ),
            managedBytes: companion.managedBytes.present ? companion.managedBytes : Value(existing.managedBytes),
            completedAt: companion.completedAt.present ? companion.completedAt : Value(existing.completedAt),
          ),
        );
      }
    });
  }

  Future<void> deleteStoredDownload(String itemId, String userId, {String? episodeId}) async {
    final whereClause = _storedDownloadWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId);
    final fileWhereClause = _storedDownloadFileWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId);
    await transaction(() async {
      await (delete(storedDownloads)..where((tbl) => whereClause)).go();
      try {
        await (delete(storedDownloadFiles)..where((tbl) => fileWhereClause)).go();
      } catch (e) {
        if (!_isStoredDownloadFilesUnavailable(e)) {
          rethrow;
        }
      }
    });
    _storedDownloadCache.remove('$userId\u0000$itemId\u0000${episodeId ?? ''}');
  }

  Future<void> updateStoredDownloadSmartProfileIds(
    String itemId,
    String userId, {
    String? episodeId,
    required List<String> smartProfileIds,
  }) async {
    final whereClause = _storedDownloadWhereExpression(itemId: itemId, userId: userId, episodeId: episodeId);
    await (update(storedDownloads)..where((tbl) => whereClause)).write(
      StoredDownloadsCompanion(smartProfileIds: Value(jsonEncode(smartProfileIds))),
    );
  }

  Future<List<SmartDownloadProfileEntry>> getSmartDownloadProfiles(String userId) {
    return (select(smartDownloadProfiles)..where((tbl) => tbl.userId.equals(userId))).get();
  }

  Future<List<SmartDownloadSourceEntry>> getSmartDownloadSources(String profileId) {
    return (select(smartDownloadSources)..where((tbl) => tbl.profileId.equals(profileId))).get();
  }

  Future<List<SmartDownloadClaimEntry>> getSmartDownloadClaims(String profileId) {
    return (select(smartDownloadClaims)..where((tbl) => tbl.profileId.equals(profileId))).get();
  }

  Future<void> upsertSmartDownloadProfile(SmartDownloadProfile profile) async {
    await into(smartDownloadProfiles).insert(
      SmartDownloadProfilesCompanion(
        id: Value(profile.id),
        userId: Value(profile.userId),
        name: Value(profile.name),
        policy: Value(jsonEncode(profile.policy.toJson())),
        enabled: Value(profile.enabled),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> replaceSmartDownloadSources(String profileId, List<MediaSourceDescriptor> sources) async {
    await transaction(() async {
      await (delete(smartDownloadSources)..where((tbl) => tbl.profileId.equals(profileId))).go();
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final source in sources) {
        await into(smartDownloadSources).insert(
          SmartDownloadSourcesCompanion(
            profileId: Value(profileId),
            sourceType: Value(source.type.name),
            sourceId: Value(source.sourceId),
            libraryId: Value(source.libraryId),
            displayName: Value(source.displayName),
            descending: Value(source.descending),
            sourceRevision: Value(source.revision),
            updatedAt: Value(now),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> updateSmartDownloadSourceSnapshot(
    String profileId,
    MediaSourceDescriptor source, {
    int? revision,
    String? candidateSnapshot,
  }) async {
    await (update(smartDownloadSources)..where(
          (tbl) =>
              tbl.profileId.equals(profileId) &
              tbl.sourceType.equals(source.type.name) &
              tbl.sourceId.equals(source.sourceId),
        ))
        .write(
          SmartDownloadSourcesCompanion(
            sourceRevision: Value(revision),
            candidateSnapshot: Value(candidateSnapshot),
            updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
          ),
        );
  }

  Future<void> upsertSmartDownloadClaim(SmartDownloadClaim claim) {
    return into(smartDownloadClaims).insert(
      SmartDownloadClaimsCompanion(
        profileId: Value(claim.profileId),
        referenceKey: Value('${claim.ref.itemId}::${claim.ref.episodeId ?? ''}'),
        itemId: Value(claim.ref.itemId),
        episodeId: Value(claim.ref.episodeId),
        sourceType: Value(claim.source.type.name),
        sourceId: Value(claim.source.sourceId),
        state: Value(claim.state),
        estimatedBytes: Value(claim.estimatedBytes),
        completedAt: Value(claim.completedAt),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> deleteSmartDownloadProfile(String profileId, String userId) async {
    await transaction(() async {
      await (delete(smartDownloadClaims)..where((tbl) => tbl.profileId.equals(profileId))).go();
      await (delete(smartDownloadSources)..where((tbl) => tbl.profileId.equals(profileId))).go();
      await (delete(smartDownloadProfiles)..where((tbl) => tbl.id.equals(profileId) & tbl.userId.equals(userId))).go();
    });
  }

  Future<void> updateStoredDownloadItemSnapshot({
    required String itemId,
    required String userId,
    required LibraryItem item,
  }) async {
    final entries = await (select(
      storedDownloads,
    )..where((tbl) => tbl.itemId.equals(itemId) & tbl.userId.equals(userId))).get();

    if (entries.isEmpty) {
      return;
    }

    for (final entry in entries) {
      final parsedDownload = _decodeDownloadJsonOrNull(
        entry.download,
        itemId: entry.itemId,
        userId: entry.userId,
        episodeId: entry.episodeId,
      );
      if (parsedDownload == null) {
        continue;
      }

      final updatedDownload = parsedDownload.copyWith(item: item);
      final whereClause = _storedDownloadWhereExpression(
        itemId: entry.itemId,
        userId: entry.userId,
        episodeId: entry.episodeId,
      );

      await (update(storedDownloads)..where((tbl) => whereClause)).write(
        StoredDownloadsCompanion(
          download: Value(
            _isNormalizedStoredDownload(entry.download)
                ? _encodeNormalizedStoredDownload(updatedDownload, includeInlineFiles: true)
                : jsonEncode(updatedDownload.toJson()),
          ),
        ),
      );
      _storedDownloadBaseCache.remove(entry.download);
      _storedDownloadCache.remove(_storedDownloadCacheKey(entry));
    }
  }

  String _storedMediaProgressId({required String userId, required String itemId, required String? episodeId}) {
    final normalizedEpisodeId = episodeId?.trim() ?? '';
    return '$userId::$itemId::$normalizedEpisodeId';
  }

  Expression<bool> _storedMediaProgressWhereExpression({
    required String userId,
    required String itemId,
    required String? episodeId,
  }) {
    var whereClause = storedMediaProgress.userId.equals(userId) & storedMediaProgress.itemId.equals(itemId);
    if (episodeId != null) {
      whereClause = whereClause & storedMediaProgress.episodeId.equals(episodeId);
    } else {
      whereClause = whereClause & storedMediaProgress.episodeId.isNull();
    }
    return whereClause;
  }

  Future<void> addOrUpdateStoredMediaProgress({
    required String userId,
    required String itemId,
    required String? episodeId,
    required DateTime lastUpdated,
    required String mediaProgress,
  }) {
    final companion = StoredMediaProgressCompanion(
      progressId: Value(_storedMediaProgressId(userId: userId, itemId: itemId, episodeId: episodeId)),
      userId: Value(userId),
      itemId: Value(itemId),
      episodeId: Value(episodeId),
      lastUpdated: Value(lastUpdated),
      mediaProgress: Value(mediaProgress),
    );

    return into(storedMediaProgress).insert(
      companion,
      onConflict: DoUpdate(
        (old) => StoredMediaProgressCompanion(
          userId: Value(userId),
          itemId: Value(itemId),
          episodeId: Value(episodeId),
          lastUpdated: Value(lastUpdated),
          mediaProgress: Value(mediaProgress),
        ),
        target: [storedMediaProgress.progressId],
        where: (old) => old.lastUpdated.isSmallerThanValue(lastUpdated),
      ),
    );
  }

  Future<void> deleteStoredMediaProgress(String userId, String itemId, {String? episodeId}) {
    final query = delete(storedMediaProgress)
      ..where((tbl) => _storedMediaProgressWhereExpression(userId: userId, itemId: itemId, episodeId: episodeId));
    return query.go();
  }

  Future<void> deleteStoredMediaProgressByUser(String userId) {
    final query = delete(storedMediaProgress)..where((tbl) => tbl.userId.equals(userId));
    return query.go();
  }

  Future<List<StoredMediaProgressEntry>> getStoredMediaProgressByUser(String userId) async {
    return await (select(storedMediaProgress)..where((tbl) => tbl.userId.equals(userId))).get();
  }

  Expression<bool> _storedBookmarkSyncWhereExpression({
    required String userId,
    required String itemId,
    required int time,
  }) {
    return storedBookmarkSyncs.userId.equals(userId) &
        storedBookmarkSyncs.itemId.equals(itemId) &
        storedBookmarkSyncs.time.equals(time);
  }

  Future<void> upsertStoredBookmarkSync({
    required String userId,
    required String itemId,
    required int time,
    required String? title,
    required bool deleted,
    required DateTime updatedAt,
  }) {
    final companion = StoredBookmarkSyncsCompanion(
      userId: Value(userId),
      itemId: Value(itemId),
      time: Value(time),
      title: Value(title),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
    );

    return into(storedBookmarkSyncs).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteStoredBookmarkSync(String userId, String itemId, int time) {
    final query = delete(storedBookmarkSyncs)
      ..where((tbl) => _storedBookmarkSyncWhereExpression(userId: userId, itemId: itemId, time: time));
    return query.go();
  }

  Future<void> deleteStoredBookmarkSyncByUser(String userId) {
    final query = delete(storedBookmarkSyncs)..where((tbl) => tbl.userId.equals(userId));
    return query.go();
  }

  Future<List<StoredBookmarkSyncEntry>> getStoredBookmarkSyncByUser(String userId) async {
    return await (select(storedBookmarkSyncs)..where((tbl) => tbl.userId.equals(userId))).get();
  }

  Future<List<StoredBookmarkSyncEntry>> getAllStoredBookmarkSyncs() async {
    return await select(storedBookmarkSyncs).get();
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

  Future<List<StoredSyncEntry>> getAllSyncsByUser(String userId) async {
    return await (select(storedSyncs)..where((tbl) => tbl.userId.equals(userId))).get();
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

  Future<void> setBookPlaybackSpeed(String userId, String itemId, double speed) {
    final companion = BookPlaybackSpeedsCompanion(
      userId: Value(userId),
      itemId: Value(itemId),
      speed: Value(speed),
      updatedAt: Value(DateTime.now()),
    );
    return into(bookPlaybackSpeeds).insert(companion, mode: InsertMode.replace);
  }

  Future<double?> getBookPlaybackSpeed(String userId, String itemId) async {
    final entry = await (select(
      bookPlaybackSpeeds,
    )..where((tbl) => tbl.userId.equals(userId) & tbl.itemId.equals(itemId))).getSingleOrNull();
    return entry?.speed;
  }

  Future<void> deleteBookPlaybackSpeedsByUser(String userId) {
    return (delete(bookPlaybackSpeeds)..where((tbl) => tbl.userId.equals(userId))).go();
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
        } on AuthSecretsUnavailableException catch (e, s) {
          logger(
            'Auth secrets are temporarily unavailable for stored user ${row.id}: $e\n$s',
            tag: 'AppDatabase',
            level: InfoLevel.warning,
          );
          userList.add(User.fromJson(jsonDecode(row.userDataJson)));
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
      } on AuthSecretsUnavailableException catch (e, s) {
        logger(
          'Auth secrets are temporarily unavailable for stored user ${row.id}: $e\n$s',
          tag: 'AppDatabase',
          level: InfoLevel.warning,
        );
        users.add(User.fromJson(jsonDecode(row.userDataJson)));
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
    await _authSecretStore.deleteForUser(userId);
    await deleteStoredMediaProgressByUser(userId);
    await deleteStoredBookmarkSyncByUser(userId);
    await deleteBookPlaybackSpeedsByUser(userId);
    await (delete(storedUsers)..where((tbl) => tbl.id.equals(userId))).go();
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

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final authSecretStore = ref.watch(authSecretStoreProvider);
  return AppDatabase(authSecretStore: authSecretStore);
}
