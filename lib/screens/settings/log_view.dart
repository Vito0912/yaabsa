import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/widgets/local_log_settings_section.dart';
import 'package:yaabsa/screens/settings/widgets/log_entry_tile.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/log_exporter.dart';
import 'package:yaabsa/util/logger.dart';

enum _LogCopyAction { copyRaw, copyMarkdown }

class LogView extends HookWidget {
  const LogView({super.key});

  void _showSnackBar(BuildContext context, String message, {Duration duration = const Duration(seconds: 4)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: duration));
  }

  void _copyFormattedLogs(BuildContext context, List<LogEntry> logs, String Function() buildText) {
    if (logs.isEmpty) {
      _showSnackBar(context, context.l10n.statusNoLogsAvailable);
      return;
    }

    Clipboard.setData(ClipboardData(text: buildText()));
    _showSnackBar(context, context.l10n.statusLogsCopied);
  }

  String _formatGitHubLogs(BuildContext context, List<LogEntry> logs) {
    final buffer = StringBuffer();
    buffer.writeln('<details>');
    buffer.writeln('<summary>${context.l10n.logExportSummary(logs.length)}</summary>');
    buffer.writeln('');
    buffer.writeln('```text');
    buffer.write(logs.map(formatLogEntryForExport).join('\n'));
    buffer.writeln('');
    buffer.writeln('```');
    buffer.writeln('');
    buffer.writeln('</details>');
    return buffer.toString();
  }

  Future<void> _exportLogs(BuildContext context, List<LogEntry> logs, ValueNotifier<bool> isExporting) async {
    if (logs.isEmpty) {
      _showSnackBar(context, context.l10n.statusNoLogsAvailable);
      return;
    }

    isExporting.value = true;

    try {
      final exportResult = await exportLogsAsLogFile(logs);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.statusLogsExportedToPath(exportResult.filePath),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _showSnackBar(context, context.l10n.errorOperationFailed(context.l10n.operationExportLogs, error.toString()));
    } finally {
      if (context.mounted) {
        isExporting.value = false;
      }
    }
  }

  void _animateScrollTo(ScrollController controller, double offset) {
    if (!controller.hasClients) {
      return;
    }

    unawaited(controller.animateTo(offset, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut));
  }

  List<LogEntry> _filterLogs(List<LogEntry> logs, Set<InfoLevel> selectedLevels, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (selectedLevels.isEmpty && normalizedQuery.isEmpty) {
      return logs;
    }

    final filtered = <LogEntry>[];
    for (final entry in logs) {
      if (selectedLevels.isNotEmpty && !selectedLevels.contains(entry.level)) {
        continue;
      }

      if (normalizedQuery.isNotEmpty) {
        final messageMatches = entry.message.toLowerCase().contains(normalizedQuery);
        final tagMatches = (entry.tag ?? '').toLowerCase().contains(normalizedQuery);
        if (!messageMatches && !tagMatches) {
          continue;
        }
      }

      filtered.add(entry);
    }

    return filtered;
  }

  String _labelForLevel(BuildContext context, InfoLevel level) {
    final l10n = context.l10n;
    switch (level) {
      case InfoLevel.debug:
        return l10n.logLevelDebug;
      case InfoLevel.info:
        return l10n.logLevelInfo;
      case InfoLevel.warning:
        return l10n.statusWarning;
      case InfoLevel.error:
        return l10n.logLevelError;
    }
  }

  Widget _buildEmptyState(BuildContext context, {required bool isLoading, required bool hasActiveFilter}) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 28, height: 28, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(height: 10),
            Text(
              l10n.statusLoading,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final icon = hasActiveFilter ? Icons.search_off_rounded : Icons.article_rounded;
    final title = hasActiveFilter ? l10n.statusNoLogsMatchSearch : l10n.statusNoLogsAvailable;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            const SizedBox(height: 10),
            Text(title, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (!hasActiveFilter) ...[
              const SizedBox(height: 6),
              Text(
                l10n.messageLogsAppearHere,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEntryCountPill(BuildContext context, int count) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
      child: Text(
        context.l10n.logEntryCount(count),
        style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  Widget _buildFilterExportActions(
    BuildContext context, {
    required List<LogEntry> visibleLogs,
    required ValueNotifier<bool> isExporting,
  }) {
    final l10n = context.l10n;
    final hasLogs = visibleLogs.isNotEmpty;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        YaabsaContextMenuButton<_LogCopyAction>(
          enabled: hasLogs,
          tooltip: l10n.actionCopy,
          icon: const Icon(Icons.content_copy_rounded),
          triggerVariant: YaabsaActionButtonVariant.outlined,
          triggerShape: YaabsaActionButtonShape.rounded,
          onSelected: (action) {
            switch (action) {
              case _LogCopyAction.copyRaw:
                _copyFormattedLogs(context, visibleLogs, () => formatLogsForExport(visibleLogs));
              case _LogCopyAction.copyMarkdown:
                _copyFormattedLogs(context, visibleLogs, () => _formatGitHubLogs(context, visibleLogs));
            }
          },
          menuNodeBuilder: (context) {
            return [
              M3EMenuEntry(
                label: l10n.actionCopyRaw,
                value: _LogCopyAction.copyRaw,
                leading: const Icon(Icons.content_copy_rounded, size: 18),
              ),
              M3EMenuEntry(
                label: l10n.actionCopyMarkdown,
                value: _LogCopyAction.copyMarkdown,
                leading: const Icon(Icons.code_rounded, size: 18),
              ),
            ];
          },
        ),
        const SizedBox(width: 8),
        YaabsaButton.small(
          variant: YaabsaButtonVariant.tonal,
          icon: const Icon(Icons.download_rounded, size: 18),
          label: Text(isExporting.value ? l10n.statusExporting : l10n.actionExport),
          tooltip: l10n.actionExportLogs,
          isLoading: isExporting.value,
          onPressed: hasLogs && !isExporting.value
              ? () {
                  unawaited(_exportLogs(context, visibleLogs, isExporting));
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildConsoleActions(
    BuildContext context, {
    required bool hasLogs,
    required ScrollController scrollController,
    required ValueNotifier<bool> autoScrollEnabled,
  }) {
    final l10n = context.l10n;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        YaabsaActionIconButton(
          icon: Icons.vertical_align_top_rounded,
          tooltip: l10n.actionScrollToTop,
          variant: YaabsaActionButtonVariant.outlined,
          shape: YaabsaActionButtonShape.rounded,
          enabled: hasLogs,
          onPressed: hasLogs
              ? () {
                  _animateScrollTo(scrollController, 0);
                }
              : null,
        ),
        const SizedBox(width: 6),
        YaabsaActionIconButton(
          icon: Icons.vertical_align_bottom_rounded,
          tooltip: l10n.actionScrollToBottom,
          variant: YaabsaActionButtonVariant.outlined,
          shape: YaabsaActionButtonShape.rounded,
          enabled: hasLogs,
          onPressed: hasLogs
              ? () {
                  if (scrollController.hasClients) {
                    _animateScrollTo(scrollController, scrollController.position.maxScrollExtent);
                  }
                }
              : null,
        ),
        const SizedBox(width: 6),
        YaabsaActionIconButton(
          icon: Icons.keyboard_double_arrow_down_rounded,
          tooltip: l10n.settingLogAutoScroll,
          variant: autoScrollEnabled.value ? YaabsaActionButtonVariant.filledTonal : YaabsaActionButtonVariant.outlined,
          tone: autoScrollEnabled.value ? YaabsaActionTone.primary : YaabsaActionTone.neutral,
          shape: YaabsaActionButtonShape.rounded,
          onPressed: () {
            autoScrollEnabled.value = !autoScrollEnabled.value;
          },
        ),
      ],
    );
  }

  Widget _buildSeverityFilterChips(BuildContext context, ValueNotifier<Set<InfoLevel>> selectedLevels) {
    final l10n = context.l10n;
    final activeLevels = selectedLevels.value;

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        FilterChip(
          label: Text(l10n.filterAll),
          selected: activeLevels.isEmpty,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onSelected: (_) {
            selectedLevels.value = const <InfoLevel>{};
          },
        ),
        for (final level in InfoLevel.values)
          FilterChip(
            label: Text(_labelForLevel(context, level)),
            selected: activeLevels.contains(level),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onSelected: (selected) {
              final nextLevels = Set<InfoLevel>.from(activeLevels);
              if (selected) {
                nextLevels.add(level);
              } else {
                nextLevels.remove(level);
              }
              selectedLevels.value = nextLevels;
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final streamSnapshot = useStream(appLoggerService.logStream);
    final logs = appLoggerService.logHistory;
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final searchValue = useValueListenable(searchController);
    final selectedLevels = useState<Set<InfoLevel>>(const <InfoLevel>{});
    final autoScrollEnabled = useState(true);
    final isExporting = useState(false);

    final filteredLogs = _filterLogs(logs, selectedLevels.value, searchValue.text);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final listHeight = (screenHeight * 0.62).clamp(260.0, 960.0);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    useEffect(() {
      if (filteredLogs.isNotEmpty && scrollController.hasClients && autoScrollEnabled.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            _animateScrollTo(scrollController, scrollController.position.maxScrollExtent);
          }
        });
      }
      return null;
    }, [filteredLogs.length, autoScrollEnabled.value]);

    return SettingsPageScaffold(
      title: l10n.settingsCategoryLogs,
      embedded: true,
      showEmbeddedBackButton: true,
      maxWidth: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const LocalLogSettingsSection(),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: YaabsaSurfaceCard(
            padding: const EdgeInsets.all(12),
            borderRadius: 16,
            color: colorScheme.surfaceContainerLowest,
            borderColor: colorScheme.outlineVariant.withValues(alpha: 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final searchField = YaabsaSearchField(
                      controller: searchController,
                      hintText: l10n.fieldSearchLogs,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    );
                    final actions = _buildFilterExportActions(
                      context,
                      visibleLogs: filteredLogs,
                      isExporting: isExporting,
                    );

                    if (constraints.maxWidth >= 560) {
                      return Row(
                        children: [
                          Expanded(child: searchField),
                          const SizedBox(width: 8),
                          actions,
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        searchField,
                        const SizedBox(height: 8),
                        Align(alignment: Alignment.centerRight, child: actions),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildSeverityFilterChips(context, selectedLevels),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: YaabsaSurfaceCard(
            padding: EdgeInsets.zero,
            borderRadius: 16,
            color: colorScheme.surfaceContainerLowest,
            borderColor: colorScheme.outlineVariant.withValues(alpha: 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: colorScheme.surfaceContainerLow,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Flexible(child: _buildEntryCountPill(context, filteredLogs.length)),
                      const SizedBox(width: 8),
                      _buildConsoleActions(
                        context,
                        hasLogs: filteredLogs.isNotEmpty,
                        scrollController: scrollController,
                        autoScrollEnabled: autoScrollEnabled,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
                SizedBox(
                  height: listHeight,
                  child: filteredLogs.isEmpty
                      ? _buildEmptyState(
                          context,
                          isLoading: logs.isEmpty && streamSnapshot.connectionState == ConnectionState.waiting,
                          hasActiveFilter: logs.isNotEmpty,
                        )
                      : Scrollbar(
                          controller: scrollController,
                          thumbVisibility: true,
                          child: ListView.separated(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: filteredLogs.length,
                            separatorBuilder: (_, _) =>
                                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
                            itemBuilder: (context, index) {
                              return LogEntryTile(entry: filteredLogs[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
