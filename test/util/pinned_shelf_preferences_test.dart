import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/pinned_shelf_preferences.dart';

void main() {
  group('PinnedShelfPreferencesCodec', () {
    test('encodes and decodes book and podcast pins by library', () {
      final bookPin = PinnedShelfEntry(itemId: 'book-item', pinnedAt: DateTime.fromMillisecondsSinceEpoch(1000));
      final episodePin = PinnedShelfEntry(
        itemId: 'podcast-item',
        episodeId: 'episode-2',
        pinnedAt: DateTime.fromMillisecondsSinceEpoch(2000),
      );
      final podcastPin = PinnedShelfEntry(
        itemId: 'whole-podcast-item',
        pinnedAt: DateTime.fromMillisecondsSinceEpoch(3000),
      );

      final decoded = PinnedShelfPreferencesCodec.decode(
        PinnedShelfPreferencesCodec.encode({
          'book-library': [bookPin],
          'podcast-library': [podcastPin, episodePin],
        }),
      );

      expect(decoded['book-library'], [bookPin]);
      expect(decoded['podcast-library'], [podcastPin, episodePin]);
      expect(decoded['book-library']!.single.isPodcastEpisode, isFalse);
      expect(decoded['podcast-library']!.first.isPodcastEpisode, isFalse);
      expect(decoded['podcast-library']!.last.isPodcastEpisode, isTrue);
    });

    test('keeps empty library entries to preserve first-pin behavior', () {
      final encoded = PinnedShelfPreferencesCodec.encode({'library': const <PinnedShelfEntry>[]});

      expect(PinnedShelfPreferencesCodec.decode(encoded), containsPair('library', isEmpty));
    });

    test('ignores duplicate and malformed entries without losing valid pins', () {
      const encoded = '''
        {
          "library": [
            {"itemId":"podcast","episodeId":"episode-1","pinnedAt":1000},
            {"itemId":"podcast","episodeId":"episode-1","pinnedAt":2000},
            {"itemId":"missing-time"},
            "invalid"
          ]
        }
      ''';

      final pins = PinnedShelfPreferencesCodec.decode(encoded)['library'];

      expect(pins, hasLength(1));
      expect(pins!.single.key, 'podcast:episode-1');
      expect(pins.single.pinnedAt.millisecondsSinceEpoch, 1000);
    });

    test('invalid payload decodes to an empty map', () {
      expect(PinnedShelfPreferencesCodec.decode('not-json'), isEmpty);
      expect(PinnedShelfPreferencesCodec.decode('[]'), isEmpty);
    });
  });
}
