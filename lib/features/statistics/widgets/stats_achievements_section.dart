import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/models/advanced_listening_analytics_state.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class StatsAchievementsSection extends StatelessWidget {
  const StatsAchievementsSection({
    super.key,
    required this.stats,
    required this.sessionAnalytics,
    required this.onRetrySessionAnalytics,
  });

  final UserListeningStats stats;
  final AdvancedListeningAnalyticsState sessionAnalytics;
  final VoidCallback onRetrySessionAnalytics;

  @override
  Widget build(BuildContext context) {
    final totalSeconds = stats.totalTime ?? 0;
    final itemCount = stats.items?.length ?? 0;
    final activeDates = _activeDates(stats);
    final activeDays = activeDates.length;
    final longestStreak = _longestStreak(activeDates);
    final detailedStats = sessionAnalytics.stats;
    final listeningJourneyDays = detailedStats == null
        ? 0
        : _journeyDays(detailedStats.firstSessionAt, detailedStats.lastSessionAt);
    final achievements = <_AchievementProgress>[
      _AchievementProgress.resolve(
        title: context.l10n.fieldListeningTime,
        icon: Icons.headphones_rounded,
        current: totalSeconds,
        currentLabel: formatListeningSeconds(totalSeconds),
        levels: const [
          _AchievementLevel(threshold: 3600, label: 'statsAchievementFirstHour'),
          _AchievementLevel(threshold: 36000, label: 'statsAchievementAllDayListener'),
          _AchievementLevel(threshold: 360000, label: 'statsAchievementCenturyClub'),
          _AchievementLevel(threshold: 1800000, label: 'statsAchievementTimeTraveler'),
          _AchievementLevel(threshold: 3600000, label: 'statsAchievementListeningLegend'),
          _AchievementLevel(threshold: 7200000, label: 'statsAchievementMasterOfTime'),
        ],
        nextValueLabel: (value) => formatListeningSeconds(value),
      ),
      _AchievementProgress.resolve(
        title: context.l10n.fieldItemsExplored,
        icon: Icons.explore_rounded,
        current: itemCount.toDouble(),
        currentLabel: context.l10n.itemCount(itemCount),
        levels: const [
          _AchievementLevel(threshold: 1, label: 'statsAchievementFirstDiscovery'),
          _AchievementLevel(threshold: 10, label: 'statsAchievementCuriousListener'),
          _AchievementLevel(threshold: 50, label: 'statsAchievementShelfExplorer'),
          _AchievementLevel(threshold: 100, label: 'statsAchievementLibraryRegular'),
          _AchievementLevel(threshold: 250, label: 'statsAchievementCatalogConqueror'),
          _AchievementLevel(threshold: 500, label: 'statsAchievementWorldOfStories'),
        ],
        nextValueLabel: (value) => context.l10n.itemCount(value.round()),
      ),
      _AchievementProgress.resolve(
        title: context.l10n.fieldActiveDays,
        icon: Icons.event_available_rounded,
        current: activeDays.toDouble(),
        currentLabel: context.l10n.dayCount(activeDays),
        levels: const [
          _AchievementLevel(threshold: 1, label: 'statsAchievementDayOne'),
          _AchievementLevel(threshold: 7, label: 'statsAchievementWeekOfStories'),
          _AchievementLevel(threshold: 30, label: 'statsAchievementMonthlyHabit'),
          _AchievementLevel(threshold: 100, label: 'statsAchievementDedicatedListener'),
          _AchievementLevel(threshold: 365, label: 'statsAchievementYearRoundListener'),
          _AchievementLevel(threshold: 1000, label: 'statsAchievementEverydayExplorer'),
        ],
        nextValueLabel: (value) => context.l10n.dayCount(value.round()),
      ),
      _AchievementProgress.resolve(
        title: context.l10n.fieldLongestStreak,
        icon: Icons.local_fire_department_rounded,
        current: longestStreak.toDouble(),
        currentLabel: context.l10n.dayCount(longestStreak),
        levels: const [
          _AchievementLevel(threshold: 2, label: 'statsAchievementBackForMore'),
          _AchievementLevel(threshold: 3, label: 'statsAchievementOnARoll'),
          _AchievementLevel(threshold: 7, label: 'statsAchievementPerfectWeek'),
          _AchievementLevel(threshold: 14, label: 'statsAchievementFortnightFocus'),
          _AchievementLevel(threshold: 30, label: 'statsAchievementUnstoppable'),
          _AchievementLevel(threshold: 100, label: 'statsAchievementStoryMarathon'),
        ],
        nextValueLabel: (value) => context.l10n.dayCount(value.round()),
      ),
      if (detailedStats != null) ...[
        _AchievementProgress.resolve(
          title: context.l10n.fieldSessions,
          icon: Icons.play_circle_rounded,
          current: detailedStats.totalSessions.toDouble(),
          currentLabel: context.l10n.sessionCount(detailedStats.totalSessions),
          levels: const [
            _AchievementLevel(threshold: 1, label: 'statsAchievementPressPlay'),
            _AchievementLevel(threshold: 10, label: 'statsAchievementGettingComfortable'),
            _AchievementLevel(threshold: 50, label: 'statsAchievementRegularListener'),
            _AchievementLevel(threshold: 250, label: 'statsAchievementSessionSpecialist'),
            _AchievementLevel(threshold: 1000, label: 'statsAchievementAlwaysListening'),
            _AchievementLevel(threshold: 5000, label: 'statsAchievementPlaybackMaster'),
          ],
          nextValueLabel: (value) => context.l10n.sessionCount(value.round()),
        ),
        _AchievementProgress.resolve(
          title: context.l10n.fieldAuthorsDiscovered,
          icon: Icons.people_alt_rounded,
          current: detailedStats.uniqueAuthors.toDouble(),
          currentLabel: context.l10n.authorCount(detailedStats.uniqueAuthors),
          levels: const [
            _AchievementLevel(threshold: 1, label: 'statsAchievementNewVoice'),
            _AchievementLevel(threshold: 5, label: 'statsAchievementAuthorSampler'),
            _AchievementLevel(threshold: 20, label: 'statsAchievementLiteraryWanderer'),
            _AchievementLevel(threshold: 50, label: 'statsAchievementVoiceCollector'),
            _AchievementLevel(threshold: 100, label: 'statsAchievementAuthorAuthority'),
            _AchievementLevel(threshold: 250, label: 'statsAchievementPantheonOfVoices'),
          ],
          nextValueLabel: (value) => context.l10n.authorCount(value.round()),
        ),
        _AchievementProgress.resolve(
          title: context.l10n.fieldLongestSession,
          icon: Icons.hourglass_top_rounded,
          current: detailedStats.longestSessionTime,
          currentLabel: formatListeningSeconds(detailedStats.longestSessionTime),
          levels: const [
            _AchievementLevel(threshold: 900, label: 'statsAchievementSettlingIn'),
            _AchievementLevel(threshold: 1800, label: 'statsAchievementHalfHourHero'),
            _AchievementLevel(threshold: 3600, label: 'statsAchievementDeepListener'),
            _AchievementLevel(threshold: 7200, label: 'statsAchievementLostInAStory'),
            _AchievementLevel(threshold: 14400, label: 'statsAchievementEpicSession'),
            _AchievementLevel(threshold: 28800, label: 'statsAchievementEnduranceLegend'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: context.l10n.fieldAverageSession,
          icon: Icons.timer_rounded,
          current: detailedStats.averageSessionTime,
          currentLabel: formatListeningSeconds(detailedStats.averageSessionTime),
          levels: const [
            _AchievementLevel(threshold: 300, label: 'statsAchievementQuickChapter'),
            _AchievementLevel(threshold: 900, label: 'statsAchievementFocusedListener'),
            _AchievementLevel(threshold: 1800, label: 'statsAchievementInTheZone'),
            _AchievementLevel(threshold: 3600, label: 'statsAchievementLongformLover'),
            _AchievementLevel(threshold: 7200, label: 'statsAchievementImmersiveListener'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: context.l10n.fieldBookListening,
          icon: Icons.menu_book_rounded,
          current: detailedStats.totalBookListeningTime,
          currentLabel: formatListeningSeconds(detailedStats.totalBookListeningTime),
          levels: const [
            _AchievementLevel(threshold: 3600, label: 'statsAchievementBookBeginner'),
            _AchievementLevel(threshold: 36000, label: 'statsAchievementChapterChaser'),
            _AchievementLevel(threshold: 180000, label: 'statsAchievementBookworm'),
            _AchievementLevel(threshold: 360000, label: 'statsAchievementAudioBibliophile'),
            _AchievementLevel(threshold: 1800000, label: 'statsAchievementLivingLibrary'),
            _AchievementLevel(threshold: 3600000, label: 'statsAchievementKeeperOfStories'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: context.l10n.fieldPodcastListening,
          icon: Icons.podcasts_rounded,
          current: detailedStats.totalPodcastListeningTime,
          currentLabel: formatListeningSeconds(detailedStats.totalPodcastListeningTime),
          levels: const [
            _AchievementLevel(threshold: 3600, label: 'statsAchievementFirstEpisode'),
            _AchievementLevel(threshold: 18000, label: 'statsAchievementPodcastCurious'),
            _AchievementLevel(threshold: 72000, label: 'statsAchievementEpisodeExplorer'),
            _AchievementLevel(threshold: 180000, label: 'statsAchievementFeedFollower'),
            _AchievementLevel(threshold: 360000, label: 'statsAchievementPodcastPro'),
            _AchievementLevel(threshold: 1800000, label: 'statsAchievementAirwaveArchivist'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: context.l10n.fieldListeningJourney,
          icon: Icons.route_rounded,
          current: listeningJourneyDays.toDouble(),
          currentLabel: context.l10n.dayCount(listeningJourneyDays),
          levels: const [
            _AchievementLevel(threshold: 1, label: 'statsAchievementJourneyBegins'),
            _AchievementLevel(threshold: 7, label: 'statsAchievementOneWeekIn'),
            _AchievementLevel(threshold: 30, label: 'statsAchievementMonthOfStories'),
            _AchievementLevel(threshold: 180, label: 'statsAchievementSeasonedListener'),
            _AchievementLevel(threshold: 365, label: 'statsAchievementAnniversary'),
            _AchievementLevel(threshold: 1000, label: 'statsAchievementLongtimeCompanion'),
          ],
          nextValueLabel: (value) => context.l10n.dayCount(value.round()),
        ),
      ],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final columns = constraints.maxWidth >= 760
            ? 4
            : constraints.maxWidth >= 480
            ? 2
            : 1;
        final cardWidth = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final achievement in achievements)
                  SizedBox(
                    width: cardWidth,
                    child: _AchievementCard(achievement: achievement),
                  ),
              ],
            ),
            if (sessionAnalytics.isLoading) ...[
              const SizedBox(height: 16),
              _DetailedAchievementsLoading(state: sessionAnalytics),
            ] else if (sessionAnalytics.errorMessage != null && detailedStats == null) ...[
              const SizedBox(height: 16),
              _DetailedAchievementsError(onRetry: onRetrySessionAnalytics),
            ],
          ],
        );
      },
    );
  }

  List<DateTime> _activeDates(UserListeningStats stats) {
    final uniqueDays = <int, DateTime>{};
    for (final entry in stats.days?.entries ?? const <MapEntry<String, double>>[]) {
      if (entry.value <= 0) continue;
      final parsed = DateTime.tryParse(entry.key);
      if (parsed == null) continue;
      final normalized = DateTime.utc(parsed.year, parsed.month, parsed.day);
      uniqueDays[normalized.millisecondsSinceEpoch] = normalized;
    }
    return uniqueDays.values.toList(growable: false)..sort();
  }

  int _longestStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;
    var current = 1;
    var longest = 1;
    for (var index = 1; index < dates.length; index++) {
      if (dates[index].difference(dates[index - 1]).inDays == 1) {
        current++;
        if (current > longest) longest = current;
      } else {
        current = 1;
      }
    }
    return longest;
  }

  int _journeyDays(int? firstSessionAt, int? lastSessionAt) {
    if (firstSessionAt == null || lastSessionAt == null || lastSessionAt < firstSessionAt) return 0;
    return DateTime.fromMillisecondsSinceEpoch(lastSessionAt)
            .difference(DateTime.fromMillisecondsSinceEpoch(firstSessionAt))
            .inDays +
        1;
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final _AchievementProgress achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = _achievementAccent(colors, achievement.colorIndex);
    return Container(
      constraints: const BoxConstraints(minHeight: 176),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.38)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(accent.withValues(alpha: 0.14), colors.surfaceContainerHighest),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(achievement.icon, color: accent),
              ),
              const Spacer(),
              if (achievement.unlockedLevel != null) Icon(Icons.verified_rounded, color: accent),
            ],
          ),
          const SizedBox(height: 14),
          Text(achievement.title, style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant)),
          const SizedBox(height: 3),
          Text(
            achievement.unlockedLevel == null
                ? context.l10n.statsAchievementNotUnlocked
                : _achievementName(context.l10n, achievement.unlockedLevel!.label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(achievement.currentLabel, style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
          const SizedBox(height: 14),
          _AchievementMilestoneStrip(achievement: achievement, accent: accent),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: YaabsaLinearProgressIndicator(
              value: achievement.progress,
              minHeight: 7,
              color: accent,
              backgroundColor: accent.withValues(alpha: 0.14),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            achievement.nextLevel == null
                ? context.l10n.statsAchievementHighestReached
                : context.l10n.statsAchievementNext(
                    _achievementName(context.l10n, achievement.nextLevel!.label),
                    achievement.nextValueLabel,
                  ),
            softWrap: true,
            style: theme.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _AchievementMilestoneStrip extends StatelessWidget {
  const _AchievementMilestoneStrip({required this.achievement, required this.accent});

  final _AchievementProgress achievement;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < achievement.totalStages; index++) ...[
          Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: index < achievement.unlockedStage
                    ? accent
                    : index == achievement.unlockedStage
                    ? accent.withValues(alpha: 0.5)
                    : accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          if (index != achievement.totalStages - 1) const SizedBox(width: 3),
        ],
      ],
    );
  }
}

