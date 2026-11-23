import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.connect(DatabaseConnection(NativeDatabase.memory()));
  });

  tearDown(() async {
    await db.close();
  });

  test('migrates every enabled user into a separate profile with both All-library sources', () async {
    await db.setUserSetting('first', 'download_continue_shelf', 'true');
    await db.setUserSetting('second', 'download_continue_shelf', 'true');
    await db.setUserSetting('second', 'download_type_preference', 'ebook');
    await db.setUserSetting('disabled', 'download_continue_shelf', 'false');

    await db.migrateLegacySmartDownloadOptions();

    for (final userId in ['first', 'second']) {
      final profiles = await db.getSmartDownloadProfiles(userId);
      expect(profiles, hasLength(1));
      final profile = profiles.single;
      expect(profile.id, migratedContinueDownloadProfileId(userId));
      expect(profile.enabled, isTrue);
      final sources = await db.getSmartDownloadSources(profile.id);
      expect(sources.map((source) => source.sourceType).toSet(), {'continueListening', 'continueSeries'});
      expect(sources.every((source) => source.libraryId == allLibrariesSourceId), isTrue);
      expect((await db.getUserSetting(userId, 'download_continue_shelf'))!.value, 'false');
    }

    final second = (await db.getSmartDownloadProfiles('second')).single;
    expect(SmartDownloadPolicy.fromJson(jsonDecode(second.policy)).downloadType, 'ebook');
    expect(await db.getSmartDownloadProfiles('disabled'), isEmpty);
  });

  test('migration is idempotent and preserves ownership shared with other rules', () async {
    await db.setUserSetting('user', 'download_continue_shelf', 'true');
    await db
        .into(db.storedDownloads)
        .insert(
          StoredDownloadsCompanion.insert(
            itemId: 'book',
            userId: 'user',
            download: '{}',
            downloadOrigin: const Value('smart'),
            smartProfileIds: const Value('["__continue_shelf__","other-rule"]'),
          ),
        );

    await db.migrateLegacySmartDownloadOptions();
    await db.migrateLegacySmartDownloadOptions();

    expect(await db.getSmartDownloadProfiles('user'), hasLength(1));
    final profileId = migratedContinueDownloadProfileId('user');
    expect(await db.getSmartDownloadSources(profileId), hasLength(2));
    final download = (await db.getStoredDownloadEntriesByUser('user')).single;
    expect((jsonDecode(download.smartProfileIds) as List).toSet(), {profileId, 'other-rule'});
    expect(normalizeSmartDownloadProfileId('__continue_shelf__', 'user'), profileId);
  });

  test('existing listening thresholds become scoped sources without losing rule limits', () async {
    final profile = SmartDownloadProfile(
      id: 'listening',
      userId: 'user',
      name: 'Download after listening',
      policy: const SmartDownloadPolicy(maxStorageBytes: 123456, deleteAfterHours: 8),
    );
    await db.upsertSmartDownloadProfile(profile);
    final legacyPolicy = {...profile.policy.toJson(), 'listeningTrigger': 'progress', 'listeningThreshold': 17};
    await db.customStatement('UPDATE smart_download_profiles SET policy = ? WHERE id = ?', [
      jsonEncode(legacyPolicy),
      profile.id,
    ]);

    await db.migrateLegacySmartDownloadOptions();

    final stored = (await db.getSmartDownloadProfiles('user')).single;
    final policy = SmartDownloadPolicy.fromJson(jsonDecode(stored.policy));
    expect(policy.maxStorageBytes, 123456);
    expect(policy.deleteAfterHours, 8);
    expect((jsonDecode(stored.policy) as Map).containsKey('listeningTrigger'), isFalse);
    final source = (await db.getSmartDownloadSources(profile.id)).single;
    expect(source.sourceType, 'listeningThreshold');
    expect(source.libraryId, allLibrariesSourceId);
    expect(source.listeningTrigger, 'progress');
    expect(source.listeningThreshold, 17);
  });

  test('editing one migrated user sources cannot change another user sources', () async {
    for (final userId in ['first', 'second']) {
      await db.setUserSetting(userId, 'download_continue_shelf', 'true');
    }
    await db.migrateLegacySmartDownloadOptions();

    await db.replaceSmartDownloadSources(migratedContinueDownloadProfileId('first'), []);

    expect(await db.getSmartDownloadSources(migratedContinueDownloadProfileId('first')), isEmpty);
    expect(await db.getSmartDownloadSources(migratedContinueDownloadProfileId('second')), hasLength(2));
  });

  for (final version in [24, 25, 26]) {
    test('opening a version $version database runs the migration automatically', () async {
      await db.close();
      db = AppDatabase.connect(
        DatabaseConnection(
          NativeDatabase.memory(
            setup: (database) {
              database.execute('''
        CREATE TABLE user_settings (user_id TEXT NOT NULL, key TEXT NOT NULL, value TEXT NOT NULL, PRIMARY KEY(user_id, key));
        CREATE TABLE smart_download_profiles (
          id TEXT NOT NULL, user_id TEXT NOT NULL, name TEXT NOT NULL, policy TEXT NOT NULL,
          enabled INTEGER NOT NULL, updated_at INTEGER NOT NULL, PRIMARY KEY(id, user_id)
        );
        CREATE TABLE smart_download_sources (
          profile_id TEXT NOT NULL, source_type TEXT NOT NULL, source_id TEXT NOT NULL,
          library_id TEXT NOT NULL, display_name TEXT, descending INTEGER NOT NULL DEFAULT 0,
          source_revision INTEGER, candidate_snapshot TEXT, updated_at INTEGER NOT NULL,
          PRIMARY KEY(profile_id, source_type, source_id)
        );
        CREATE TABLE stored_downloads (
          item_id TEXT NOT NULL, user_id TEXT NOT NULL, episode_id TEXT, download TEXT NOT NULL,
          download_origin TEXT NOT NULL DEFAULT 'manual', smart_profile_ids TEXT NOT NULL DEFAULT '[]',
          managed_bytes INTEGER, completed_at INTEGER, PRIMARY KEY(item_id, user_id, episode_id)
        );
        INSERT INTO user_settings VALUES ('existing-user', 'download_continue_shelf', 'true');
        PRAGMA user_version = $version;
      ''');
              if (version == 25) {
                database.execute('''
                CREATE TABLE listening_download_progress (
                  user_id TEXT NOT NULL, item_id TEXT NOT NULL, library_id TEXT NOT NULL,
                  listened_seconds REAL NOT NULL, progress_percent REAL NOT NULL,
                  completed_chapters INTEGER NOT NULL, PRIMARY KEY(user_id, item_id)
                );
                INSERT INTO listening_download_progress VALUES ('existing-user', 'book', 'library', 42, 17, 3);
              ''');
              }
            },
          ),
        ),
      );

      final profiles = await db.getSmartDownloadProfiles('existing-user');

      expect(profiles, hasLength(1));
      expect(await db.getSmartDownloadSources(profiles.single.id), hasLength(2));
      expect((await db.customSelect('PRAGMA user_version').getSingle()).data.values.single, 27);
      if (version == 25) {
        final progress = (await db.getListeningDownloadProgress('existing-user')).single;
        expect(progress.listenedSeconds, 42);
        expect(progress.progressPercent, 17);
      }
    });
  }
}
