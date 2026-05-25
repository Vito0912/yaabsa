import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'year_in_review_stats.freezed.dart';
part 'year_in_review_stats.g.dart';

@freezed
abstract class YearInReviewNamedStat with _$YearInReviewNamedStat {
  const factory YearInReviewNamedStat({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time,
  }) = _YearInReviewNamedStat;

  factory YearInReviewNamedStat.fromJson(Map<String, dynamic> json) => _$YearInReviewNamedStatFromJson(json);
}

@freezed
abstract class YearInReviewGenreStat with _$YearInReviewGenreStat {
  const factory YearInReviewGenreStat({
    @JsonKey(name: 'genre') String? genre,
    @JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time,
  }) = _YearInReviewGenreStat;

  factory YearInReviewGenreStat.fromJson(Map<String, dynamic> json) => _$YearInReviewGenreStatFromJson(json);
}

@freezed
abstract class YearInReviewMonthStat with _$YearInReviewMonthStat {
  const factory YearInReviewMonthStat({
    @JsonKey(name: 'month', fromJson: jsonIntFromDynamic) int? month,
    @JsonKey(name: 'time', fromJson: jsonIntFromDynamic) int? time,
  }) = _YearInReviewMonthStat;

  factory YearInReviewMonthStat.fromJson(Map<String, dynamic> json) => _$YearInReviewMonthStatFromJson(json);
}

@freezed
abstract class YearInReviewBookStat with _$YearInReviewBookStat {
  const factory YearInReviewBookStat({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'duration', fromJson: jsonIntFromDynamic) int? duration,
    @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? finishedAt,
  }) = _YearInReviewBookStat;

  factory YearInReviewBookStat.fromJson(Map<String, dynamic> json) => _$YearInReviewBookStatFromJson(json);
}

@freezed
abstract class YearInReviewStats with _$YearInReviewStats {
  const factory YearInReviewStats({
    @JsonKey(name: 'totalListeningSessions', fromJson: jsonIntFromDynamic) int? totalListeningSessions,
    @JsonKey(name: 'totalListeningTime', fromJson: jsonIntFromDynamic) int? totalListeningTime,
    @JsonKey(name: 'totalBookListeningTime', fromJson: jsonIntFromDynamic) int? totalBookListeningTime,
    @JsonKey(name: 'totalPodcastListeningTime', fromJson: jsonIntFromDynamic) int? totalPodcastListeningTime,
    @JsonKey(name: 'topAuthors') @Default(<YearInReviewNamedStat>[]) List<YearInReviewNamedStat> topAuthors,
    @JsonKey(name: 'topGenres') @Default(<YearInReviewGenreStat>[]) List<YearInReviewGenreStat> topGenres,
    @JsonKey(name: 'mostListenedNarrator') YearInReviewNamedStat? mostListenedNarrator,
    @JsonKey(name: 'mostListenedMonth') YearInReviewMonthStat? mostListenedMonth,
    @JsonKey(name: 'numBooksFinished', fromJson: jsonIntFromDynamic) int? numBooksFinished,
    @JsonKey(name: 'numBooksListened', fromJson: jsonIntFromDynamic) int? numBooksListened,
    @JsonKey(name: 'longestAudiobookFinished') YearInReviewBookStat? longestAudiobookFinished,
    @JsonKey(name: 'booksWithCovers') @Default(<String>[]) List<String> booksWithCovers,
    @JsonKey(name: 'finishedBooksWithCovers') @Default(<String>[]) List<String> finishedBooksWithCovers,
    @JsonKey(name: 'numListeningSessions', fromJson: jsonIntFromDynamic) int? numListeningSessions,
    @JsonKey(name: 'numBooksAdded', fromJson: jsonIntFromDynamic) int? numBooksAdded,
    @JsonKey(name: 'numAuthorsAdded', fromJson: jsonIntFromDynamic) int? numAuthorsAdded,
    @JsonKey(name: 'totalBooksAddedSize', fromJson: jsonIntFromDynamic) int? totalBooksAddedSize,
    @JsonKey(name: 'totalBooksAddedDuration', fromJson: jsonIntFromDynamic) int? totalBooksAddedDuration,
    @JsonKey(name: 'booksAddedWithCovers') @Default(<String>[]) List<String> booksAddedWithCovers,
    @JsonKey(name: 'totalBooksSize', fromJson: jsonIntFromDynamic) int? totalBooksSize,
    @JsonKey(name: 'totalBooksDuration', fromJson: jsonIntFromDynamic) int? totalBooksDuration,
    @JsonKey(name: 'numBooks', fromJson: jsonIntFromDynamic) int? numBooks,
    @JsonKey(name: 'topNarrators') @Default(<YearInReviewNamedStat>[]) List<YearInReviewNamedStat> topNarrators,
  }) = _YearInReviewStats;

  factory YearInReviewStats.fromJson(Map<String, dynamic> json) => _$YearInReviewStatsFromJson(json);
}
