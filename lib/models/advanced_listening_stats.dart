import 'package:freezed_annotation/freezed_annotation.dart';

part 'advanced_listening_stats.freezed.dart';

@freezed
abstract class AdvancedTopItem with _$AdvancedTopItem {
  const factory AdvancedTopItem({
    required String id,
    required String title,
    required String author,
    required String mediaType,
    required double totalListeningTime,
    required int sessions,
  }) = _AdvancedTopItem;
}

@freezed
abstract class AdvancedTopEntity with _$AdvancedTopEntity {
  const factory AdvancedTopEntity({required String name, required double totalListeningTime, required int sessions}) =
      _AdvancedTopEntity;
}

@freezed
abstract class AdvancedTimeBucket with _$AdvancedTimeBucket {
  const factory AdvancedTimeBucket({required String label, required double totalListeningTime}) = _AdvancedTimeBucket;
}

@freezed
abstract class AdvancedListeningStats with _$AdvancedListeningStats {
  const factory AdvancedListeningStats({
    required int loadedPages,
    required int totalSessions,
    required int totalAvailableSessions,
    required double totalListeningTime,
    required double totalBookListeningTime,
    required double totalPodcastListeningTime,
    required double averageSessionTime,
    required double medianSessionTime,
    required double longestSessionTime,
    required int uniqueItems,
    required int uniqueAuthors,
    required int longestStreakDays,
    required int? firstSessionAt,
    required int? lastSessionAt,
    String? favoriteWeekday,
    int? favoriteHour,
    @Default(<AdvancedTopItem>[]) List<AdvancedTopItem> topItems,
    @Default(<AdvancedTopEntity>[]) List<AdvancedTopEntity> topAuthors,
    @Default(<AdvancedTimeBucket>[]) List<AdvancedTimeBucket> weekdayBreakdown,
    @Default(<AdvancedTimeBucket>[]) List<AdvancedTimeBucket> hourlyBreakdown,
    @Default(<AdvancedTimeBucket>[]) List<AdvancedTimeBucket> monthlyBreakdown,
  }) = _AdvancedListeningStats;
}
