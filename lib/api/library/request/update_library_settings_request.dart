import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'update_library_settings_request.freezed.dart';
part 'update_library_settings_request.g.dart';

@freezed
abstract class UpdateLibrarySettingsRequest with _$UpdateLibrarySettingsRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateLibrarySettingsRequest({
    @JsonKey(name: 'coverAspectRatio') double? coverAspectRatio,
    @JsonKey(name: 'disableWatcher') bool? disableWatcher,
    @JsonKey(name: 'skipMatchingMediaWithAsin') bool? skipMatchingMediaWithAsin,
    @JsonKey(name: 'skipMatchingMediaWithIsbn') bool? skipMatchingMediaWithIsbn,
    @JsonKey(name: 'autoScanCronExpression') String? autoScanCronExpression,
    @JsonKey(name: 'audiobooksOnly') bool? audiobooksOnly,
    @JsonKey(name: 'epubsAllowScriptedContent') bool? epubScriptedContent,
    @JsonKey(name: 'hideSingleBookSeries') bool? hideSingleBookSeries,
    @JsonKey(name: 'onlyShowLaterBooksInContinueSeries') bool? showLaterBooks,
    @JsonKey(name: 'podcastSearchRegion') String? podcastSearchRegion,
    @JsonKey(name: 'markAsFinishedTimeRemaining', fromJson: jsonIntFromDynamic) int? markAsFinishedTimeRemaining,
    @JsonKey(name: 'markAsFinishedPercentComplete', fromJson: jsonDoubleFromDynamic)
    double? markAsFinishedPercentComplete,
    @JsonKey(name: 'metadataPrecedence') List<String>? metadataPrecedence,
  }) = _UpdateLibrarySettingsRequest;

  factory UpdateLibrarySettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLibrarySettingsRequestFromJson(json);
}
