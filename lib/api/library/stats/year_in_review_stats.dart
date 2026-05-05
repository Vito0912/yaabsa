import 'package:freezed_annotation/freezed_annotation.dart';

part 'year_in_review_stats.freezed.dart';
part 'year_in_review_stats.g.dart';

@freezed
abstract class YearInReviewNamedStat with _$YearInReviewNamedStat {
  const factory YearInReviewNamedStat({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'time', fromJson: _intFromDynamic) int? time,
  }) = _YearInReviewNamedStat;

  factory YearInReviewNamedStat.fromJson(Map<String, dynamic> json) => _$YearInReviewNamedStatFromJson(json);
}

@freezed
abstract class YearInReviewGenreStat with _$YearInReviewGenreStat {
  const factory YearInReviewGenreStat({
    @JsonKey(name: 'genre') String? genre,
    @JsonKey(name: 'time', fromJson: _intFromDynamic) int? time,
  }) = _YearInReviewGenreStat;

  factory YearInReviewGenreStat.fromJson(Map<String, dynamic> json) => _$YearInReviewGenreStatFromJson(json);
}

@freezed
abstract class YearInReviewMonthStat with _$YearInReviewMonthStat {
  const factory YearInReviewMonthStat({
    @JsonKey(name: 'month', fromJson: _intFromDynamic) int? month,
    @JsonKey(name: 'time', fromJson: _intFromDynamic) int? time,
  }) = _YearInReviewMonthStat;

  factory YearInReviewMonthStat.fromJson(Map<String, dynamic> json) => _$YearInReviewMonthStatFromJson(json);
}

@freezed
abstract class YearInReviewBookStat with _$YearInReviewBookStat {
  const factory YearInReviewBookStat({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'duration', fromJson: _intFromDynamic) int? duration,
    @JsonKey(name: 'finishedAt', fromJson: _intFromDynamic) int? finishedAt,
  }) = _YearInReviewBookStat;

  factory YearInReviewBookStat.fromJson(Map<String, dynamic> json) => _$YearInReviewBookStatFromJson(json);
}

@freezed
abstract class YearInReviewStats with _$YearInReviewStats {
  const factory YearInReviewStats({
    @JsonKey(name: 'totalListeningSessions', fromJson: _intFromDynamic) int? totalListeningSessions,
    @JsonKey(name: 'totalListeningTime', fromJson: _intFromDynamic) int? totalListeningTime,
    @JsonKey(name: 'totalBookListeningTime', fromJson: _intFromDynamic) int? totalBookListeningTime,
    @JsonKey(name: 'totalPodcastListeningTime', fromJson: _intFromDynamic) int? totalPodcastListeningTime,
    @JsonKey(name: 'topAuthors') @Default(<YearInReviewNamedStat>[]) List<YearInReviewNamedStat> topAuthors,
    @JsonKey(name: 'topGenres') @Default(<YearInReviewGenreStat>[]) List<YearInReviewGenreStat> topGenres,
    @JsonKey(name: 'mostListenedNarrator') YearInReviewNamedStat? mostListenedNarrator,
    @JsonKey(name: 'mostListenedMonth') YearInReviewMonthStat? mostListenedMonth,
    @JsonKey(name: 'numBooksFinished', fromJson: _intFromDynamic) int? numBooksFinished,
    @JsonKey(name: 'numBooksListened', fromJson: _intFromDynamic) int? numBooksListened,
    @JsonKey(name: 'longestAudiobookFinished') YearInReviewBookStat? longestAudiobookFinished,
    @JsonKey(name: 'booksWithCovers') @Default(<String>[]) List<String> booksWithCovers,
    @JsonKey(name: 'finishedBooksWithCovers') @Default(<String>[]) List<String> finishedBooksWithCovers,
    @JsonKey(name: 'numListeningSessions', fromJson: _intFromDynamic) int? numListeningSessions,
    @JsonKey(name: 'numBooksAdded', fromJson: _intFromDynamic) int? numBooksAdded,
    @JsonKey(name: 'numAuthorsAdded', fromJson: _intFromDynamic) int? numAuthorsAdded,
    @JsonKey(name: 'totalBooksAddedSize', fromJson: _intFromDynamic) int? totalBooksAddedSize,
    @JsonKey(name: 'totalBooksAddedDuration', fromJson: _intFromDynamic) int? totalBooksAddedDuration,
    @JsonKey(name: 'booksAddedWithCovers') @Default(<String>[]) List<String> booksAddedWithCovers,
    @JsonKey(name: 'totalBooksSize', fromJson: _intFromDynamic) int? totalBooksSize,
    @JsonKey(name: 'totalBooksDuration', fromJson: _intFromDynamic) int? totalBooksDuration,
    @JsonKey(name: 'numBooks', fromJson: _intFromDynamic) int? numBooks,
    @JsonKey(name: 'topNarrators') @Default(<YearInReviewNamedStat>[]) List<YearInReviewNamedStat> topNarrators,
  }) = _YearInReviewStats;

  factory YearInReviewStats.fromJson(Map<String, dynamic> json) => _$YearInReviewStatsFromJson(json);
}

int? _intFromDynamic(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    final parsedInt = int.tryParse(value);
    if (parsedInt != null) {
      return parsedInt;
    }

    final parsedDouble = double.tryParse(value);
    if (parsedDouble != null) {
      return parsedDouble.toInt();
    }
  }

  return null;
}
