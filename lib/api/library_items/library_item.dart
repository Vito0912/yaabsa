import 'package:buchshelfly/api/library/collapsed_series.dart';
import 'package:buchshelfly/api/library_items/library_file.dart';
import 'package:buchshelfly/api/library_items/media.dart';
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
    return (media?.bookMedia?.metadata.title ?? media?.podcastMedia?.metadata.title)!;
  }

  String? get subtitle {
    return media?.bookMedia?.metadata.subtitle;
  }
}
