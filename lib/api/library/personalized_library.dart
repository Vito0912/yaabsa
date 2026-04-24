import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personalized_library.freezed.dart';
part 'personalized_library.g.dart';

@freezed
abstract class PersonalizedLibrary with _$PersonalizedLibrary {
  const PersonalizedLibrary._();

  const factory PersonalizedLibrary({
    ShelfEntry<LibraryItem>? continueListening,
    ShelfEntry<LibraryItem>? recentlyAdded,
    ShelfEntry<Series>? recentSeries,
    ShelfEntry<LibraryItem>? discover,
    ShelfEntry<LibraryItem>? listenAgain,
    ShelfEntry<Author>? newestAuthors,
    ShelfEntry<Episode>? newestEpisodes,
    ShelfEntry<LibraryItem>? continueSeries,
    @Default(<ShelfEntry<LibraryItem>>[]) List<ShelfEntry<LibraryItem>> extraLibraryShelves,
    @Default(<ShelfEntry<Episode>>[]) List<ShelfEntry<Episode>> extraEpisodeShelves,
  }) = _PersonalizedLibrary;

  factory PersonalizedLibrary.fromJson(List<dynamic> jsonList) {
    ShelfEntry<LibraryItem>? tempContinueListening;
    ShelfEntry<LibraryItem>? tempRecentlyAdded;
    ShelfEntry<Series>? tempRecentSeries;
    ShelfEntry<LibraryItem>? tempDiscover;
    ShelfEntry<LibraryItem>? tempListenAgain;
    ShelfEntry<Author>? tempNewestAuthors;
    ShelfEntry<Episode>? tempNewestEpisodes;
    ShelfEntry<LibraryItem>? tempContinueSeries;
    final tempExtraLibraryShelves = <ShelfEntry<LibraryItem>>[];
    final tempExtraEpisodeShelves = <ShelfEntry<Episode>>[];

    const String idContinueListening = 'continue-listening';
    const String idRecentlyAdded = 'recently-added';
    const String idRecentSeries = 'recent-series';
    const String idDiscover = 'discover';
    const String idListenAgain = 'listen-again';
    const String idNewestAuthors = 'newest-authors';
    const String idNewestEpisodes = 'newest-episodes';
    const String idContinueSeries = 'continue-series';

    for (final itemJson in jsonList) {
      if (itemJson is Map<String, dynamic>) {
        final String id = itemJson['id'] as String;
        switch (id) {
          case idContinueListening:
            tempContinueListening = _parseLibraryItemShelfEntry(itemJson);
            break;
          case idRecentlyAdded:
            tempRecentlyAdded = _parseLibraryItemShelfEntry(itemJson);
            break;
          case idRecentSeries:
            tempRecentSeries = ShelfEntry<Series>.fromJson(
              itemJson,
              (json) => Series.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idDiscover:
            tempDiscover = _parseLibraryItemShelfEntry(itemJson);
            break;
          case idListenAgain:
            tempListenAgain = _parseLibraryItemShelfEntry(itemJson);
            break;
          case idNewestAuthors:
            tempNewestAuthors = ShelfEntry<Author>.fromJson(
              itemJson,
              (json) => Author.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idNewestEpisodes:
            final newestEpisodesShelf = _parseLibraryItemShelfEntry(itemJson);
            if (newestEpisodesShelf.entities.isNotEmpty) {
              tempExtraLibraryShelves.add(newestEpisodesShelf);
            } else {
              tempNewestEpisodes = _parseEpisodeShelfEntry(itemJson);
            }
            break;
          case idContinueSeries:
            tempContinueSeries = _parseLibraryItemShelfEntry(itemJson);
            break;
          default:
            final shelfType = itemJson['type'] as String?;
            if (shelfType == 'book' || shelfType == 'podcast') {
              tempExtraLibraryShelves.add(_parseLibraryItemShelfEntry(itemJson));
            } else if (shelfType == 'episodes' || shelfType == 'episode') {
              final episodeShelfAsLibraryItems = _parseLibraryItemShelfEntry(itemJson);
              if (episodeShelfAsLibraryItems.entities.isNotEmpty) {
                tempExtraLibraryShelves.add(episodeShelfAsLibraryItems);
              } else {
                tempExtraEpisodeShelves.add(_parseEpisodeShelfEntry(itemJson));
              }
            } else {
              logger('Warning: Unknown shelf ID encountered: $id', level: InfoLevel.warning);
            }
        }
      } else {
        throw FormatException('Invalid item in JSON list: Expected Map<String, dynamic>, got ${itemJson.runtimeType}');
      }
    }

    return _PersonalizedLibrary(
      continueListening: tempContinueListening,
      recentlyAdded: tempRecentlyAdded,
      recentSeries: tempRecentSeries,
      discover: tempDiscover,
      listenAgain: tempListenAgain,
      newestAuthors: tempNewestAuthors,
      newestEpisodes: tempNewestEpisodes,
      continueSeries: tempContinueSeries,
      extraLibraryShelves: tempExtraLibraryShelves,
      extraEpisodeShelves: tempExtraEpisodeShelves,
    );
  }
}

ShelfEntry<LibraryItem> _parseLibraryItemShelfEntry(Map<String, dynamic> itemJson) {
  final parsedItems = <LibraryItem>[];
  final rawEntities = itemJson['entities'];

  if (rawEntities is List) {
    for (final rawEntity in rawEntities) {
      if (rawEntity is! Map<String, dynamic>) {
        logger(
          'Skipping non-map library entity in shelf ${itemJson['id']}: ${rawEntity.runtimeType}',
          tag: 'PersonalizedLibrary',
          level: InfoLevel.warning,
        );
        continue;
      }

      try {
        parsedItems.add(LibraryItem.fromJson(_normalizeLibraryItemShelfEntity(rawEntity)));
      } catch (e, s) {
        logger(
          'Skipping malformed library entity in shelf ${itemJson['id']}: $e\n$s',
          tag: 'PersonalizedLibrary',
          level: InfoLevel.warning,
        );
      }
    }
  }

  final rawType = itemJson['type'] as String?;
  final shelfType = const ShelfTypeConverter().fromJson(rawType == null || rawType.isEmpty ? 'book' : rawType);

  return ShelfEntry<LibraryItem>(
    id: itemJson['id'] as String? ?? 'library-items',
    label: itemJson['label'] as String? ?? 'Items',
    labelStringKey: itemJson['labelStringKey'] as String? ?? '',
    type: shelfType,
    total: (itemJson['total'] as num?)?.toInt() ?? parsedItems.length,
    entities: parsedItems,
  );
}

Map<String, dynamic> _normalizeLibraryItemShelfEntity(Map<String, dynamic> entityJson) {
  final normalized = Map<String, dynamic>.from(entityJson);
  final rawMedia = entityJson['media'];

  if (rawMedia is! Map<String, dynamic>) {
    return normalized;
  }

  final mediaJson = Map<String, dynamic>.from(rawMedia);
  final libraryItemId = entityJson['id']?.toString() ?? entityJson['libraryItemId']?.toString();
  if (libraryItemId != null && libraryItemId.isNotEmpty) {
    mediaJson['libraryItemId'] ??= libraryItemId;
  }

  final recentEpisode = entityJson['recentEpisode'];
  if (recentEpisode is! Map<String, dynamic>) {
    normalized['media'] = mediaJson;
    return normalized;
  }

  final rawEpisodes = mediaJson['episodes'];
  if (rawEpisodes is List && rawEpisodes.isNotEmpty) {
    normalized['media'] = mediaJson;
    return normalized;
  }

  mediaJson['episodes'] = [recentEpisode];
  normalized['media'] = mediaJson;
  return normalized;
}

ShelfEntry<Episode> _parseEpisodeShelfEntry(Map<String, dynamic> itemJson) {
  final parsedEpisodes = <Episode>[];
  final rawEntities = itemJson['entities'];

  if (rawEntities is List) {
    for (final rawEntity in rawEntities) {
      if (rawEntity is! Map<String, dynamic>) {
        logger(
          'Skipping non-map episode entity in shelf ${itemJson['id']}: ${rawEntity.runtimeType}',
          tag: 'PersonalizedLibrary',
          level: InfoLevel.warning,
        );
        continue;
      }

      final episodeJson = _extractEpisodeShelfEntity(rawEntity);
      if (episodeJson == null) {
        logger(
          'Skipping episode shelf entity without episode payload in shelf ${itemJson['id']}',
          tag: 'PersonalizedLibrary',
          level: InfoLevel.warning,
        );
        continue;
      }

      try {
        parsedEpisodes.add(Episode.fromJson(episodeJson));
      } catch (e, s) {
        logger(
          'Skipping malformed episode entity in shelf ${itemJson['id']}: $e\n$s',
          tag: 'PersonalizedLibrary',
          level: InfoLevel.warning,
        );
      }
    }
  }

  return ShelfEntry<Episode>(
    id: itemJson['id'] as String? ?? 'episodes',
    label: itemJson['label'] as String? ?? 'Episodes',
    labelStringKey: itemJson['labelStringKey'] as String? ?? '',
    type: const ShelfTypeConverter().fromJson('episodes'),
    total: (itemJson['total'] as num?)?.toInt() ?? parsedEpisodes.length,
    entities: parsedEpisodes,
  );
}

Map<String, dynamic>? _extractEpisodeShelfEntity(Map<String, dynamic> rawEntity) {
  final recentEpisode = rawEntity['recentEpisode'];
  if (recentEpisode is Map<String, dynamic>) {
    final episodeJson = Map<String, dynamic>.from(recentEpisode);
    episodeJson['libraryItemId'] ??= recentEpisode['libraryItemId'] ?? rawEntity['id'];
    episodeJson['id'] ??= recentEpisode['id'];
    return episodeJson;
  }

  if (rawEntity.containsKey('libraryItemId') || rawEntity.containsKey('audioFile') || rawEntity.containsKey('title')) {
    return Map<String, dynamic>.from(rawEntity);
  }

  return null;
}

@Freezed(genericArgumentFactories: true)
abstract class ShelfEntry<T> with _$ShelfEntry<T> {
  const factory ShelfEntry({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "label") required String label,
    @JsonKey(name: "labelStringKey") required String labelStringKey,
    @JsonKey(name: "type") @ShelfTypeConverter() required ShelfType type,
    @JsonKey(name: "total") required int total,
    @JsonKey(name: "entities") required List<T> entities,
  }) = _ShelfEntry;

  factory ShelfEntry.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ShelfEntryFromJson(json, fromJsonT);
}

enum ShelfType {
  @JsonValue("book")
  book,
  @JsonValue("series")
  series,
  @JsonValue("authors")
  author,
  @JsonValue("episodes")
  episode,
  @JsonValue("podcast")
  podcast,
}

class ShelfTypeConverter implements JsonConverter<ShelfType, String> {
  const ShelfTypeConverter();

  @override
  ShelfType fromJson(String json) {
    switch (json) {
      case 'book':
        return ShelfType.book;
      case 'series':
        return ShelfType.series;
      case 'authors':
        return ShelfType.author;
      case 'episode':
      case 'episodes':
        return ShelfType.episode;
      case 'podcast':
        return ShelfType.podcast;
      default:
        throw ArgumentError.value(json, 'json', 'Unsupported shelf type');
    }
  }

  @override
  String toJson(ShelfType object) {
    switch (object) {
      case ShelfType.book:
        return 'book';
      case ShelfType.series:
        return 'series';
      case ShelfType.author:
        return 'authors';
      case ShelfType.episode:
        return 'episodes';
      case ShelfType.podcast:
        return 'podcast';
    }
  }
}
