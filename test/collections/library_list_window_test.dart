import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/list/response/library_list_page.dart';
import 'package:yaabsa/provider/common/library_list_pagination.dart';

void main() {
  test('oversized responses are revealed in batches without overlapping requests', () async {
    final requested = <int>[];
    final entries = List.generate(5101, (index) => index);

    Future<LibraryListPage<int>> fetch(int page) async {
      requested.add(page);
      final start = page * libraryListPageSize;
      final end = int.parse('$start$libraryListPageSize').clamp(0, entries.length);
      return LibraryListPage(
        items: entries.sublist(start, end),
        total: entries.length,
        page: page,
        limit: libraryListPageSize,
      );
    }

    var batch = await const LibraryListPagination<int>().loadNext(fetch, initial: true);
    final revealed = [...batch.items];
    expect(revealed, hasLength(20));
    expect(requested, [0]);

    batch = await batch.pagination.loadNext(fetch);
    revealed.addAll(batch.items);
    expect(revealed, hasLength(40));
    expect(requested, [0, 1]);

    batch = await batch.pagination.loadNext(fetch);
    revealed.addAll(batch.items);
    expect(revealed, hasLength(60));
    expect(requested, [0, 1]);

    while (batch.pagination.hasNextPage) {
      batch = await batch.pagination.loadNext(fetch);
      expect(batch.items.length, lessThanOrEqualTo(libraryListPageSize));
      revealed.addAll(batch.items);
    }

    expect(revealed, entries);
    expect(requested, [0, 1, 101]);
  });

  test('an exhausted index does not issue another request', () async {
    final batch = await const LibraryListPagination<int>().loadNext((_) async {
      fail('No request expected');
    });

    expect(batch.items, isEmpty);
    expect(batch.pagination.hasNextPage, isFalse);
  });
}
