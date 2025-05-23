// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibrarySettings _$LibrarySettingsFromJson(Map<String, dynamic> json) =>
    _LibrarySettings(
      coverAspectRatio: (json['coverAspectRatio'] as num?)?.toDouble(),
      disableWatcher: json['disableWatcher'] as bool?,
      skipMatchingMediaWithIsbn: json['skipMatchingMediaWithAsin'] as bool?,
      skipMatchingMediaWithAsin: json['skipMatchingMediaWithIsbn'] as bool?,
      autoScanCronExpression: json['autoScanCronExpression'] as String?,
      audiobooksOnly: json['audiobooksOnly'] as bool?,
      epubScriptedContent: json['epubsAllowScriptedContent'] as bool?,
      hideSingleBookSeries: json['hideSingleBookSeries'] as bool?,
      showLaterBooks: json['onlyShowLaterBooksInContinueSeries'] as bool?,
      podcastSearchRegion: json['podcastSearchRegion'] as String?,
      metadataPrecedence:
          (json['metadataPrecedence'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$LibrarySettingsToJson(_LibrarySettings instance) =>
    <String, dynamic>{
      'coverAspectRatio': instance.coverAspectRatio,
      'disableWatcher': instance.disableWatcher,
      'skipMatchingMediaWithAsin': instance.skipMatchingMediaWithIsbn,
      'skipMatchingMediaWithIsbn': instance.skipMatchingMediaWithAsin,
      'autoScanCronExpression': instance.autoScanCronExpression,
      'audiobooksOnly': instance.audiobooksOnly,
      'epubsAllowScriptedContent': instance.epubScriptedContent,
      'hideSingleBookSeries': instance.hideSingleBookSeries,
      'onlyShowLaterBooksInContinueSeries': instance.showLaterBooks,
      'podcastSearchRegion': instance.podcastSearchRegion,
      'metadataPrecedence': instance.metadataPrecedence,
    };
