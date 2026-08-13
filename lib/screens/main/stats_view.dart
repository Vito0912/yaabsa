import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/models/advanced_listening_analytics_state.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/provider/common/stats_provider.dart';
import 'package:yaabsa/screens/main/stats/stats_activity_section.dart';
import 'package:yaabsa/screens/main/stats/stats_activity_totals_card.dart';
import 'package:yaabsa/screens/main/stats/stats_achievements_section.dart';
import 'package:yaabsa/screens/main/stats/stats_advanced_dashboard.dart';
import 'package:yaabsa/screens/main/stats/stats_recent_sessions_list.dart';
import 'package:yaabsa/screens/main/stats/stats_summary_grid.dart';
import 'package:yaabsa/screens/main/stats/stats_weekday_breakdown.dart';
import 'package:yaabsa/screens/main/stats/stats_year_rewind_section.dart';
import 'package:yaabsa/screens/main/user_listening_sessions_view.dart';
import 'package:yaabsa/util/globals.dart';

class StatsView extends ConsumerStatefulWidget {
  const StatsView({super.key});

  @override
  ConsumerState<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends ConsumerState<StatsView> {
  late int _selectedYear;
  bool _yearInRewindExpanded = false;
  bool _achievementsExpanded = false;
  bool _advancedExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  Future<void> _refreshAll() async {
    ref.invalidate(listeningStatsProvider);
    ref.invalidate(listeningActivityStatsProvider);
    final analytics = ref.read(advancedListeningAnalyticsProvider);
    if (_achievementsExpanded || _advancedExpanded || analytics.stats != null) {
      unawaited(ref.read(advancedListeningAnalyticsProvider.notifier).load());
    }
    if (_yearInRewindExpanded) {
      ref.invalidate(yearInReviewStatsProvider(_selectedYear));
    }
  }

  void _setYearExpanded(bool expanded) {
    setState(() => _yearInRewindExpanded = expanded);
    if (expanded) {
      ref.invalidate(yearInReviewStatsProvider(_selectedYear));
    }
  }

  void _setAdvancedExpanded(bool expanded) {
    setState(() => _advancedExpanded = expanded);
    if (expanded) {
      ref.read(advancedListeningAnalyticsProvider.notifier).load();
    }
  }

  void _setAchievementsExpanded(bool expanded) {
    setState(() => _achievementsExpanded = expanded);
    if (expanded) {
      ref.read(advancedListeningAnalyticsProvider.notifier).load();
    }
  }

  AsyncValue<AdvancedListeningStats> _advancedAsyncValue(AdvancedListeningAnalyticsState state) {
    if (state.stats != null) return AsyncValue.data(state.stats!);
    if (state.errorMessage case final message? when message.isNotEmpty) {
      return AsyncValue.error(message, StackTrace.empty);
    }
    return const AsyncValue.loading();
  }

  @override
  Widget build(BuildContext context) {
    final listeningStatsAsync = ref.watch(listeningStatsProvider);
    final activityAsync = ref.watch(listeningActivityStatsProvider);
    final yearStatsAsync = _yearInRewindExpanded ? ref.watch(yearInReviewStatsProvider(_selectedYear)) : null;
    final horizontalPadding = context.isMobile ? 12.0 : 24.0;

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 40),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  listeningStatsAsync.when(
                    skipLoadingOnRefresh: true,
                    skipLoadingOnReload: true,
                    data: (stats) {
                      final recentSessions = stats.recentSessions ?? const <PlaybackSession>[];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          StatsSection(
                            title: 'Your listening',
                            icon: Icons.insights_rounded,
                            trailing: IconButton(
                              tooltip: 'Refresh stats',
                              onPressed: _refreshAll,
                              icon: const Icon(Icons.refresh_rounded),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatsSummaryGrid(stats: stats),
                                const SizedBox(height: 20),
                                Text('Recent pace', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 10),
                                StatsActivityTotalsCard(
                                  activityAsync: activityAsync,
                                  onRefresh: () => ref.invalidate(listeningActivityStatsProvider),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          StatsSection(
                            title: 'Activity',
                            icon: Icons.stacked_line_chart_rounded,
                            trailing: IconButton(
                              tooltip: 'Refresh activity',
                              onPressed: () => ref.invalidate(listeningActivityStatsProvider),
                              icon: const Icon(Icons.refresh_rounded),
                            ),
                            child: StatsActivitySection(
                              activityAsync: activityAsync,
                              onRefresh: () => ref.invalidate(listeningActivityStatsProvider),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _ResponsiveOverviewPair(
                            first: StatsSection(
                              title: 'Weekday rhythm',
                              icon: Icons.view_week_rounded,
                              child: StatsWeekdayBreakdown(dayOfWeek: stats.dayOfWeek),
                            ),
                            second: StatsSection(
                              title: 'Recent sessions',
                              icon: Icons.history_rounded,
                              trailing: TextButton(
                                onPressed: () => context.push(UserListeningSessionsView.routeName),
                                child: const Text('View all'),
                              ),
                              child: StatsRecentSessionsList(
                                sessions: recentSessions,
                                maxItems: 5,
                                onSessionTap: (session) {
                                  if (session.libraryItemId.isNotEmpty) {
                                    context.push('/item/${session.libraryItemId}');
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          StatsSection(
                            title: 'Achievements',
                            icon: Icons.emoji_events_rounded,
                            trailing: IconButton(
                              tooltip: _achievementsExpanded ? 'Collapse achievements' : 'Open achievements',
                              onPressed: () => _setAchievementsExpanded(!_achievementsExpanded),
                              icon: Icon(_achievementsExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
                            ),
                            compact: !_achievementsExpanded,
                            child: Consumer(
                              builder: (context, ref, _) {
                                final sessionAnalytics = ref.watch(advancedListeningAnalyticsProvider);
                                return StatsAchievementsSection(
                                  stats: stats,
                                  sessionAnalytics: sessionAnalytics,
                                  onRetrySessionAnalytics: () {
                                    unawaited(ref.read(advancedListeningAnalyticsProvider.notifier).load());
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => ConnectionIssueView.requestFailed(
                      error: error,
                      title: 'Unable to load listening stats',
                      showDownloadsShortcut: false,
                      onRetry: () async {
                        ref.invalidate(listeningStatsProvider);
                        ref.invalidate(listeningActivityStatsProvider);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatsSection(
                    title: 'Year in Rewind',
                    icon: Icons.auto_awesome_rounded,
                    trailing: IconButton(
                      tooltip: _yearInRewindExpanded ? 'Collapse Year in Rewind' : 'Open Year in Rewind',
                      onPressed: () => _setYearExpanded(!_yearInRewindExpanded),
                      icon: Icon(_yearInRewindExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
                    ),
                    compact: !_yearInRewindExpanded,
                    child: _yearInRewindExpanded
                        ? StatsYearRewindSection(
                            selectedYear: _selectedYear,
                            availableYears: List<int>.generate(25, (index) => DateTime.now().year - index),
                            onYearSelected: (year) {
                              if (_selectedYear == year) return;
                              setState(() => _selectedYear = year);
                            },
                            onRefresh: () => ref.invalidate(yearInReviewStatsProvider(_selectedYear)),
                            statsAsync: yearStatsAsync!,
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  StatsSection(
                    title: 'Advanced analytics',
                    icon: Icons.analytics_rounded,
                    trailing: IconButton(
                      tooltip: _advancedExpanded ? 'Collapse advanced analytics' : 'Open advanced analytics',
                      onPressed: () => _setAdvancedExpanded(!_advancedExpanded),
                      icon: Icon(_advancedExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
                    ),
                    compact: !_advancedExpanded,
                    child: !_advancedExpanded
                        ? const SizedBox.shrink()
                        : Consumer(
                            builder: (context, ref, _) {
                              final advancedState = ref.watch(advancedListeningAnalyticsProvider);
                              return StatsAdvancedDashboard(
                                statsAsync: _advancedAsyncValue(advancedState),
                                onRefresh: () => ref.read(advancedListeningAnalyticsProvider.notifier).load(),
                                loadingProgress: advancedState.progress,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveOverviewPair extends StatelessWidget {
  const _ResponsiveOverviewPair({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(children: [first, const SizedBox(height: 16), second]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }
}
