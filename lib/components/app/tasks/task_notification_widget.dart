import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/components/app/tasks/task_notification_panel.dart';
import 'package:yaabsa/provider/core/server_tasks_provider.dart';
import 'package:yaabsa/util/globals.dart';

class TaskNotificationWidget extends ConsumerStatefulWidget {
  const TaskNotificationWidget({super.key});

  @override
  ConsumerState<TaskNotificationWidget> createState() => _TaskNotificationWidgetState();
}

class _TaskNotificationWidgetState extends ConsumerState<TaskNotificationWidget> {
  final GlobalKey _notificationButtonKey = GlobalKey();
  final Set<String> _seenTaskIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(serverTasksProvider);
    final tasks = [...taskState.tasks]..sort((left, right) => (right.startedAt ?? 0).compareTo(left.startedAt ?? 0));

    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    final tasksRunning = tasks.any((task) => !task.isFinished);
    final hasUnseenCompletedTask = tasks.any((task) => task.isFinished && !_seenTaskIds.contains(task.id));

    return Tooltip(
      message: tasksRunning ? 'Tasks' : 'Activities',
      child: _NotificationIconButton(
        buttonKey: _notificationButtonKey,
        tasksRunning: tasksRunning,
        hasUnseenCompletedTask: hasUnseenCompletedTask,
        onTap: () => context.isDesktop ? _openDesktopTaskDropdown(context) : _openTaskSheet(context),
      ),
    );
  }

  void _markCurrentTasksAsSeen() {
    final tasks = ref.read(serverTasksProvider).tasks;
    if (!mounted) {
      return;
    }

    setState(() {
      _seenTaskIds.addAll(tasks.map((task) => task.id));
    });
  }

  Future<void> _openTaskSheet(BuildContext context) async {
    _markCurrentTasksAsSeen();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72),
          child: TaskNotificationPanel(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.72,
            onClearActivity: () => Navigator.of(sheetContext).pop(),
            onTaskSelected: (taskRoute) {
              Navigator.of(sheetContext).pop();
              if (mounted) {
                unawaited(context.push(taskRoute));
              }
            },
          ),
        );
      },
    );

    _markCurrentTasksAsSeen();
  }

  Future<void> _openDesktopTaskDropdown(BuildContext context) async {
    _markCurrentTasksAsSeen();

    final buttonRenderObject = _notificationButtonKey.currentContext?.findRenderObject();
    final overlayRenderObject = Overlay.of(context).context.findRenderObject();
    if (buttonRenderObject is! RenderBox || overlayRenderObject is! RenderBox) {
      return;
    }

    final buttonOffset = buttonRenderObject.localToGlobal(Offset.zero, ancestor: overlayRenderObject);
    final overlaySize = overlayRenderObject.size;

    const panelWidth = 420.0;
    final left = (buttonOffset.dx + buttonRenderObject.size.width - panelWidth)
        .clamp(12.0, overlaySize.width - panelWidth - 12.0)
        .toDouble();
    final top = (buttonOffset.dy + buttonRenderObject.size.height + 6)
        .clamp(12.0, overlaySize.height - 220.0)
        .toDouble();
    final availableHeight = (overlaySize.height - top - 12.0).clamp(220.0, overlaySize.height * 0.72).toDouble();

    await showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Task Activity',
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (dialogContext, _, _) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: panelWidth,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                color: Theme.of(dialogContext).colorScheme.surface,
                child: TaskNotificationPanel(
                  maxHeight: availableHeight,
                  onClearActivity: () => Navigator.of(dialogContext).pop(),
                  onTaskSelected: (taskRoute) {
                    Navigator.of(dialogContext).pop();
                    if (mounted) {
                      unawaited(context.push(taskRoute));
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (dialogContext, animation, secondaryAnimation, child) {
        final opacity = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final offset = Tween<Offset>(begin: const Offset(0, -0.03), end: Offset.zero).animate(opacity);
        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(position: offset, child: child),
        );
      },
    );

    _markCurrentTasksAsSeen();
  }
}

class _NotificationIconButton extends StatelessWidget {
  const _NotificationIconButton({
    this.buttonKey,
    required this.tasksRunning,
    required this.hasUnseenCompletedTask,
    required this.onTap,
  });

  final Key? buttonKey;
  final bool tasksRunning;
  final bool hasUnseenCompletedTask;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        key: buttonKey,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            tasksRunning
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2))
                : Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
            if (hasUnseenCompletedTask)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
