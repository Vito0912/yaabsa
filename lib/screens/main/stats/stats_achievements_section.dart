import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/models/advanced_listening_analytics_state.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

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
    final achievements = <_AchievementProgress>[
      _AchievementProgress.resolve(
        title: 'Listening time',
        icon: Icons.headphones_rounded,
        current: totalSeconds,
        currentLabel: formatListeningSeconds(totalSeconds),
        levels: const [
          _AchievementLevel(threshold: 3600, label: 'First Hour'),
          _AchievementLevel(threshold: 36000, label: 'All Day Listener'),
          _AchievementLevel(threshold: 360000, label: 'Century Club'),
          _AchievementLevel(threshold: 1800000, label: 'Time Traveler'),
          _AchievementLevel(threshold: 3600000, label: 'Listening Legend'),
          _AchievementLevel(threshold: 7200000, label: 'Master of Time'),
        ],
        nextValueLabel: (value) => formatListeningSeconds(value),
      ),
      _AchievementProgress.resolve(
        title: 'Items explored',
        icon: Icons.explore_rounded,
        current: itemCount.toDouble(),
        currentLabel: '$itemCount items',
        levels: const [
          _AchievementLevel(threshold: 1, label: 'First Discovery'),
          _AchievementLevel(threshold: 10, label: 'Curious Listener'),
          _AchievementLevel(threshold: 50, label: 'Shelf Explorer'),
          _AchievementLevel(threshold: 100, label: 'Library Regular'),
          _AchievementLevel(threshold: 250, label: 'Catalog Conqueror'),
          _AchievementLevel(threshold: 500, label: 'World of Stories'),
        ],
        nextValueLabel: (value) => '${value.round()} items',
      ),
      _AchievementProgress.resolve(
        title: 'Active days',
        icon: Icons.event_available_rounded,
        current: activeDays.toDouble(),
        currentLabel: '$activeDays days',
        levels: const [
          _AchievementLevel(threshold: 1, label: 'Day One'),
          _AchievementLevel(threshold: 7, label: 'A Week of Stories'),
          _AchievementLevel(threshold: 30, label: 'Monthly Habit'),
          _AchievementLevel(threshold: 100, label: 'Dedicated Listener'),
          _AchievementLevel(threshold: 365, label: 'Year-Round Listener'),
          _AchievementLevel(threshold: 1000, label: 'Everyday Explorer'),
        ],
        nextValueLabel: (value) => '${value.round()} days',
      ),
      _AchievementProgress.resolve(
        title: 'Longest streak',
        icon: Icons.local_fire_department_rounded,
        current: longestStreak.toDouble(),
        currentLabel: '$longestStreak days',
        levels: const [
          _AchievementLevel(threshold: 2, label: 'Back for More'),
          _AchievementLevel(threshold: 3, label: 'On a Roll'),
          _AchievementLevel(threshold: 7, label: 'Perfect Week'),
          _AchievementLevel(threshold: 14, label: 'Fortnight Focus'),
          _AchievementLevel(threshold: 30, label: 'Unstoppable'),
          _AchievementLevel(threshold: 100, label: 'Story Marathon'),
        ],
        nextValueLabel: (value) => '${value.round()} days',
      ),
      if (detailedStats != null) ...[
        _AchievementProgress.resolve(
          title: 'Listening sessions',
          icon: Icons.play_circle_rounded,
          current: detailedStats.totalSessions.toDouble(),
          currentLabel: '${detailedStats.totalSessions} sessions',
          levels: const [
            _AchievementLevel(threshold: 1, label: 'Press Play'),
            _AchievementLevel(threshold: 10, label: 'Getting Comfortable'),
            _AchievementLevel(threshold: 50, label: 'Regular Listener'),
            _AchievementLevel(threshold: 250, label: 'Session Specialist'),
            _AchievementLevel(threshold: 1000, label: 'Always Listening'),
            _AchievementLevel(threshold: 5000, label: 'Playback Master'),
          ],
          nextValueLabel: (value) => '${value.round()} sessions',
        ),
        _AchievementProgress.resolve(
          title: 'Authors discovered',
          icon: Icons.people_alt_rounded,
          current: detailedStats.uniqueAuthors.toDouble(),
          currentLabel: '${detailedStats.uniqueAuthors} authors',
          levels: const [
            _AchievementLevel(threshold: 1, label: 'New Voice'),
            _AchievementLevel(threshold: 5, label: 'Author Sampler'),
            _AchievementLevel(threshold: 20, label: 'Literary Wanderer'),
            _AchievementLevel(threshold: 50, label: 'Voice Collector'),
            _AchievementLevel(threshold: 100, label: 'Author Authority'),
            _AchievementLevel(threshold: 250, label: 'Pantheon of Voices'),
          ],
          nextValueLabel: (value) => '${value.round()} authors',
        ),
        _AchievementProgress.resolve(
          title: 'Longest session',
          icon: Icons.hourglass_top_rounded,
          current: detailedStats.longestSessionTime,
          currentLabel: formatListeningSeconds(detailedStats.longestSessionTime),
          levels: const [
            _AchievementLevel(threshold: 900, label: 'Settling In'),
            _AchievementLevel(threshold: 1800, label: 'Half-Hour Hero'),
            _AchievementLevel(threshold: 3600, label: 'Deep Listener'),
            _AchievementLevel(threshold: 7200, label: 'Lost in a Story'),
            _AchievementLevel(threshold: 14400, label: 'Epic Session'),
            _AchievementLevel(threshold: 28800, label: 'Endurance Legend'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: 'Average session',
          icon: Icons.timer_rounded,
          current: detailedStats.averageSessionTime,
          currentLabel: formatListeningSeconds(detailedStats.averageSessionTime),
          levels: const [
            _AchievementLevel(threshold: 300, label: 'Quick Chapter'),
            _AchievementLevel(threshold: 900, label: 'Focused Listener'),
            _AchievementLevel(threshold: 1800, label: 'In the Zone'),
            _AchievementLevel(threshold: 3600, label: 'Longform Lover'),
            _AchievementLevel(threshold: 7200, label: 'Immersive Listener'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: 'Audiobook listening',
          icon: Icons.menu_book_rounded,
          current: detailedStats.totalBookListeningTime,
          currentLabel: formatListeningSeconds(detailedStats.totalBookListeningTime),
          levels: const [
            _AchievementLevel(threshold: 3600, label: 'Book Beginner'),
            _AchievementLevel(threshold: 36000, label: 'Chapter Chaser'),
            _AchievementLevel(threshold: 180000, label: 'Bookworm'),
            _AchievementLevel(threshold: 360000, label: 'Audio Bibliophile'),
            _AchievementLevel(threshold: 1800000, label: 'Living Library'),
            _AchievementLevel(threshold: 3600000, label: 'Keeper of Stories'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: 'Podcast listening',
          icon: Icons.podcasts_rounded,
          current: detailedStats.totalPodcastListeningTime,
          currentLabel: formatListeningSeconds(detailedStats.totalPodcastListeningTime),
          levels: const [
            _AchievementLevel(threshold: 3600, label: 'First Episode'),
            _AchievementLevel(threshold: 18000, label: 'Podcast Curious'),
            _AchievementLevel(threshold: 72000, label: 'Episode Explorer'),
            _AchievementLevel(threshold: 180000, label: 'Feed Follower'),
            _AchievementLevel(threshold: 360000, label: 'Podcast Pro'),
            _AchievementLevel(threshold: 1800000, label: 'Airwave Archivist'),
          ],
          nextValueLabel: (value) => formatListeningSeconds(value),
        ),
        _AchievementProgress.resolve(
          title: 'Listening journey',
          icon: Icons.route_rounded,
          current: _journeyDays(detailedStats.firstSessionAt, detailedStats.lastSessionAt).toDouble(),
          currentLabel: '${_journeyDays(detailedStats.firstSessionAt, detailedStats.lastSessionAt)} days',
          levels: const [
            _AchievementLevel(threshold: 1, label: 'Journey Begins'),
            _AchievementLevel(threshold: 7, label: 'One Week In'),
            _AchievementLevel(threshold: 30, label: 'A Month of Stories'),
            _AchievementLevel(threshold: 180, label: 'Seasoned Listener'),
            _AchievementLevel(threshold: 365, label: 'Anniversary'),
            _AchievementLevel(threshold: 1000, label: 'Longtime Companion'),
          ],
          nextValueLabel: (value) => '${value.round()} days',
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
            achievement.unlockedLevel?.label ?? 'Not unlocked yet',
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
            child: LinearProgressIndicator(
              value: achievement.progress,
              minHeight: 7,
              color: accent,
              backgroundColor: accent.withValues(alpha: 0.14),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            achievement.nextLevel == null
                ? 'Highest milestone reached'
                : 'Next: ${achievement.nextLevel!.label} • ${achievement.nextValueLabel}',
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
        ? 'Loading session history…'
        : 'Unlocking detailed achievements • ${progress.loadedSessions}/${progress.totalSessions ?? '?'} sessions';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progress?.progress),
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
        label: const Text('Retry detailed achievements'),
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
