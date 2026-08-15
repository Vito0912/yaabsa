import 'package:yaabsa/api/library/collapsed_series.dart';
import 'package:yaabsa/api/library_items/library_file.dart';
import 'package:yaabsa/api/library_items/media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_item.freezed.dart';
part 'library_item.g.dart';

@freezed
abstract class LibraryItem with _$LibraryItem {
  const LibraryItem._();

  const factory LibraryItem({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "ino") required String ino,
    @JsonKey(name: "oldLibraryItemId") String? oldLibraryItemId,
    @JsonKey(name: "libraryId") String? libraryId,
    @JsonKey(name: "folderId") String? folderId,
    @JsonKey(name: "path") String? path,
    @JsonKey(name: "relPath") String? relPath,
    @JsonKey(name: "isFile") bool? isFile,
    @JsonKey(name: "mtimeMs") int? mtimeMs,
    @JsonKey(name: "ctimeMs") int? ctimeMs,
    @JsonKey(name: "birthtimeMs") int? birthtimeMs,
    @JsonKey(name: "addedAt") int? addedAt,
    @JsonKey(name: "updatedAt") int? updatedAt,
    @JsonKey(name: "lastScan") int? lastScan,
    @JsonKey(name: "scanVersion") String? scanVersion,
    @JsonKey(name: "isMissing") bool? isMissing,
    @JsonKey(name: "isInvalid") bool? isInvalid,
    @JsonKey(name: "mediaType") String? mediaType,
    @JsonKey(name: "media") required Media? media,
    @JsonKey(name: "libraryFiles") required List<LibraryFile>? libraryFiles,
    @JsonKey(name: "size") int? size,
    @JsonKey(name: "collapsedSeries") CollapsedSeries? collapsedSeries,
  }) = _LibraryItem;

  factory LibraryItem.fromJson(Map<String, dynamic> json) => _$LibraryItemFromJson(json);

  // QoL
  String get title {
    final collapsedTitle = collapsedSeries?.name;
    if (collapsedTitle != null && collapsedTitle.isNotEmpty) {
      return collapsedTitle;
    }

    return media?.bookMedia?.metadata.title ?? media?.podcastMedia?.metadata.title ?? 'Untitled';
  }

  String? get subtitle {
    return media?.bookMedia?.metadata.subtitle;
  }

  String? get authorString {
    final bookMetadata = media?.bookMedia?.metadata;
    final authors = bookMetadata?.authors
        ?.map((author) => author.name.trim())
        .where((author) => author.isNotEmpty)
        .join(', ');

    return _firstNonEmpty(<String?>[authors, bookMetadata?.authorName, media?.podcastMedia?.metadata.author]);
  }

  String? get narratorString {
    final bookMetadata = media?.bookMedia?.metadata;
    final normalized = bookMetadata?.narrators
        ?.map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);

    return _firstNonEmpty(<String?>[
      normalized == null || normalized.isEmpty ? null : normalized.join(', '),
      bookMetadata?.narratorName,
    ]);
  }

  String? get seriesName {
    final metadata = media?.bookMedia?.metadata;
    return _firstNonEmpty(<String?>[metadata?.series?.firstOrNull?.name, metadata?.seriesName]);
  }

  String? get seriesPosition {
    return media?.bookMedia?.metadata.series?.firstOrNull?.sequence;
  }

  String? get coverPath {
    return media?.bookMedia?.coverPath ?? media?.podcastMedia?.coverPath;
  }

  bool get hasCover {
    final path = coverPath;
    return path != null && path.isNotEmpty;
  }
}

String? _firstNonEmpty(Iterable<String?> values) {
  for (final value in values) {
    final normalized = value?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }

  return null;
}
