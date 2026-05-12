import 'package:flutter/foundation.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/library_items/series.dart';

@immutable
class LibraryItemEditorNamedEntity {
  const LibraryItemEditorNamedEntity({required this.id, required this.name});

  final String id;
  final String name;

  LibraryItemEditorNamedEntity copyWith({String? id, String? name}) {
    return LibraryItemEditorNamedEntity(id: id ?? this.id, name: name ?? this.name);
  }
}

@immutable
class LibraryItemEditorSeriesEntry {
  const LibraryItemEditorSeriesEntry({required this.id, required this.name, required this.sequence});

  final String id;
  final String name;
  final String sequence;

  LibraryItemEditorSeriesEntry copyWith({String? id, String? name, String? sequence}) {
    return LibraryItemEditorSeriesEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      sequence: sequence ?? this.sequence,
    );
  }
}

@immutable
class LibraryItemEditorDraft {
  const LibraryItemEditorDraft({
    required this.isPodcast,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.podcastAuthor,
    required this.narrators,
    required this.series,
    required this.genres,
    required this.tags,
    required this.publishedYear,
    required this.publisher,
    required this.descriptionHtml,
    required this.isbn,
    required this.asin,
    required this.language,
    required this.explicit,
    required this.abridged,
    required this.releaseDate,
    required this.feedUrl,
    required this.itunesPageUrl,
    required this.itunesId,
    required this.podcastType,
  });

  final bool isPodcast;

  final String title;
  final String subtitle;
  final List<LibraryItemEditorNamedEntity> authors;
  final String podcastAuthor;
  final List<String> narrators;
  final List<LibraryItemEditorSeriesEntry> series;
  final List<String> genres;
  final List<String> tags;
  final String publishedYear;
  final String publisher;
  final String descriptionHtml;
  final String isbn;
  final String asin;
  final String language;
  final bool explicit;
  final bool abridged;
  final String releaseDate;
  final String feedUrl;
  final String itunesPageUrl;
  final String itunesId;
  final String podcastType;

  factory LibraryItemEditorDraft.fromLibraryItem(LibraryItem item, {String? descriptionHtmlOverride}) {
    final bookMetadata = item.media?.bookMedia?.metadata;
    final podcastMetadata = item.media?.podcastMedia?.metadata;

    return LibraryItemEditorDraft(
      isPodcast: item.mediaType == 'podcast' || item.media?.podcastMedia != null,
      title: (bookMetadata?.title ?? podcastMetadata?.title ?? '').trim(),
      subtitle: (bookMetadata?.subtitle ?? '').trim(),
      authors: (bookMetadata?.authors ?? const <Author>[])
          .map(
            (author) => LibraryItemEditorNamedEntity(
              id: _normalizedText(author.id).isNotEmpty ? _normalizedText(author.id) : _normalizedText(author.name),
              name: _normalizedText(author.name),
            ),
          )
          .where((entry) => entry.name.isNotEmpty)
          .toList(growable: false),
      podcastAuthor: (podcastMetadata?.author ?? '').trim(),
      narrators: _normalizeStringList(bookMetadata?.narrators ?? const <String>[]),
      series: (bookMetadata?.series ?? const <Series>[])
          .map(
            (entry) => LibraryItemEditorSeriesEntry(
              id: _normalizedText(entry.id).isNotEmpty ? _normalizedText(entry.id) : _normalizedText(entry.name),
              name: _normalizedText(entry.name),
              sequence: _normalizedText(entry.sequence),
            ),
          )
          .where((entry) => entry.name.isNotEmpty)
          .toList(growable: false),
      genres: _normalizeStringList(bookMetadata?.genres ?? podcastMetadata?.genres ?? const <String>[]),
      tags: _normalizeStringList(item.media?.bookMedia?.tags ?? item.media?.podcastMedia?.tags ?? const <String>[]),
      publishedYear: (bookMetadata?.publishedYear ?? '').trim(),
      publisher: (bookMetadata?.publisher ?? '').trim(),
      descriptionHtml: descriptionHtmlOverride ?? (bookMetadata?.description ?? podcastMetadata?.description ?? ''),
      isbn: (bookMetadata?.isbn ?? '').trim(),
      asin: (bookMetadata?.asin ?? '').trim(),
      language: (bookMetadata?.language ?? podcastMetadata?.language ?? '').trim(),
      explicit: (bookMetadata?.explicit ?? podcastMetadata?.explicit) ?? false,
      abridged: bookMetadata?.abridged ?? false,
      releaseDate: (podcastMetadata?.releaseDate ?? '').trim(),
      feedUrl: (podcastMetadata?.feedUrl ?? '').trim(),
      itunesPageUrl: (podcastMetadata?.itunesPageUrl ?? '').trim(),
      itunesId: (podcastMetadata?.itunesId ?? '').trim(),
      podcastType: (podcastMetadata?.type ?? '').trim(),
    );
  }

