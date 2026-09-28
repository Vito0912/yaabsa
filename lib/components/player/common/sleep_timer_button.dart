import 'dart:async';

import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'sleep_timer_modal.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/extensions.dart';

void showSleepTimerSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => SafeArea(top: false, child: SleepTimerModal()),
  );
}

class SleepTimerButton extends ConsumerWidget {
  const SleepTimerButton({super.key});

  static const double _buttonSize = 48;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepTimer = ref.watch(sleepTimerHandlerProvider);
    final isActive = sleepTimer.isActive;

    return SizedBox(
      width: _buttonSize,
      height: _buttonSize,
      child: IconButton(
        onPressed: () => showSleepTimerSheet(context, ref),
        onLongPress: () => _toggleSleepTimerMarker(ref),
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        icon: isActive
            ? Text(
                sleepTimer.isChapterTimer
                    ? '${sleepTimer.remainingChapters} ch'
                    : sleepTimer.remainingTime.toLargestUnitCompactString(),
                style: TextStyle(color: Colors.lightGreenAccent.withValues(alpha: 0.8)),
              )
            : const Icon(Icons.bedtime_rounded),
      ),
    );
  }

  void _toggleSleepTimerMarker(WidgetRef ref) {
    final didToggle = ref.read(sleepTimerHandlerProvider.notifier).toggleSleepTimerMarker();
    if (didToggle) {
      unawaited(HapticFeedback.mediumImpact());
    }
  }
}
