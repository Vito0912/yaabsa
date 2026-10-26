class LibraryListPage<T> {
  const LibraryListPage({required this.items, required this.total, required this.page, required this.limit});

  final List<T> items;
  final int total;
  final int page;
  final int limit;

  bool get hasMore => page * limit + items.length < total;

  factory LibraryListPage.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) parse, {
    required int requestedPage,
    required int requestedLimit,
  }) {
    final results = json['results'];
    final total = int.tryParse('${json['total']}');
    final page = int.tryParse('${json['page']}') ?? requestedPage;
    final limit = int.tryParse('${json['limit']}') ?? requestedLimit;
    if (results is! List ||
        total == null ||
        total < 0 ||
        page != requestedPage ||
        limit <= 0 ||
        limit != requestedLimit ||
        results.length < (total - page * limit).clamp(0, limit) ||
        results.length > (total - page * limit).clamp(0, total)) {
      throw const FormatException('Invalid library list page.');
    }
    return LibraryListPage(
      items: results.map((item) => parse(Map<String, dynamic>.from(item as Map))).toList(growable: false),
      total: total,
      page: page,
      limit: limit,
    );
  }
}
