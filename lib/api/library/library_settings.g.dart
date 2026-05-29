// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibrarySettings _$LibrarySettingsFromJson(Map<String, dynamic> json) => _LibrarySettings(
  coverAspectRatio: (json['coverAspectRatio'] as num?)?.toDouble(),
  disableWatcher: json['disableWatcher'] as bool?,
  skipMatchingMediaWithAsin: json['skipMatchingMediaWithAsin'] as bool?,
  skipMatchingMediaWithIsbn: json['skipMatchingMediaWithIsbn'] as bool?,
  autoScanCronExpression: json['autoScanCronExpression'] as String?,
  audiobooksOnly: json['audiobooksOnly'] as bool?,
  epubScriptedContent: json['epubsAllowScriptedContent'] as bool?,
  hideSingleBookSeries: json['hideSingleBookSeries'] as bool?,
  showLaterBooks: json['onlyShowLaterBooksInContinueSeries'] as bool?,
  podcastSearchRegion: json['podcastSearchRegion'] as String?,
  markAsFinishedTimeRemaining: jsonIntFromDynamic(json['markAsFinishedTimeRemaining']),
  markAsFinishedPercentComplete: jsonDoubleFromDynamic(json['markAsFinishedPercentComplete']),
  metadataPrecedence: (json['metadataPrecedence'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$LibrarySettingsToJson(_LibrarySettings instance) => <String, dynamic>{
  'coverAspectRatio': instance.coverAspectRatio,
  'disableWatcher': instance.disableWatcher,
  'skipMatchingMediaWithAsin': instance.skipMatchingMediaWithAsin,
  'skipMatchingMediaWithIsbn': instance.skipMatchingMediaWithIsbn,
  'autoScanCronExpression': instance.autoScanCronExpression,
  'audiobooksOnly': instance.audiobooksOnly,
  'epubsAllowScriptedContent': instance.epubScriptedContent,
  'hideSingleBookSeries': instance.hideSingleBookSeries,
  'onlyShowLaterBooksInContinueSeries': instance.showLaterBooks,
  'podcastSearchRegion': instance.podcastSearchRegion,
  'markAsFinishedTimeRemaining': instance.markAsFinishedTimeRemaining,
  'markAsFinishedPercentComplete': instance.markAsFinishedPercentComplete,
  'metadataPrecedence': instance.metadataPrecedence,
};
