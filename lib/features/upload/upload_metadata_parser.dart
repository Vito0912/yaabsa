class UploadMetadataParser {
  const UploadMetadataParser._();

  static Map<String, dynamic>? firstResult(Object? responseData) {
    if (responseData is List) {
      for (final entry in responseData) {
        if (entry is Map<String, dynamic>) {
          return entry;
        }
      }
      return null;
    }

    if (responseData is! Map<String, dynamic>) {
      return null;
    }

    final directBook = responseData['book'];
    if (directBook is Map<String, dynamic>) {
      return directBook;
    }

    for (final key in const ['results', 'books', 'podcasts']) {
      final value = responseData[key];
      if (value is! List) {
        continue;
      }

      for (final entry in value) {
        if (entry is Map<String, dynamic>) {
          return entry;
        }
      }
    }

    return null;
  }

  static String? author(Map<String, dynamic> metadata) {
    final author = _nonEmptyString(metadata['author']);
    if (author != null) {
      return author;
    }

    final authors = metadata['authors'];
    if (authors is! List) {
      return null;
    }

    for (final entry in authors) {
      final name = entry is Map<String, dynamic> ? entry['name'] : entry;
      final normalizedName = _nonEmptyString(name);
      if (normalizedName != null) {
        return normalizedName;
      }
    }

    return null;
  }

  static String? series(Map<String, dynamic> metadata) {
    final series = metadata['series'];
    final singleSeries = _nonEmptyString(series);
    if (singleSeries != null) {
      return singleSeries;
    }

    if (series is! List) {
      return null;
    }

    for (final entry in series) {
      final directName = entry is Map<String, dynamic> ? _nonEmptyString(entry['name']) : _nonEmptyString(entry);
      if (directName != null) {
        return directName;
      }

      final fallbackName = entry is Map<String, dynamic> ? entry['series'] : null;
      final normalizedName = _nonEmptyString(fallbackName);
      if (normalizedName != null) {
        return normalizedName;
      }
    }

    return null;
  }

  static String? _nonEmptyString(Object? value) {
    if (value is! String) {
      return null;
    }

    final normalizedValue = value.trim();
    return normalizedValue.isEmpty ? null : normalizedValue;
  }
}