  LibraryItemEditorDraft copyWith({
    bool? isPodcast,
    String? title,
    String? subtitle,
    List<LibraryItemEditorNamedEntity>? authors,
    String? podcastAuthor,
    List<String>? narrators,
    List<LibraryItemEditorSeriesEntry>? series,
    List<String>? genres,
    List<String>? tags,
    String? publishedYear,
    String? publisher,
    String? descriptionHtml,
    String? isbn,
    String? asin,
    String? language,
    bool? explicit,
    bool? abridged,
    String? releaseDate,
    String? feedUrl,
    String? itunesPageUrl,
    String? itunesId,
    String? podcastType,
  }) {
    return LibraryItemEditorDraft(
      isPodcast: isPodcast ?? this.isPodcast,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      authors: authors ?? this.authors,
      podcastAuthor: podcastAuthor ?? this.podcastAuthor,
      narrators: narrators ?? this.narrators,
      series: series ?? this.series,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      publishedYear: publishedYear ?? this.publishedYear,
      publisher: publisher ?? this.publisher,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
      isbn: isbn ?? this.isbn,
      asin: asin ?? this.asin,
      language: language ?? this.language,
      explicit: explicit ?? this.explicit,
      abridged: abridged ?? this.abridged,
      releaseDate: releaseDate ?? this.releaseDate,
      feedUrl: feedUrl ?? this.feedUrl,
      itunesPageUrl: itunesPageUrl ?? this.itunesPageUrl,
      itunesId: itunesId ?? this.itunesId,
      podcastType: podcastType ?? this.podcastType,
    );
  }
}

@immutable
class LibraryItemEditorDiff {
  const LibraryItemEditorDiff({required this.request, required this.hasChanges});

  final UpdateLibraryItemMediaRequest request;
  final bool hasChanges;
}

