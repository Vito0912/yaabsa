import 'package:yaabsa/api/list/response/library_list_page.dart';

const carListPageSize = libraryListPageSize;

Iterable<({int page, int first, int last})> carListRanges(int total) sync* {
  for (var start = 0; start < total; start += carListPageSize) {
    yield (page: start ~/ carListPageSize, first: start + 1, last: (start + carListPageSize).clamp(0, total));
  }
}
