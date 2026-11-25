import 'package:background_downloader/background_downloader.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class DownloadStatus extends StatelessWidget {
  const DownloadStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder<List<TaskRecord>>(
      stream: downloadHandler.taskQueueStream,
      initialData: downloadHandler.taskQueueSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return IconButton(
            icon: const Icon(Icons.error, color: Colors.red),
            onPressed: () => _showErrorDialog(context, snapshot.error),
          );
        }

        final tasks = _activeTasks(snapshot.data ?? const <TaskRecord>[]);
        if (tasks.isEmpty) {
          return const SizedBox.shrink();
        }

        final remainingFiles = tasks.length;
        final centerLabel = remainingFiles > 99
            ? '99+'
            : NumberFormat.decimalPattern(l10n.localeName).format(remainingFiles);
        final overallProgress = _calculateOverallProgress(tasks);

        return Tooltip(
          message: l10n.downloadRemainingFileCount(remainingFiles),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => _showProgressSheet(context),
            child: SizedBox(
              width: 34,
              height: 34,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: YaabsaCircularProgressIndicator(
                      value: overallProgress,
                      strokeWidth: 2.6,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  Text(
                    centerLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showProgressSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: SafeArea(
            top: false,
            child: StreamBuilder<List<TaskRecord>>(
              stream: downloadHandler.taskQueueStream,
              initialData: downloadHandler.taskQueueSnapshot,
              builder: (context, snapshot) {
                final l10n = context.l10n;

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l10n.errorCouldNotLoadActiveDownloads),
                    ),
                  );
                }

                final tasks = _activeTasks(snapshot.data ?? const <TaskRecord>[]);
                if (tasks.isEmpty) {
                  return Center(
                    child: Padding(padding: const EdgeInsets.all(24), child: Text(l10n.statusNoActiveDownloads)),
                  );
                }

                final overallProgress = _calculateOverallProgress(tasks);
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.headingDownloadsInProgress, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(l10n.downloadRemainingFileCount(tasks.length), style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: YaabsaLinearProgressIndicator(value: overallProgress, minHeight: 6),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: tasks.length,
                          separatorBuilder: (_, _) => const Divider(height: 12),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final progress = _normalizeProgress(task.progress);
                            final fileName = task.task.filename.trim().isEmpty ? task.task.taskId : task.task.filename;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(_taskTitle(task), maxLines: 1, overflow: TextOverflow.ellipsis),
                              trailing: IconButton(
                                tooltip: l10n.actionCancelDownload,
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () async {
                                  try {
                                    final canceled = await downloadHandler.cancelTask(task.taskId);
                                    if (!context.mounted) {
                                      return;
                                    }
                                    final message = canceled
                                        ? l10n.statusDownloadCanceledNamed(_taskTitle(task))
                                        : l10n.errorCancelDownloadNamed(_taskTitle(task));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                  } catch (e) {
                                    if (!context.mounted) {
                                      return;
                                    }
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(l10n.errorCancelDownload)));
                                  }
                                },
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: YaabsaLinearProgressIndicator(value: progress, minHeight: 5),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    l10n.statusWithProgress(
                                      _statusLabel(task.status, l10n),
                                      (NumberFormat.percentPattern(
                                        l10n.localeName,
                                      )..maximumFractionDigits = 0).format(progress),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<TaskRecord> _activeTasks(List<TaskRecord> tasks) {
    final activeTasks = tasks.where((task) => task.status.isNotFinalState).toList(growable: true);
    activeTasks.sort((left, right) {
      final statusComparison = _statusPriority(left.status).compareTo(_statusPriority(right.status));
      if (statusComparison != 0) {
        return statusComparison;
      }
      return _taskTitle(left).toLowerCase().compareTo(_taskTitle(right).toLowerCase());
    });
    return activeTasks;
  }

  int _statusPriority(TaskStatus status) {
    switch (status) {
      case TaskStatus.running:
        return 0;
      case TaskStatus.enqueued:
        return 1;
      case TaskStatus.waitingToRetry:
        return 2;
      case TaskStatus.paused:
        return 3;
      case TaskStatus.complete:
      case TaskStatus.notFound:
      case TaskStatus.failed:
      case TaskStatus.canceled:
        return 4;
    }
  }

  double _calculateOverallProgress(List<TaskRecord> tasks) {
    if (tasks.isEmpty) {
      return 0;
    }
    final totalProgress = tasks.fold<double>(0, (sum, task) => sum + _normalizeProgress(task.progress));
    return totalProgress / tasks.length;
  }

  double _normalizeProgress(double progress) {
    if (!progress.isFinite || progress < 0) {
      return 0;
    }
    return progress.clamp(0.0, 1.0).toDouble();
  }

  String _taskTitle(TaskRecord task) {
    final displayName = task.task.displayName.trim();
    if (displayName.isNotEmpty) {
      return displayName;
    }
    if (task.group.trim().isNotEmpty && task.group != 'default') {
      return task.group;
    }
    if (task.task.filename.trim().isNotEmpty) {
      return task.task.filename;
    }
    return task.task.taskId;
  }

  String _statusLabel(TaskStatus status, AppLocalizations l10n) {
    switch (status) {
      case TaskStatus.enqueued:
        return l10n.statusQueued;
      case TaskStatus.running:
        return l10n.statusDownloading;
      case TaskStatus.waitingToRetry:
        return l10n.statusRetrying;
      case TaskStatus.paused:
        return l10n.statusPaused;
      case TaskStatus.complete:
        return l10n.statusComplete;
      case TaskStatus.notFound:
        return l10n.statusNotFound;
      case TaskStatus.failed:
        return l10n.statusFailed;
      case TaskStatus.canceled:
        return l10n.statusCanceled;
    }
  }

  void _showErrorDialog(BuildContext context, Object? error) {
    final l10n = context.l10n;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.headingDownloadError),
        content: Text(l10n.errorUnknown),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.actionOk))],
      ),
    );
  }
}