class _DetailedAchievementsLoading extends StatelessWidget {
  const _DetailedAchievementsLoading({required this.state});

  final AdvancedListeningAnalyticsState state;

  @override
  Widget build(BuildContext context) {
    final progress = state.progress;
    final detail = progress == null
        ? context.l10n.statsLoadingSessionHistory
        : context.l10n.statsUnlockingAchievements(context.l10n.sessionCount(progress.loadedSessions));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YaabsaLinearProgressIndicator(value: progress?.progress),
        const SizedBox(height: 8),
        Text(detail, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _DetailedAchievementsError extends StatelessWidget {
  const _DetailedAchievementsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: Text(context.l10n.statsRetryAchievements),
      ),
    );
  }
}

class _AchievementLevel {
  const _AchievementLevel({required this.threshold, required this.label});

  final double threshold;
  final String label;
}

class _AchievementProgress {
  const _AchievementProgress({
    required this.title,
    required this.icon,
    required this.currentLabel,
    required this.unlockedLevel,
    required this.nextLevel,
    required this.nextValueLabel,
    required this.progress,
    required this.unlockedStage,
    required this.totalStages,
    required this.colorIndex,
  });

  factory _AchievementProgress.resolve({
    required String title,
    required IconData icon,
    required double current,
    required String currentLabel,
    required List<_AchievementLevel> levels,
    required String Function(double value) nextValueLabel,
    int? colorIndex,
  }) {
    _AchievementLevel? unlocked;
    _AchievementLevel? next;
    for (final level in levels) {
      if (current >= level.threshold) {
        unlocked = level;
      } else {
        next = level;
        break;
      }
    }

    final previousThreshold = unlocked?.threshold ?? 0;
    final targetThreshold = next?.threshold ?? previousThreshold;
    final progress = next == null
        ? 1.0
        : ((current - previousThreshold) / (targetThreshold - previousThreshold)).clamp(0.0, 1.0);

    return _AchievementProgress(
      title: title,
      icon: icon,
      currentLabel: currentLabel,
      unlockedLevel: unlocked,
      nextLevel: next,
      nextValueLabel: next == null ? '' : nextValueLabel(next.threshold),
      progress: progress,
      unlockedStage: unlocked == null ? 0 : levels.indexOf(unlocked) + 1,
      totalStages: levels.length,
      colorIndex: colorIndex ?? _colorIndexForTitle(title),
    );
  }

