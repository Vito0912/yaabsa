// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_in_review_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearInReviewNamedStat _$YearInReviewNamedStatFromJson(Map<String, dynamic> json) =>
    _YearInReviewNamedStat(name: json['name'] as String?, time: _intFromDynamic(json['time']));

Map<String, dynamic> _$YearInReviewNamedStatToJson(_YearInReviewNamedStat instance) => <String, dynamic>{
  'name': instance.name,
  'time': instance.time,
};

_YearInReviewGenreStat _$YearInReviewGenreStatFromJson(Map<String, dynamic> json) =>
    _YearInReviewGenreStat(genre: json['genre'] as String?, time: _intFromDynamic(json['time']));

Map<String, dynamic> _$YearInReviewGenreStatToJson(_YearInReviewGenreStat instance) => <String, dynamic>{
  'genre': instance.genre,
  'time': instance.time,
};

_YearInReviewMonthStat _$YearInReviewMonthStatFromJson(Map<String, dynamic> json) =>
    _YearInReviewMonthStat(month: _intFromDynamic(json['month']), time: _intFromDynamic(json['time']));

Map<String, dynamic> _$YearInReviewMonthStatToJson(_YearInReviewMonthStat instance) => <String, dynamic>{
  'month': instance.month,
  'time': instance.time,
};

_YearInReviewBookStat _$YearInReviewBookStatFromJson(Map<String, dynamic> json) => _YearInReviewBookStat(
  id: json['id'] as String?,
  title: json['title'] as String?,
  duration: _intFromDynamic(json['duration']),
  finishedAt: _intFromDynamic(json['finishedAt']),
);

Map<String, dynamic> _$YearInReviewBookStatToJson(_YearInReviewBookStat instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'duration': instance.duration,
  'finishedAt': instance.finishedAt,
};

_YearInReviewStats _$YearInReviewStatsFromJson(Map<String, dynamic> json) => _YearInReviewStats(
  totalListeningSessions: _intFromDynamic(json['totalListeningSessions']),
  totalListeningTime: _intFromDynamic(json['totalListeningTime']),
  totalBookListeningTime: _intFromDynamic(json['totalBookListeningTime']),
  totalPodcastListeningTime: _intFromDynamic(json['totalPodcastListeningTime']),
  topAuthors:
      (json['topAuthors'] as List<dynamic>?)
          ?.map((e) => YearInReviewNamedStat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <YearInReviewNamedStat>[],
  topGenres:
      (json['topGenres'] as List<dynamic>?)
          ?.map((e) => YearInReviewGenreStat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <YearInReviewGenreStat>[],
  mostListenedNarrator: json['mostListenedNarrator'] == null
      ? null
      : YearInReviewNamedStat.fromJson(json['mostListenedNarrator'] as Map<String, dynamic>),
  mostListenedMonth: json['mostListenedMonth'] == null
      ? null
      : YearInReviewMonthStat.fromJson(json['mostListenedMonth'] as Map<String, dynamic>),
  numBooksFinished: _intFromDynamic(json['numBooksFinished']),
  numBooksListened: _intFromDynamic(json['numBooksListened']),
  longestAudiobookFinished: json['longestAudiobookFinished'] == null
      ? null
      : YearInReviewBookStat.fromJson(json['longestAudiobookFinished'] as Map<String, dynamic>),
  booksWithCovers: (json['booksWithCovers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  finishedBooksWithCovers:
      (json['finishedBooksWithCovers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  numListeningSessions: _intFromDynamic(json['numListeningSessions']),
  numBooksAdded: _intFromDynamic(json['numBooksAdded']),
  numAuthorsAdded: _intFromDynamic(json['numAuthorsAdded']),
  totalBooksAddedSize: _intFromDynamic(json['totalBooksAddedSize']),
  totalBooksAddedDuration: _intFromDynamic(json['totalBooksAddedDuration']),
  booksAddedWithCovers:
      (json['booksAddedWithCovers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  totalBooksSize: _intFromDynamic(json['totalBooksSize']),
  totalBooksDuration: _intFromDynamic(json['totalBooksDuration']),
  numBooks: _intFromDynamic(json['numBooks']),
  topNarrators:
      (json['topNarrators'] as List<dynamic>?)
          ?.map((e) => YearInReviewNamedStat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <YearInReviewNamedStat>[],
);

Map<String, dynamic> _$YearInReviewStatsToJson(_YearInReviewStats instance) => <String, dynamic>{
  'totalListeningSessions': instance.totalListeningSessions,
  'totalListeningTime': instance.totalListeningTime,
  'totalBookListeningTime': instance.totalBookListeningTime,
  'totalPodcastListeningTime': instance.totalPodcastListeningTime,
  'topAuthors': instance.topAuthors,
  'topGenres': instance.topGenres,
  'mostListenedNarrator': instance.mostListenedNarrator,
  'mostListenedMonth': instance.mostListenedMonth,
  'numBooksFinished': instance.numBooksFinished,
  'numBooksListened': instance.numBooksListened,
  'longestAudiobookFinished': instance.longestAudiobookFinished,
  'booksWithCovers': instance.booksWithCovers,
  'finishedBooksWithCovers': instance.finishedBooksWithCovers,
  'numListeningSessions': instance.numListeningSessions,
  'numBooksAdded': instance.numBooksAdded,
  'numAuthorsAdded': instance.numAuthorsAdded,
  'totalBooksAddedSize': instance.totalBooksAddedSize,
  'totalBooksAddedDuration': instance.totalBooksAddedDuration,
  'booksAddedWithCovers': instance.booksAddedWithCovers,
  'totalBooksSize': instance.totalBooksSize,
  'totalBooksDuration': instance.totalBooksDuration,
  'numBooks': instance.numBooks,
  'topNarrators': instance.topNarrators,
};
