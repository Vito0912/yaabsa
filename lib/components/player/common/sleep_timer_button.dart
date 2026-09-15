import 'dart:async';

import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:yaabsa/util/handler/sleep_timer_target.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/extensions.dart';

void showSleepTimerSheet(BuildContext context, WidgetRef _) {
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const SleepTimerModal(),
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
                sleepTimer.remainingTime.toLargestUnitCompactString(),
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

class SleepTimerModal extends ConsumerStatefulWidget {
  const SleepTimerModal({super.key});

  @override
  ConsumerState<SleepTimerModal> createState() => _SleepTimerModalState();
}

class _SleepTimerModalState extends ConsumerState<SleepTimerModal> {
  final TextEditingController _customController = TextEditingController();

  final List<SleepTimerOption> _quickOptions = const [
    SleepTimerOption(label: '5m', duration: Duration(minutes: 5)),
    SleepTimerOption(label: '10m', duration: Duration(minutes: 10)),
    SleepTimerOption(label: '15m', duration: Duration(minutes: 15)),
    SleepTimerOption(label: '30m', duration: Duration(minutes: 30)),
    SleepTimerOption(label: '45m', duration: Duration(minutes: 45)),
    SleepTimerOption(label: '60m', duration: Duration(minutes: 60)),
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sleepTimer = ref.watch(sleepTimerHandlerProvider);
    final handler = ref.read(sleepTimerHandlerProvider.notifier);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sleep timer', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          if (sleepTimer.isActive)
            Text(
              sleepTimer.mode == SleepTimerMode.chapterEnd
                  ? 'Remaining ${sleepTimer.remainingTime.toCompactRemainingString()} · end of chapter'
                  : 'Remaining ${sleepTimer.remainingTime.toCompactRemainingString()}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._quickOptions.map(
                (option) => ActionChip(
                  label: Text(option.label),
                  onPressed: () {
                    ref.read(sleepTimerHandlerProvider.notifier).start(option.duration);
                    Navigator.of(context).pop();
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
              StreamBuilder<Duration>(
                stream: audioHandler.positionStream,
                initialData: audioHandler.position,
                builder: (context, positionSnapshot) {
                  final chapterTarget = handler.availableChapterSleepTarget;
                  final chapterRemaining = chapterTarget?.remainingAt(positionSnapshot.data ?? audioHandler.position);
                  if (chapterTarget == null || chapterRemaining == null) {
                    return const SizedBox.shrink();
                  }
                  return ActionChip(
                    avatar: const Icon(Icons.skip_next_rounded),
                    label: Text('End of chapter · ${chapterRemaining.toLargestUnitCompactString()}'),
                    onPressed: _startChapterTimer,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (sleepTimer.isActive)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (sleepTimer.mode == SleepTimerMode.duration) ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      if (sleepTimer.isRunning) {
                        ref.read(sleepTimerHandlerProvider.notifier).pause();
                      } else {
                        ref.read(sleepTimerHandlerProvider.notifier).resume();
                      }
                    },
                    icon: Icon(sleepTimer.isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(sleepTimer.isRunning ? 'Pause' : 'Resume'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(sleepTimerHandlerProvider.notifier).extend(const Duration(minutes: 5));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('+5m'),
                  ),
                ],
                FilledButton.tonalIcon(
                  onPressed: () {
                    ref.read(sleepTimerHandlerProvider.notifier).stop();
                    Navigator.of(context).pop();
                    HapticFeedback.lightImpact();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Custom minutes',
                    hintText: 'Minutes',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _handleCustomInput, child: const Text('Start')),
            ],
          ),
        ],
      ),
    );
  }

  void _startChapterTimer() {
    final started = ref.read(sleepTimerHandlerProvider.notifier).startUntilChapterEnd();
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No chapter available at the current position'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    Navigator.of(context).pop();
    HapticFeedback.lightImpact();
  }

  void _handleCustomInput() {
    final input = _customController.text.trim();
    if (input.isEmpty) return;

    final minutes = int.tryParse(input);
    if (minutes == null || minutes <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text('Not valid'), backgroundColor: Theme.of(context).colorScheme.error));
      return;
    }

    final duration = Duration(minutes: minutes);
    ref.read(sleepTimerHandlerProvider.notifier).start(duration);

    Navigator.of(context).pop();
    HapticFeedback.lightImpact();
  }
}

class SleepTimerOption {
  final String label;
  final Duration duration;

  const SleepTimerOption({required this.label, required this.duration});
}
