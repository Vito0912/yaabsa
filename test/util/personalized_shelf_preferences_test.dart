import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';
import 'package:yaabsa/util/personalized_shelf_preferences.dart';

void main() {
  for (final mediaType in HomeLibraryMediaType.values) {
    group('${mediaType.name} shelf preferences', () {
      test('include Pinned and hide it by default', () {
        final preferences = PersonalizedShelfPreferencesCodec.defaultsFor(mediaType);

        expect(preferences.orderedSectionIds.first, 'pinned');
        expect(preferences.hiddenSectionIds, contains('pinned'));
      });

      test('allow Pinned to be made visible', () {
        final preferences = PersonalizedShelfPreferencesCodec.defaultsFor(mediaType);

        final visible = preferences.withVisibility('pinned', true);

        expect(visible.hiddenSectionIds, isNot(contains('pinned')));
      });

      test('hide Pinned when migrating an older saved order', () {
        final preferences = PersonalizedShelfPreferencesCodec.decode(
          '{"order":["continue-listening"],"hidden":[]}',
          mediaType,
        );

        expect(preferences.orderedSectionIds.first, 'pinned');
        expect(preferences.hiddenSectionIds, contains('pinned'));
      });
    });
  }
}
