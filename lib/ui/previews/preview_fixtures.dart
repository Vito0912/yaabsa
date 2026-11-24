import 'package:yaabsa/api/library_items/book_media.dart';
import 'package:yaabsa/api/library_items/media_metadata.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/api/library/stats/items_listened_to.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/api/library/stats/year_in_review_stats.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/library_items/metadata.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/media.dart';
import 'package:yaabsa/api/library_items/podcast_metadata.dart';
import 'package:yaabsa/api/library_items/podcast_media.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/features/upload/item_upload_destination.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/me/permissions.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/models/internal_media.dart';

final previewReferenceDate = DateTime(2026, 6, 30);

LibraryItem previewPodcastLibraryItem() {
  return const LibraryItem(
    id: 'preview-podcast',
    ino: 'preview-podcast',
    mediaType: 'podcast',
    media: Media(
      podcastMedia: PodcastMedia(
        id: 'preview-podcast',
        metadata: PodcastMetadata(title: 'Äffchen mit Käffchen', author: 'Paluten, Denno & Malte'),
      ),
    ),
    libraryFiles: null,
  );
}

List<Episode> previewPodcastEpisodes() {
  return const [
    Episode(
      libraryItemId: 'preview-podcast',
      id: 'preview-episode-in-progress',
      index: 18,
      title: 'A lighthouse in the fog',
      subtitle: 'The harbor lights go dark',
      description:
          'Mara and Jonas return to the coast after a storm uncovers a forgotten signal beneath the old lighthouse.',
      pubDate: '2026-06-22T10:00:00.000Z',
      duration: 2480,
    ),
    Episode(
      libraryItemId: 'preview-podcast',
      id: 'preview-episode-unfinished',
      index: 17,
      title: 'The mapmaker’s promise',
      subtitle: 'A letter from the northern shore',
      description: 'An unexpected parcel sends the crew searching for a village that no longer appears on any map.',
      pubDate: '2026-06-15T10:00:00.000Z',
      duration: 3120,
    ),
    Episode(
      libraryItemId: 'preview-podcast',
      id: 'preview-episode-complete',
      index: 16,
      title: 'The last ferry home',
      subtitle: 'A story told after midnight',
      pubDate: '2026-06-08T10:00:00.000Z',
      duration: 1960,
    ),
  ];
}

MediaProgress previewPodcastEpisodeProgress({
  required String episodeId,
  required double progress,
  bool isFinished = false,
}) {
  final duration = 2480.0;
  final currentTime = duration * progress;

  return MediaProgress(
    id: 'preview-progress-$episodeId',
    userId: 'preview-user',
    libraryItemId: 'preview-podcast',
    episodeId: episodeId,
    mediaItemId: episodeId,
    mediaItemType: MediaItemType.PODCAST_EPISODE,
    duration: duration,
    progress: progress,
    currentTime: currentTime,
    isFinished: isFinished,
    lastUpdate: 1,
    startedAt: 1,
    finishedAt: isFinished ? 2 : null,
  );
}

Library previewUploadLibrary() {
  return const Library(
    id: 'preview-library',
    name: 'Audiobooks',
    displayOrder: 0,
    icon: 'books',
    mediaType: 'book',
    provider: 'Audible.com',
    createdAt: 1,
    settings: LibrarySettings(),
    folders: [LibraryFolder(id: 'preview-folder', fullPath: '/audiobooks', libraryId: 'preview-library')],
  );
}

