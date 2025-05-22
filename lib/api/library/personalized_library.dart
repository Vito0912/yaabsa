import 'package:buchshelfly/api/library_items/author.dart';
import 'package:buchshelfly/api/library_items/episode.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/api/library_items/series.dart';
import 'package:buchshelfly/util/logger.dart';
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
            tempContinueListening = ShelfEntry<LibraryItem>.fromJson(
              itemJson,
              (json) => LibraryItem.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idRecentlyAdded:
            tempRecentlyAdded = ShelfEntry<LibraryItem>.fromJson(
              itemJson,
              (json) => LibraryItem.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idRecentSeries:
            tempRecentSeries = ShelfEntry<Series>.fromJson(
              itemJson,
              (json) => Series.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idDiscover:
            tempDiscover = ShelfEntry<LibraryItem>.fromJson(
              itemJson,
              (json) => LibraryItem.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idListenAgain:
            tempListenAgain = ShelfEntry<LibraryItem>.fromJson(
              itemJson,
              (json) => LibraryItem.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idNewestAuthors:
            tempNewestAuthors = ShelfEntry<Author>.fromJson(
              itemJson,
              (json) => Author.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idNewestEpisodes:
            tempNewestEpisodes = ShelfEntry<Episode>.fromJson(
              itemJson,
              (json) => Episode.fromJson(json as Map<String, dynamic>),
            );
            break;
          case idContinueSeries:
            tempContinueSeries = ShelfEntry<LibraryItem>.fromJson(
              itemJson,
              (json) => LibraryItem.fromJson(json as Map<String, dynamic>),
            );
            break;
          default:
            logger('Warning: Unknown shelf ID encountered: $id', level: InfoLevel.warning);
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
    );
  }
}

@Freezed(genericArgumentFactories: true)
abstract class ShelfEntry<T> with _$ShelfEntry<T> {
  const factory ShelfEntry({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "label") required String label,
    @JsonKey(name: "labelStringKey") required String labelStringKey,
    @JsonKey(name: "type") required ShelfType type,
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
