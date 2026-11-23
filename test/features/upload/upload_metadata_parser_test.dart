import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/features/upload/upload_metadata_parser.dart';

void main() {
  group('UploadMetadataParser.firstResult', () {
    test('selects the first map from a response list', () {
      final result = UploadMetadataParser.firstResult([
        'unexpected value',
        {'title': 'The Distant Shore'},
        {'title': 'Ignored result'},
      ]);

      expect(result?['title'], 'The Distant Shore');
    });

    test('supports direct book, result, book and podcast response shapes', () {
      for (final key in const ['book', 'results', 'books', 'podcasts']) {
        final response = key == 'book'
            ? <String, dynamic>{
                key: <String, dynamic>{'title': 'The Distant Shore'},
              }
            : <String, dynamic>{
                key: [
                  <String, dynamic>{'title': 'The Distant Shore'},
                ],
              };

        expect(UploadMetadataParser.firstResult(response)?['title'], 'The Distant Shore', reason: key);
      }
    });

    test('returns null when response data has no metadata maps', () {
      expect(UploadMetadataParser.firstResult(null), isNull);
      expect(
        UploadMetadataParser.firstResult({
          'results': ['invalid'],
        }),
        isNull,
      );
    });
  });

  group('UploadMetadataParser.author', () {
    test('trims a single author string', () {
      expect(UploadMetadataParser.author({'author': ' Mira Ellery '}), 'Mira Ellery');
    });

    test('uses the first non-empty string or named author entry', () {
      expect(
        UploadMetadataParser.author({
          'authors': [
            '',
            {'name': ' Rowan Hale '},
          ],
        }),
        'Rowan Hale',
      );
    });

    test('returns null when no author name is present', () {
      expect(
        UploadMetadataParser.author({
          'authors': [
            null,
            {'name': ' '},
            7,
          ],
        }),
        isNull,
      );
    });
  });

  group('UploadMetadataParser.series', () {
    test('trims a single series string', () {
      expect(UploadMetadataParser.series({'series': ' The Tidemark Stories '}), 'The Tidemark Stories');
    });

    test('supports string and named series entries', () {
      expect(
        UploadMetadataParser.series({
          'series': [
            '',
            {'name': 'The Tidemark Stories'},
          ],
        }),
        'The Tidemark Stories',
      );
      expect(
        UploadMetadataParser.series({
          'series': [
            {'series': 'Northbound'},
          ],
        }),
        'Northbound',
      );
      expect(
        UploadMetadataParser.series({
          'series': [
            {'name': ' ', 'series': 'Northbound'},
          ],
        }),
        'Northbound',
      );
    });

    test('returns null when no series name is present', () {
      expect(
        UploadMetadataParser.series({
          'series': [
            null,
            {'name': ' '},
            7,
          ],
        }),
        isNull,
      );
    });
  });
}
