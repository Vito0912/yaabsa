import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/book_media.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_file_metadata.dart';
import 'package:yaabsa/api/library_items/media.dart';
import 'package:yaabsa/api/library_items/media_metadata.dart';
import 'package:yaabsa/api/library_items/podcast_media.dart';
import 'package:yaabsa/api/library_items/podcast_metadata.dart';

void main() {
  group('Media.duration', () {
    test('uses aggregate book duration when track durations are unavailable', () {
      final media = Media(
        bookMedia: BookMedia(
          id: 'book-media',
          metadata: MediaMetadata(title: 'Book'),
          duration: 3600,
          audioFiles: const [],
        ),
      );

      expect(media.duration(), 3600);
    });

    test('falls back to individual episode durations when podcast total is absent', () {
      final media = Media(
        podcastMedia: PodcastMedia(
          id: 'podcast-media',
          metadata: const PodcastMetadata(title: 'Podcast'),
          episodes: const [
            Episode(libraryItemId: 'podcast', id: 'episode-1', duration: 120),
            Episode(libraryItemId: 'podcast', id: 'episode-2', duration: 180),
          ],
        ),
      );

      expect(media.duration(), 300);
      expect(media.duration(episodeId: 'episode-1'), 120);
    });

    test('uses episode duration when its audio file has no duration', () {
      final media = Media(
        podcastMedia: PodcastMedia(
          id: 'podcast-media',
          metadata: const PodcastMetadata(title: 'Podcast'),
          episodes: [
            Episode(
              libraryItemId: 'podcast',
              id: 'episode-1',
              duration: 120,
              audioFile: AudioFile(
                ino: 'audio-file',
                metadata: const LibraryFileMetadata(
                  filename: 'episode.mp3',
                  ext: '.mp3',
                  path: '/episode.mp3',
                  relPath: 'episode.mp3',
                  size: 1,
                  mtimeMs: 0,
                  ctimeMs: 0,
                  birthtimeMs: 0,
                ),
                addedAt: 0,
                duration: 0,
              ),
            ),
          ],
        ),
      );

      expect(media.duration(episodeId: 'episode-1'), 120);
    });
  });
}
