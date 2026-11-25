import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';
import 'package:yaabsa/components/app/tasks/task_running_card.dart';
import 'package:yaabsa/provider/core/server_tasks_provider.dart';
import 'package:yaabsa/util/l10n.dart';

class TaskNotificationPanel extends ConsumerWidget {
  const TaskNotificationPanel({super.key, this.onTaskSelected, this.onClearActivity, this.maxHeight});

  final ValueChanged<String>? onTaskSelected;
  final VoidCallback? onClearActivity;
  final double? maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifier = ref.read(serverTasksProvider.notifier);
    final taskState = ref.watch(serverTasksProvider);
    final tasks = [...taskState.tasks]..sort((left, right) => (right.startedAt ?? 0).compareTo(left.startedAt ?? 0));

    final runningCount = tasks.where((task) => !task.isFinished).length;
    final hasCompletedTasks = tasks.any((task) => task.isFinished);
    final constrainedHeight = maxHeight ?? MediaQuery.sizeOf(context).height * 0.72;
    const estimatedHeaderHeight = 98.0;
    final listMaxHeight = (constrainedHeight - estimatedHeaderHeight).clamp(120.0, constrainedHeight).toDouble();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: constrainedHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(l10n.headingTaskActivity, style: Theme.of(context).textTheme.titleLarge)),
                IconButton(
                  tooltip: l10n.actionClearCompleted,
                  onPressed: hasCompletedTasks
                      ? () {
                          notifier.clearCompletedTaskActivity();
                          onClearActivity?.call();
                        }
                      : null,
                  icon: const Icon(Icons.check_rounded),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(l10n.taskRunningCount(runningCount), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: listMaxHeight),
                child: tasks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(l10n.statusNoTasksYet),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        separatorBuilder: (_, _) =>
                            Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          final taskRoute = _routeForTask(task);
                          final progressLabel = _taskProgressLabel(
                            task: task,
                            taskProgressByLibraryItem: taskState.taskProgressByLibraryItem,
                          );

                          return InkWell(
                            onTap: (taskRoute == null || onTaskSelected == null)
                                ? null
                                : () => onTaskSelected!(taskRoute),
                            child: TaskRunningCard(task: task, progressLabel: progressLabel),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _taskProgressLabel({required AbsTask task, required Map<String, String> taskProgressByLibraryItem}) {
  if (task.isFinished) {
    return null;
  }

  final libraryItemId = task.data?.libraryItemId;
  if (libraryItemId == null || libraryItemId.trim().isEmpty) {
    return null;
  }

  return taskProgressByLibraryItem[libraryItemId];
}

String? _routeForTask(AbsTask task) {
  final libraryItemId = task.data?.libraryItemId;
  if (libraryItemId == null || libraryItemId.trim().isEmpty) {
    return null;
  }

  final itemRoute = '/item/${Uri.encodeComponent(libraryItemId)}';
  if (task.action == 'encode-m4b') {
    return '$itemRoute?editor=encoder';
  }

  return itemRoute;
}
