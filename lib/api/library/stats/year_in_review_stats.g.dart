// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_in_review_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_YearInReviewNamedStat _$YearInReviewNamedStatFromJson(Map<String, dynamic> json) =>
    _YearInReviewNamedStat(name: json['name'] as String?, time: jsonIntFromDynamic(json['time']));

Map<String, dynamic> _$YearInReviewNamedStatToJson(_YearInReviewNamedStat instance) => <String, dynamic>{
  'name': instance.name,
  'time': instance.time,
};

_YearInReviewGenreStat _$YearInReviewGenreStatFromJson(Map<String, dynamic> json) =>
    _YearInReviewGenreStat(genre: json['genre'] as String?, time: jsonIntFromDynamic(json['time']));

Map<String, dynamic> _$YearInReviewGenreStatToJson(_YearInReviewGenreStat instance) => <String, dynamic>{
  'genre': instance.genre,
  'time': instance.time,
};

_YearInReviewMonthStat _$YearInReviewMonthStatFromJson(Map<String, dynamic> json) =>
    _YearInReviewMonthStat(month: jsonIntFromDynamic(json['month']), time: jsonIntFromDynamic(json['time']));

Map<String, dynamic> _$YearInReviewMonthStatToJson(_YearInReviewMonthStat instance) => <String, dynamic>{
  'month': instance.month,
  'time': instance.time,
};

_YearInReviewBookStat _$YearInReviewBookStatFromJson(Map<String, dynamic> json) => _YearInReviewBookStat(
  id: json['id'] as String?,
  title: json['title'] as String?,
  duration: jsonIntFromDynamic(json['duration']),
  finishedAt: jsonIntFromDynamic(json['finishedAt']),
);

Map<String, dynamic> _$YearInReviewBookStatToJson(_YearInReviewBookStat instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'duration': instance.duration,
  'finishedAt': instance.finishedAt,
};

_YearInReviewStats _$YearInReviewStatsFromJson(Map<String, dynamic> json) => _YearInReviewStats(
  totalListeningSessions: jsonIntFromDynamic(json['totalListeningSessions']),
  totalListeningTime: jsonIntFromDynamic(json['totalListeningTime']),
  totalBookListeningTime: jsonIntFromDynamic(json['totalBookListeningTime']),
  totalPodcastListeningTime: jsonIntFromDynamic(json['totalPodcastListeningTime']),
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
  numBooksFinished: jsonIntFromDynamic(json['numBooksFinished']),
  numBooksListened: jsonIntFromDynamic(json['numBooksListened']),
  longestAudiobookFinished: json['longestAudiobookFinished'] == null
      ? null
      : YearInReviewBookStat.fromJson(json['longestAudiobookFinished'] as Map<String, dynamic>),
  booksWithCovers: (json['booksWithCovers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  finishedBooksWithCovers:
      (json['finishedBooksWithCovers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  numListeningSessions: jsonIntFromDynamic(json['numListeningSessions']),
  numBooksAdded: jsonIntFromDynamic(json['numBooksAdded']),
  numAuthorsAdded: jsonIntFromDynamic(json['numAuthorsAdded']),
  totalBooksAddedSize: jsonIntFromDynamic(json['totalBooksAddedSize']),
  totalBooksAddedDuration: jsonIntFromDynamic(json['totalBooksAddedDuration']),
  booksAddedWithCovers:
      (json['booksAddedWithCovers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  totalBooksSize: jsonIntFromDynamic(json['totalBooksSize']),
  totalBooksDuration: jsonIntFromDynamic(json['totalBooksDuration']),
  numBooks: jsonIntFromDynamic(json['numBooks']),
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
