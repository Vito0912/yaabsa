import 'package:freezed_annotation/freezed_annotation.dart';

import 'library_folder.dart';
import 'library_settings.dart';

part 'library.freezed.dart';
part 'library.g.dart';

@freezed
abstract class Library with _$Library {
  const factory Library({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "displayOrder") required int displayOrder,
    @JsonKey(name: "icon") required String icon,
    @JsonKey(name: "mediaType") required String mediaType,
    @JsonKey(name: "provider") required String provider,
    @JsonKey(name: "lastScan") int? lastScan,
    @JsonKey(name: "lastScanVersion") String? lastScanVersion,
    @JsonKey(name: "createdAt") required int createdAt,
    @JsonKey(name: "lastUpdate") int? lastUpdate,
    @JsonKey(name: "settings") required LibrarySettings settings,
    @JsonKey(name: "folders") List<LibraryFolder>? folders,
  }) = _Library;

  factory Library.fromJson(Map<String, dynamic> json) =>
      _$LibraryFromJson(json);
}