User previewAdminUser() {
  return User(
    id: 'preview-admin',
    username: 'Preview Admin',
    email: null,
    type: 'root',
    token: null,
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

List<AdminUser> previewAdminUsers() {
  return const [
    AdminUser(
      id: 'preview-root',
      username: 'Avery Northstar',
      email: 'avery@example.test',
      type: 'root',
      isActive: true,
      hasOpenIdLink: true,
    ),
    AdminUser(
      id: 'preview-reader',
      username: 'Morgan Reader',
      email: 'morgan@example.test',
      type: 'user',
      isActive: true,
    ),
    AdminUser(
      id: 'preview-disabled',
      username: 'Disabled Account',
      email: 'disabled@example.test',
      type: 'user',
      isActive: false,
    ),
  ];
}

UploadItemDraft previewUploadItemDraft() {
  return const UploadItemDraft(
    id: 42,
    title: 'The Distant Shore',
    author: 'Mira Ellery',
    series: 'The Tidemark Stories',
    itemFiles: [
      UploadPickedFile(
        absolutePath: '/preview/The Distant Shore/01 - The Distant Shore.m4b',
        relativePath: '01 - The Distant Shore.m4b',
        fileName: '01 - The Distant Shore.m4b',
        kind: UploadFileKind.item,
      ),
    ],
    otherFiles: [
      UploadPickedFile(
        absolutePath: '/preview/The Distant Shore/cover.jpg',
        relativePath: 'cover.jpg',
        fileName: 'cover.jpg',
        kind: UploadFileKind.other,
      ),
    ],
    ignoredFiles: [],
    status: UploadItemStatus.warning,
    progress: 0,
    uploadSpeedBytesPerSecond: 0,
    uploadedBytes: 0,
    totalBytes: 246000000,
    sourceDescription: 'Preview folder',
    pendingMetadata: UploadMetadataSuggestion(
      title: 'The Distant Shore',
      author: 'Mira Ellery',
      series: 'The Tidemark Stories',
    ),
  );
}

InternalMedia previewInternalMedia() {
  return InternalMedia(
    libraryId: 'preview-library',
    itemId: 'preview-book',
    episodeId: null,
    sessionId: 'preview-session',
    title: 'The Distant Shore',
    subtitle: 'The Tidemark Stories',
    author: 'Mira Ellery',
    narrator: 'Elena Mar',
    series: 'The Tidemark Stories',
    seriesPosition: '2',
    tracks: const [],
    duration: const Duration(hours: 3, minutes: 42).inSeconds.toDouble(),
    local: false,
    saf: false,
  );
}

UserListeningStats previewUserListeningStats() {
  final days = <String, double>{};
  for (var offset = 0; offset < 14; offset++) {
    final date = previewReferenceDate.subtract(Duration(days: offset));
    days['${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'] =
        offset % 4 == 0 ? 0 : (offset + 1) * 1800;
  }

  return UserListeningStats(
    totalTime: 455000,
    today: 3240,
    days: days,
    items: const {
      'book-1': ItemsListenedTo(id: 'book-1', timeListening: 184000),
      'book-2': ItemsListenedTo(id: 'book-2', timeListening: 156000),
      'podcast-1': ItemsListenedTo(
        id: 'podcast-1',
        timeListening: 115000,
        mediaMetadata: Metadata(
          podcastMetadata: PodcastMetadata(title: 'Field Notes', author: 'Field Notes'),
        ),
      ),
    },
  );
}

AdvancedListeningStats previewAdvancedListeningStats() {
  return AdvancedListeningStats(
    loadedPages: 8,
    totalSessions: 82,
    totalAvailableSessions: 82,
    totalListeningTime: 455000,
    totalBookListeningTime: 340000,
    totalPodcastListeningTime: 115000,
    averageSessionTime: 5550,
    medianSessionTime: 4200,
    longestSessionTime: 18400,
    uniqueItems: 24,
    uniqueAuthors: 17,
    longestStreakDays: 12,
    firstSessionAt: DateTime(2026, 1, 8).millisecondsSinceEpoch,
    lastSessionAt: previewReferenceDate.millisecondsSinceEpoch,
    favoriteWeekday: 'Sunday',
    favoriteHour: 20,
    topItems: const [
      AdvancedTopItem(
        id: '',
        title: 'The Distant Shore',
        author: 'Mira Ellery',
        mediaType: 'book',
        totalListeningTime: 72000,
        sessions: 12,
      ),
      AdvancedTopItem(
        id: '',
        title: 'Winter at Low Tide',
        author: 'Jonas Vale',
        mediaType: 'book',
        totalListeningTime: 58900,
        sessions: 9,
      ),
    ],
    topAuthors: const [
      AdvancedTopEntity(name: 'Mira Ellery', totalListeningTime: 99000, sessions: 19),
      AdvancedTopEntity(name: 'Jonas Vale', totalListeningTime: 77300, sessions: 15),
    ],
    weekdayBreakdown: const [
      AdvancedTimeBucket(label: 'Sunday', totalListeningTime: 91200),
      AdvancedTimeBucket(label: 'Wednesday', totalListeningTime: 70400),
      AdvancedTimeBucket(label: 'Saturday', totalListeningTime: 65200),
    ],
    hourlyBreakdown: const [
      AdvancedTimeBucket(label: '20:00', totalListeningTime: 98500),
      AdvancedTimeBucket(label: '21:00', totalListeningTime: 78200),
      AdvancedTimeBucket(label: '07:00', totalListeningTime: 64100),
    ],
    monthlyBreakdown: const [
      AdvancedTimeBucket(label: 'April', totalListeningTime: 71000),
      AdvancedTimeBucket(label: 'May', totalListeningTime: 69400),
      AdvancedTimeBucket(label: 'June', totalListeningTime: 64200),
    ],
  );
}

YearInReviewStats previewYearInReviewStats() {
  return const YearInReviewStats(
    totalListeningSessions: 82,
    totalListeningTime: 455000,
    totalBookListeningTime: 340000,
    totalPodcastListeningTime: 115000,
    topAuthors: [
      YearInReviewNamedStat(name: 'Mira Ellery', time: 99000),
      YearInReviewNamedStat(name: 'Jonas Vale', time: 77300),
    ],
    topGenres: [
      YearInReviewGenreStat(genre: 'Literary fiction', time: 112000),
      YearInReviewGenreStat(genre: 'Mystery', time: 87000),
    ],
    mostListenedMonth: YearInReviewMonthStat(month: 4, time: 71000),
    numBooksFinished: 18,
    numBooksListened: 24,
    topNarrators: [YearInReviewNamedStat(name: 'Elena Mar', time: 88400)],
  );
}

List<PlaybackSession> previewPlaybackSessions() {
  return [
    PlaybackSession(
      id: 'session-1',
      userId: 'preview-user',
      libraryItemId: 'book-1',
      displayTitle: 'The Distant Shore',
      displayAuthor: 'Mira Ellery',
      timeListening: 3600,
      startedAt: DateTime(2026, 6, 30, 20).millisecondsSinceEpoch,
    ),
    PlaybackSession(
      id: 'session-2',
      userId: 'preview-user',
      libraryItemId: 'book-2',
      displayTitle: 'Winter at Low Tide',
      displayAuthor: 'Jonas Vale',
      timeListening: 2700,
      startedAt: DateTime(2026, 6, 29, 19).millisecondsSinceEpoch,
    ),
    PlaybackSession(
      id: 'session-3',
      userId: 'preview-user',
      libraryItemId: 'podcast-1',
      displayTitle: 'Field Notes: The Old Orchard',
      displayAuthor: 'Field Notes',
      timeListening: 1800,
      startedAt: DateTime(2026, 6, 28, 7).millisecondsSinceEpoch,
    ),
  ];
}

ListeningActivityStats previewListeningActivity({int days = 365}) {
  final listeningByDay = <int, double>{};

  for (var offset = 0; offset < days; offset++) {
    final isListeningDay = offset % 5 != 0;
    if (!isListeningDay) {
      continue;
    }

    final day = previewReferenceDate.subtract(Duration(days: offset));
    final minutes = 18 + ((offset * 23) % 132);
    listeningByDay[dayKeyFromDate(day)] = minutes * 60;
  }

  return ListeningActivityStats(dailyListeningSeconds: listeningByDay, loadedPages: 4, loadedSessions: 82);
}

ItemUploadDestination previewItemUploadDestination() {
  const item = LibraryItem(
    id: 'preview-book',
    ino: 'preview-book-ino',
    libraryId: 'preview-library',
    folderId: 'preview-folder',
    path: '/audiobooks/Mira Ellery/The Tidemark Stories/The Distant Shore',
    isFile: false,
    media: null,
    libraryFiles: [],
  );

  return ItemUploadDestination.resolve(item: item, library: previewUploadLibrary(), serverWatcherDisabled: false)!;
}

List<LibraryItem> previewSearchLibraryItems() {
  return List<LibraryItem>.generate(1000, (index) {
    return LibraryItem(
      id: 'preview-search-$index',
      ino: 'preview-search-$index',
      libraryId: 'preview-library',
      mediaType: 'book',
      media: Media(
        bookMedia: BookMedia(
          id: 'preview-search-media-$index',
          metadata: MediaMetadata(
            title: 'The Cartographer’s Promise and the Lighthouse Beyond the Northern Shore $index',
          ),
        ),
      ),
      libraryFiles: null,
    );
  }, growable: false);
}
