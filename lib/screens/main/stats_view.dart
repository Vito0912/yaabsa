import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/models/advanced_listening_analytics_state.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/provider/common/stats_provider.dart';
import 'package:yaabsa/screens/main/stats/stats_advanced_dashboard.dart';
import 'package:yaabsa/screens/main/stats/stats_activity_section.dart';
import 'package:yaabsa/screens/main/stats/stats_activity_totals_card.dart';
import 'package:yaabsa/screens/main/stats/stats_expandable_panel.dart';
import 'package:yaabsa/screens/main/stats/stats_recent_sessions_list.dart';
import 'package:yaabsa/screens/main/stats/stats_section_card.dart';
import 'package:yaabsa/screens/main/stats/stats_summary_grid.dart';
import 'package:yaabsa/screens/main/stats/stats_weekday_breakdown.dart';
import 'package:yaabsa/screens/main/stats/stats_year_rewind_section.dart';
import 'package:yaabsa/util/globals.dart';

class StatsView extends ConsumerStatefulWidget {
  const StatsView({super.key});

  @override
  ConsumerState<StatsView> createState() => _StatsViewState();
}

class _StatsViewState extends ConsumerState<StatsView> {
  late int _selectedYear;
  bool _advancedModeEnabled = false;
  bool _yearInRewindExpanded = false;
  bool _advancedExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  Future<void> _refreshAll() async {
    ref.invalidate(listeningStatsProvider);
    ref.invalidate(listeningActivityStatsProvider);
    ref.read(advancedListeningAnalyticsProvider.notifier).clear();
    if (_yearInRewindExpanded) {
      ref.invalidate(yearInReviewStatsProvider(_selectedYear));
    }
    if (_advancedModeEnabled && _advancedExpanded) {
      await ref.read(advancedListeningAnalyticsProvider.notifier).load();
    }
  }

  Future<void> _enableAdvancedMode() async {
    if (_advancedModeEnabled) {
      return;
    }

    final shouldLoad = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Load advanced analytics?'),
          content: const Text(
            'Advanced mode fetches every listening-session page and can take time on large accounts.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Load')),
          ],
        );
      },
    );

    if (shouldLoad != true || !mounted) {
      return;
    }

    setState(() {
      _advancedModeEnabled = true;
    });
    await ref.read(advancedListeningAnalyticsProvider.notifier).load();
  }

  void _refreshActivity() {
    ref.invalidate(listeningActivityStatsProvider);
  }

  void _refreshAdvanced() {
    ref.read(advancedListeningAnalyticsProvider.notifier).load();
  }

  void _onYearSelected(int year) {
    if (_selectedYear == year) {
      return;
    }

    setState(() {
      _selectedYear = year;
    });
  }

  List<int> _availableYears() {
    final now = DateTime.now().year;
    return List<int>.generate(25, (index) => now - index);
  }

  AsyncValue<AdvancedListeningStats> _advancedAsyncValue(AdvancedListeningAnalyticsState state) {
    if (state.stats != null) {
      return AsyncValue.data(state.stats!);
    }

    if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
      return AsyncValue.error(state.errorMessage!, StackTrace.empty);
    }

    if (state.isLoading) {
      return const AsyncValue.loading();
    }

    return const AsyncValue.loading();
  }

  @override
  Widget build(BuildContext context) {
    final listeningStatsAsync = ref.watch(listeningStatsProvider);
    final activityAsync = ref.watch(listeningActivityStatsProvider);
    final yearStatsAsync = _yearInRewindExpanded ? ref.watch(yearInReviewStatsProvider(_selectedYear)) : null;
    final advancedAnalyticsState = _advancedModeEnabled && _advancedExpanded
        ? ref.watch(advancedListeningAnalyticsProvider)
        : null;

    return RefreshIndicator(
      onRefresh: _refreshAll,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.isMobile ? 12 : 18),
        children: [
          Text('Stats', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          listeningStatsAsync.when(
            skipLoadingOnRefresh: true,
            skipLoadingOnReload: true,
            data: (stats) {
              return Column(
                children: [
                  StatsSectionCard(
                    title: 'Listening Overview',
                    padding: const EdgeInsets.all(12),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final recentSessions = stats.recentSessions ?? const <PlaybackSession>[];
                        final showRecentSessions = constraints.maxWidth >= 980 && recentSessions.isNotEmpty;

                        final overviewContent = Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StatsSummaryGrid(stats: stats),
                            StatsActivityTotalsCard(activityAsync: activityAsync, onRefresh: _refreshActivity),
                          ],
                        );

                        if (!showRecentSessions) {
                          return overviewContent;
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: overviewContent),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Recent Sessions', style: Theme.of(context).textTheme.titleSmall),
                                      const SizedBox(height: 8),
                                      StatsRecentSessionsList(sessions: recentSessions, maxItems: 5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  StatsSectionCard(
                    title: 'Activity Range',
                    trailing: IconButton(
                      tooltip: 'Refresh activity',
                      onPressed: _refreshActivity,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: StatsActivitySection(activityAsync: activityAsync, onRefresh: _refreshActivity),
                  ),
                  const SizedBox(height: 12),
                  StatsSectionCard(
                    title: 'Weekday Pattern',
                    padding: const EdgeInsets.all(12),
                    child: StatsWeekdayBreakdown(dayOfWeek: stats.dayOfWeek),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
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
          const SizedBox(height: 12),
          StatsSectionCard(
            title: 'More Insights',
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                StatsExpandablePanel(
                  title: 'Year In Rewind',
                  icon: Icons.auto_awesome_rounded,
                  expanded: _yearInRewindExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _yearInRewindExpanded = expanded;
                    });
                    if (expanded) {
                      ref.invalidate(yearInReviewStatsProvider(_selectedYear));
                    }
                  },
                  child: yearStatsAsync == null
                      ? const SizedBox.shrink()
                      : StatsYearRewindSection(
                          selectedYear: _selectedYear,
                          availableYears: _availableYears(),
                          onYearSelected: _onYearSelected,
                          onRefresh: () => ref.invalidate(yearInReviewStatsProvider(_selectedYear)),
                          statsAsync: yearStatsAsync,
                        ),
                ),
                const SizedBox(height: 10),
                StatsExpandablePanel(
                  title: 'Advanced Analytics',
                  icon: Icons.analytics_rounded,
                  expanded: _advancedExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _advancedExpanded = expanded;
                    });
                    if (expanded && _advancedModeEnabled) {
                      ref.read(advancedListeningAnalyticsProvider.notifier).load();
                    }
                  },
                  child: !_advancedModeEnabled
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: _enableAdvancedMode,
                            icon: const Icon(Icons.analytics_outlined),
                            label: const Text('Load Advanced Analytics'),
                          ),
                        )
                      : advancedAnalyticsState != null
                      ? StatsAdvancedDashboard(
                          statsAsync: _advancedAsyncValue(advancedAnalyticsState),
                          onRefresh: _refreshAdvanced,
                          loadingProgress: advancedAnalyticsState.progress,
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
