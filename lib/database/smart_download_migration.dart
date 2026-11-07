part of 'app_database.dart';

extension SmartDownloadMigration on AppDatabase {
  Future<void> migrateLegacySmartDownloadOptions() async {
    await transaction(() async {
      final enabledSettings = await (select(
        userSettings,
      )..where((row) => row.key.equals('download_continue_shelf'))).get();

      for (final setting in enabledSettings) {
        if (setting.value.trim().toLowerCase() != 'true') {
          continue;
        }

        await _migrateContinueDownloads(setting.userId);
        await setUserSetting(setting.userId, 'download_continue_shelf', 'false');
      }

      final profiles = await select(smartDownloadProfiles).get();
      for (final profile in profiles) {
        await _migrateListeningDownloadRule(profile);
      }
    });
  }

  Future<void> _migrateContinueDownloads(String userId) async {
    final profileId = migratedContinueDownloadProfileId(userId);
    final existing = await (select(
      smartDownloadProfiles,
    )..where((row) => row.id.equals(profileId) & row.userId.equals(userId))).getSingleOrNull();

    if (existing == null) {
      final preferredType = await getUserSetting(userId, 'download_type_preference');
      final downloadType = switch (preferredType?.value) {
        'audiobook' => 'audiobook',
        'ebook' => 'ebook',
        _ => 'both',
      };
      final profile = SmartDownloadProfile(
        id: profileId,
        userId: userId,
        name: 'Continue downloads',
        policy: SmartDownloadPolicy(targetCount: 150, downloadType: downloadType),
      );

      await upsertSmartDownloadProfile(profile);
      await replaceSmartDownloadSources(profileId, const [
        MediaSourceDescriptor(
          type: MediaSourceType.continueListening,
          sourceId: allLibrariesSourceId,
          libraryId: allLibrariesSourceId,
          displayName: 'Continue Listening (All)',
        ),
        MediaSourceDescriptor(
          type: MediaSourceType.continueSeries,
          sourceId: allLibrariesSourceId,
          libraryId: allLibrariesSourceId,
          displayName: 'Continue Series (All)',
        ),
      ]);
    }

    final downloads = await getStoredDownloadEntriesByUser(userId);
    for (final download in downloads) {
      final previousIds = _decodeSmartProfileIds(download.smartProfileIds);
      if (!previousIds.contains(legacyContinueDownloadProfileId)) {
        continue;
      }

      final profileIds = previousIds.map((id) => normalizeSmartDownloadProfileId(id, userId)).toSet().toList();
      profileIds.sort();

      await updateStoredDownloadSmartProfileIds(
        download.itemId,
        userId,
        episodeId: download.episodeId,
        smartProfileIds: profileIds,
      );
    }
  }

  Future<void> _migrateListeningDownloadRule(SmartDownloadProfileEntry profile) async {
    Map<String, dynamic> decoded;
    SmartDownloadPolicy policy;

    try {
      decoded = Map<String, dynamic>.from(jsonDecode(profile.policy) as Map);
      if (decoded['listeningTrigger'] == null) {
        return;
      }

      final migratedPolicy = Map<String, dynamic>.from(decoded);
      migratedPolicy['listeningTrigger'] = null;
      policy = SmartDownloadPolicy.fromJson(migratedPolicy).copyWith(targetCount: 150);
    } catch (_) {
      return;
    }

    final removedChapterTrigger = decoded['listeningTrigger'] == 'chapters';
    final trigger = decoded['listeningTrigger'] == 'progress'
        ? ListeningDownloadTrigger.progress
        : ListeningDownloadTrigger.minutes;
    final previousThreshold = jsonIntFromDynamic(decoded['listeningThreshold']) ?? 30;
    final maximumThreshold = trigger == ListeningDownloadTrigger.progress ? 99 : 10000;
    final threshold = removedChapterTrigger ? 30 : previousThreshold.clamp(1, maximumThreshold);
    final unit = trigger == ListeningDownloadTrigger.progress ? '%' : ' min';
    final source = MediaSourceDescriptor(
      type: MediaSourceType.listeningThreshold,
      sourceId: '$allLibrariesSourceId::${trigger.name}',
      libraryId: allLibrariesSourceId,
      displayName: 'Download after listening (All) · $threshold$unit',
      listeningTrigger: trigger,
      listeningThreshold: threshold,
    );

    final sources = await getSmartDownloadSources(profile.id);
    if (!sources.any((entry) => entry.sourceType == MediaSourceType.listeningThreshold.name)) {
      final now = DateTime.now().millisecondsSinceEpoch;
      await into(smartDownloadSources).insert(
        SmartDownloadSourcesCompanion.insert(
          profileId: profile.id,
          sourceType: source.type.name,
          sourceId: source.sourceId,
          libraryId: source.libraryId,
          displayName: Value(source.displayName),
          listeningTrigger: Value(source.listeningTrigger.name),
          listeningThreshold: Value(source.listeningThreshold),
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }

    await (update(
      smartDownloadProfiles,
    )..where((row) => row.id.equals(profile.id) & row.userId.equals(profile.userId))).write(
      SmartDownloadProfilesCompanion(
        policy: Value(jsonEncode(policy.toJson())),
        enabled: Value(profile.enabled && !removedChapterTrigger),
      ),
    );
  }
}