LibraryItemEditorDiff buildLibraryItemEditorDiff({
  required LibraryItemEditorDraft initial,
  required LibraryItemEditorDraft current,
  required bool descriptionChanged,
}) {
  UpdateLibraryItemMediaMetadataPatch? metadata;
  var hasChanges = false;

  void setMetadata(UpdateLibraryItemMediaMetadataPatch Function(UpdateLibraryItemMediaMetadataPatch current) updater) {
    final seed = metadata ?? const UpdateLibraryItemMediaMetadataPatch();
    metadata = updater(seed);
    hasChanges = true;
  }

  if (_normalizedText(initial.title) != _normalizedText(current.title)) {
    setMetadata((m) => m.copyWith(title: _normalizedText(current.title)));
  }

  if (initial.isPodcast) {
    if (_normalizedText(initial.podcastAuthor) != _normalizedText(current.podcastAuthor)) {
      setMetadata((m) => m.copyWith(author: _normalizedText(current.podcastAuthor)));
    }

    if (_normalizedText(initial.releaseDate) != _normalizedText(current.releaseDate)) {
      setMetadata((m) => m.copyWith(releaseDate: _normalizedText(current.releaseDate)));
    }

    if (_normalizedText(initial.feedUrl) != _normalizedText(current.feedUrl)) {
      setMetadata((m) => m.copyWith(feedUrl: _normalizedText(current.feedUrl)));
    }

    if (_normalizedText(initial.itunesPageUrl) != _normalizedText(current.itunesPageUrl)) {
      setMetadata((m) => m.copyWith(itunesPageUrl: _normalizedText(current.itunesPageUrl)));
    }

    if (_normalizedText(initial.itunesId) != _normalizedText(current.itunesId)) {
      setMetadata((m) => m.copyWith(itunesId: _normalizedText(current.itunesId)));
    }

    if (_normalizedText(initial.podcastType) != _normalizedText(current.podcastType)) {
      setMetadata((m) => m.copyWith(type: _normalizedText(current.podcastType)));
    }
  } else {
    if (_normalizedText(initial.subtitle) != _normalizedText(current.subtitle)) {
      setMetadata((m) => m.copyWith(subtitle: _normalizedText(current.subtitle)));
    }

    if (!_sameNamedEntities(initial.authors, current.authors)) {
      final authors = current.authors
          .map(
            (entry) => Author(
              id: _normalizedText(entry.id).isNotEmpty ? _normalizedText(entry.id) : _normalizedText(entry.name),
              name: _normalizedText(entry.name),
            ),
          )
          .where((entry) => _normalizedText(entry.name).isNotEmpty)
          .toList(growable: false);

      setMetadata((m) => m.copyWith(authors: authors));
    }

    final initialNarrators = _normalizeStringList(initial.narrators);
    final currentNarrators = _normalizeStringList(current.narrators);
    if (!listEquals(initialNarrators, currentNarrators)) {
      setMetadata((m) => m.copyWith(narrators: currentNarrators));
    }

    if (!_sameSeries(initial.series, current.series)) {
      final series = current.series
          .map(
            (entry) => Series(
              id: _normalizedText(entry.id).isNotEmpty ? _normalizedText(entry.id) : _normalizedText(entry.name),
              name: _normalizedText(entry.name),
              sequence: _normalizedText(entry.sequence).isEmpty ? null : _normalizedText(entry.sequence),
            ),
          )
          .where((entry) => _normalizedText(entry.name).isNotEmpty)
          .toList(growable: false);

      setMetadata((m) => m.copyWith(series: series));
    }

    if (_normalizedText(initial.publishedYear) != _normalizedText(current.publishedYear)) {
      setMetadata((m) => m.copyWith(publishedYear: _normalizedText(current.publishedYear)));
    }

    if (_normalizedText(initial.publisher) != _normalizedText(current.publisher)) {
      setMetadata((m) => m.copyWith(publisher: _normalizedText(current.publisher)));
    }

    if (_normalizedText(initial.isbn) != _normalizedText(current.isbn)) {
      setMetadata((m) => m.copyWith(isbn: _normalizedText(current.isbn)));
    }

    if (_normalizedText(initial.asin) != _normalizedText(current.asin)) {
      setMetadata((m) => m.copyWith(asin: _normalizedText(current.asin)));
    }

    if (initial.abridged != current.abridged) {
      setMetadata((m) => m.copyWith(abridged: current.abridged));
    }
  }

  if (descriptionChanged) {
    setMetadata((m) => m.copyWith(description: current.descriptionHtml));
  }

  final initialGenres = _normalizeStringList(initial.genres);
  final currentGenres = _normalizeStringList(current.genres);
  if (!listEquals(initialGenres, currentGenres)) {
    setMetadata((m) => m.copyWith(genres: currentGenres));
  }

  final initialTags = _normalizeStringList(initial.tags);
  final currentTags = _normalizeStringList(current.tags);
  List<String>? tagsPatch;
  if (!listEquals(initialTags, currentTags)) {
    tagsPatch = currentTags;
    hasChanges = true;
  }

  if (_normalizedText(initial.language) != _normalizedText(current.language)) {
    setMetadata((m) => m.copyWith(language: _normalizedText(current.language)));
  }

  if (initial.explicit != current.explicit) {
    setMetadata((m) => m.copyWith(explicit: current.explicit));
  }

  return LibraryItemEditorDiff(
    request: UpdateLibraryItemMediaRequest(metadata: metadata, tags: tagsPatch),
    hasChanges: hasChanges,
  );
}

String _normalizedText(String? input) => (input ?? '').trim();

List<String> _normalizeStringList(List<String> values) {
  final seen = <String>{};
  final normalized = <String>[];

  for (final value in values) {
    final trimmed = _normalizedText(value);
    if (trimmed.isEmpty) {
      continue;
    }
    final lower = trimmed.toLowerCase();
    if (!seen.add(lower)) {
      continue;
    }
    normalized.add(trimmed);
  }

  return normalized;
}

bool _sameNamedEntities(List<LibraryItemEditorNamedEntity> a, List<LibraryItemEditorNamedEntity> b) {
  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; i++) {
    final left = a[i];
    final right = b[i];
    if (_normalizedText(left.id) != _normalizedText(right.id) ||
        _normalizedText(left.name) != _normalizedText(right.name)) {
      return false;
    }
  }

  return true;
}

bool _sameSeries(List<LibraryItemEditorSeriesEntry> a, List<LibraryItemEditorSeriesEntry> b) {
  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; i++) {
    final left = a[i];
    final right = b[i];

    if (_normalizedText(left.id) != _normalizedText(right.id) ||
        _normalizedText(left.name) != _normalizedText(right.name) ||
        _normalizedText(left.sequence) != _normalizedText(right.sequence)) {
      return false;
    }
  }

  return true;
}