  final String title;
  final IconData icon;
  final String currentLabel;
  final _AchievementLevel? unlockedLevel;
  final _AchievementLevel? nextLevel;
  final String nextValueLabel;
  final double progress;
  final int unlockedStage;
  final int totalStages;
  final int colorIndex;
}

int _colorIndexForTitle(String title) {
  var total = 0;
  for (final codeUnit in title.codeUnits) {
    total += codeUnit;
  }
  return total;
}

Color _achievementAccent(ColorScheme colors, int colorIndex) {
  final palette = <Color>[
    colors.primary,
    colors.secondary,
    colors.tertiary,
    colors.error,
    colors.inversePrimary,
    colors.onSecondaryContainer,
    colors.onTertiaryContainer,
    colors.onErrorContainer,
  ];
  return palette[colorIndex % palette.length];
}

String _achievementName(AppLocalizations l10n, String key) {
  return switch (key) {
    'statsAchievementAirwaveArchivist' => l10n.statsAchievementAirwaveArchivist,
    'statsAchievementAllDayListener' => l10n.statsAchievementAllDayListener,
    'statsAchievementAlwaysListening' => l10n.statsAchievementAlwaysListening,
    'statsAchievementAnniversary' => l10n.statsAchievementAnniversary,
    'statsAchievementAudioBibliophile' => l10n.statsAchievementAudioBibliophile,
    'statsAchievementAuthorAuthority' => l10n.statsAchievementAuthorAuthority,
    'statsAchievementAuthorSampler' => l10n.statsAchievementAuthorSampler,
    'statsAchievementBackForMore' => l10n.statsAchievementBackForMore,
    'statsAchievementBookBeginner' => l10n.statsAchievementBookBeginner,
    'statsAchievementBookworm' => l10n.statsAchievementBookworm,
    'statsAchievementCatalogConqueror' => l10n.statsAchievementCatalogConqueror,
    'statsAchievementCenturyClub' => l10n.statsAchievementCenturyClub,
    'statsAchievementChapterChaser' => l10n.statsAchievementChapterChaser,
    'statsAchievementCuriousListener' => l10n.statsAchievementCuriousListener,
    'statsAchievementDayOne' => l10n.statsAchievementDayOne,
    'statsAchievementDedicatedListener' => l10n.statsAchievementDedicatedListener,
    'statsAchievementDeepListener' => l10n.statsAchievementDeepListener,
    'statsAchievementEnduranceLegend' => l10n.statsAchievementEnduranceLegend,
    'statsAchievementEpicSession' => l10n.statsAchievementEpicSession,
    'statsAchievementEpisodeExplorer' => l10n.statsAchievementEpisodeExplorer,
    'statsAchievementEverydayExplorer' => l10n.statsAchievementEverydayExplorer,
    'statsAchievementFeedFollower' => l10n.statsAchievementFeedFollower,
    'statsAchievementFirstDiscovery' => l10n.statsAchievementFirstDiscovery,
    'statsAchievementFirstEpisode' => l10n.statsAchievementFirstEpisode,
    'statsAchievementFirstHour' => l10n.statsAchievementFirstHour,
    'statsAchievementFocusedListener' => l10n.statsAchievementFocusedListener,
    'statsAchievementFortnightFocus' => l10n.statsAchievementFortnightFocus,
    'statsAchievementGettingComfortable' => l10n.statsAchievementGettingComfortable,
    'statsAchievementHalfHourHero' => l10n.statsAchievementHalfHourHero,
    'statsAchievementImmersiveListener' => l10n.statsAchievementImmersiveListener,
    'statsAchievementInTheZone' => l10n.statsAchievementInTheZone,
    'statsAchievementJourneyBegins' => l10n.statsAchievementJourneyBegins,
    'statsAchievementKeeperOfStories' => l10n.statsAchievementKeeperOfStories,
    'statsAchievementLibraryRegular' => l10n.statsAchievementLibraryRegular,
    'statsAchievementListeningLegend' => l10n.statsAchievementListeningLegend,
    'statsAchievementLiteraryWanderer' => l10n.statsAchievementLiteraryWanderer,
    'statsAchievementLivingLibrary' => l10n.statsAchievementLivingLibrary,
    'statsAchievementLongformLover' => l10n.statsAchievementLongformLover,
    'statsAchievementLongtimeCompanion' => l10n.statsAchievementLongtimeCompanion,
    'statsAchievementLostInAStory' => l10n.statsAchievementLostInAStory,
    'statsAchievementMasterOfTime' => l10n.statsAchievementMasterOfTime,
    'statsAchievementMonthOfStories' => l10n.statsAchievementMonthOfStories,
    'statsAchievementMonthlyHabit' => l10n.statsAchievementMonthlyHabit,
    'statsAchievementNewVoice' => l10n.statsAchievementNewVoice,
    'statsAchievementOnARoll' => l10n.statsAchievementOnARoll,
    'statsAchievementOneWeekIn' => l10n.statsAchievementOneWeekIn,
    'statsAchievementPantheonOfVoices' => l10n.statsAchievementPantheonOfVoices,
    'statsAchievementPerfectWeek' => l10n.statsAchievementPerfectWeek,
    'statsAchievementPlaybackMaster' => l10n.statsAchievementPlaybackMaster,
    'statsAchievementPodcastCurious' => l10n.statsAchievementPodcastCurious,
    'statsAchievementPodcastPro' => l10n.statsAchievementPodcastPro,
    'statsAchievementPressPlay' => l10n.statsAchievementPressPlay,
    'statsAchievementQuickChapter' => l10n.statsAchievementQuickChapter,
    'statsAchievementRegularListener' => l10n.statsAchievementRegularListener,
    'statsAchievementSeasonedListener' => l10n.statsAchievementSeasonedListener,
    'statsAchievementSessionSpecialist' => l10n.statsAchievementSessionSpecialist,
    'statsAchievementSettlingIn' => l10n.statsAchievementSettlingIn,
    'statsAchievementShelfExplorer' => l10n.statsAchievementShelfExplorer,
    'statsAchievementStoryMarathon' => l10n.statsAchievementStoryMarathon,
    'statsAchievementTimeTraveler' => l10n.statsAchievementTimeTraveler,
    'statsAchievementUnstoppable' => l10n.statsAchievementUnstoppable,
    'statsAchievementVoiceCollector' => l10n.statsAchievementVoiceCollector,
    'statsAchievementWeekOfStories' => l10n.statsAchievementWeekOfStories,
    'statsAchievementWorldOfStories' => l10n.statsAchievementWorldOfStories,
    'statsAchievementYearRoundListener' => l10n.statsAchievementYearRoundListener,
    _ => key,
  };
}
