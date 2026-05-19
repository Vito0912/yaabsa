import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/util/globals.dart';

import 'package:yaabsa/generated/l10n.dart';

class DownloadStatus extends StatelessWidget {
  const DownloadStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskRecord>>(
      stream: downloadHandler.taskQueueStream,
      initialData: const <TaskRecord>[],
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
        var centerLabel = '$remainingFiles';
        if (remainingFiles > 99) {
          centerLabel = '99+';
        }
        final overallProgress = _calculateOverallProgress(tasks);

        return Tooltip(
          message: S.current.downloadStatusFilesRemaining(remainingFiles),
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
                    child: CircularProgressIndicator(
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
          child: StreamBuilder<List<TaskRecord>>(
            stream: downloadHandler.taskQueueStream,
            initialData: const <TaskRecord>[],
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(S.current.componentsAppDownloadStatusCouldNotLoadActiveDownloads(snapshot.error ?? '')),
                  ),
                );
              }

              final tasks = _activeTasks(snapshot.data ?? const <TaskRecord>[]);
              if (tasks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(S.current.componentsAppDownloadStatusNoActiveDownloads),
                  ),
                );
              }

              final overallProgress = _calculateOverallProgress(tasks);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.componentsAppDownloadStatusDownloadsInProgress,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.current.downloadStatusFilesRemaining(tasks.length),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(value: overallProgress, minHeight: 6),
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
                              tooltip: S.current.componentsAppDownloadStatusCancelDownload,
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () async {
                                try {
                                  final canceled = await downloadHandler.cancelTask(task.taskId);
                                  if (!context.mounted) {
                                    return;
                                  }
                                  final message = canceled
                                      ? S.current.componentsAppDownloadStatusCanceledDownloadTask(_taskTitle(task))
                                      : S.current.componentsAppDownloadStatusCouldNotCancelDownloadTask(
                                          _taskTitle(task),
                                        );
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                } catch (e) {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(S.current.componentsAppDownloadStatusCouldNotCancelDownload(e)),
                                    ),
                                  );
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
                                  child: LinearProgressIndicator(value: progress, minHeight: 5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  S.current.componentsAppDownloadStatusText(
                                    _statusLabel(task.status),
                                    NumberFormat.decimalPatternDigits(
                                      locale: Intl.getCurrentLocale(),
                                      decimalDigits: 0,
                                    ).format(progress * 100),
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

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.enqueued:
        return 'Queued';
      case TaskStatus.running:
        return 'Downloading';
      case TaskStatus.waitingToRetry:
        return 'Retrying';
      case TaskStatus.paused:
        return 'Paused';
      case TaskStatus.complete:
        return 'Complete';
      case TaskStatus.notFound:
        return 'Not found';
      case TaskStatus.failed:
        return 'Failed';
      case TaskStatus.canceled:
        return 'Canceled';
    }
  }

  void _showErrorDialog(BuildContext context, Object? error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.current.componentsAppDownloadStatusDownloadError),
        content: Text(S.current.componentsAppDownloadStatusError(error ?? '')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(S.current.componentsAppDownloadStatusOk)),
        ],
      ),
    );
  }
}
