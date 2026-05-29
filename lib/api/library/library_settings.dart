import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'library_settings.freezed.dart';
part 'library_settings.g.dart';

@freezed
abstract class LibrarySettings with _$LibrarySettings {
  const factory LibrarySettings({
    @JsonKey(name: "coverAspectRatio") double? coverAspectRatio,
    @JsonKey(name: "disableWatcher") bool? disableWatcher,
    @JsonKey(name: "skipMatchingMediaWithAsin") bool? skipMatchingMediaWithAsin,
    @JsonKey(name: "skipMatchingMediaWithIsbn") bool? skipMatchingMediaWithIsbn,
    @JsonKey(name: "autoScanCronExpression") String? autoScanCronExpression,
    @JsonKey(name: "audiobooksOnly") bool? audiobooksOnly,
    @JsonKey(name: "epubsAllowScriptedContent") bool? epubScriptedContent,
    @JsonKey(name: "hideSingleBookSeries") bool? hideSingleBookSeries,
    @JsonKey(name: "onlyShowLaterBooksInContinueSeries") bool? showLaterBooks,
    @JsonKey(name: "podcastSearchRegion") String? podcastSearchRegion,
    @JsonKey(name: "markAsFinishedTimeRemaining", fromJson: jsonIntFromDynamic) int? markAsFinishedTimeRemaining,
    @JsonKey(name: "markAsFinishedPercentComplete", fromJson: jsonDoubleFromDynamic)
    double? markAsFinishedPercentComplete,
    @JsonKey(name: "metadataPrecedence") List<String>? metadataPrecedence,
  }) = _LibrarySettings;

  factory LibrarySettings.fromJson(Map<String, dynamic> json) => _$LibrarySettingsFromJson(json);
}
