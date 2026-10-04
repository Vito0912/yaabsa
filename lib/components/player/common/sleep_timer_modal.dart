import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/sleep_timer_handler.dart';

class SleepTimerModal extends ConsumerStatefulWidget {
  const SleepTimerModal({super.key});

  @override
  ConsumerState<SleepTimerModal> createState() => _SleepTimerModalState();
}

class _SleepTimerModalState extends ConsumerState<SleepTimerModal> {
  SleepTimerMode _mode = SleepTimerMode.minutes;
  int? _selectedMinutes;

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
  void initState() {
    super.initState();
    final sleepTimer = ref.read(sleepTimerHandlerProvider);
    _mode = sleepTimer.mode;
    if (sleepTimer.isChapterTimer) {
      _customController.text = '${sleepTimer.configuredChapters ?? 1}';
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sleepTimer = ref.watch(sleepTimerHandlerProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return StreamBuilder(
      stream: audioHandler.chaptersStream,
      initialData: audioHandler.currentMediaItem?.chapters ?? [],
      builder: (context, snapshot) {
        final hasChapters = snapshot.data?.isNotEmpty ?? false;
        final chapterMode = hasChapters && _mode == SleepTimerMode.chapters;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sleepTimer.isActive) ...[const SizedBox(height: 8), _ActiveTimerCard(sleepTimer: sleepTimer)],
                const SizedBox(height: 8),
                Text('Quick start', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._quickOptions.map(
                      (option) => ChoiceChip(
                        label: Text(option.label),
                        selected: !chapterMode && _selectedMinutes == option.duration.inMinutes,
                        showCheckmark: false,
                        onSelected: (_) => _startQuickMinutes(option.duration.inMinutes),
                      ),
                    ),
                    if (hasChapters)
                      ChoiceChip(
                        avatar: const Icon(Icons.skip_next, size: 18),
                        label: const Text('End of chapter'),
                        selected: chapterMode,
                        showCheckmark: false,
                        onSelected: (_) => _startQuickChapterTimer(),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (_) {
                            if (!chapterMode) setState(() => _selectedMinutes = null);
                          },
                          onSubmitted: (_) => _handleCustomInput(chapterMode),
                          decoration: InputDecoration(
                            labelText: chapterMode ? 'Number of chapters' : 'Minutes',
                            hintText: chapterMode ? '1' : 'Minutes',
                            suffixText: chapterMode ? 'chapters' : 'min',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () => _handleCustomInput(chapterMode),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        icon: const Icon(Icons.bedtime),
                        label: const Text('Set'),
                      ),
                    ],
                  ),
                ),
                if (sleepTimer.isActive) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
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
                        onPressed:
                            sleepTimer.isChapterTimer && !ref.read(sleepTimerHandlerProvider.notifier).canExtendChapter
                            ? null
                            : () {
                                final handler = ref.read(sleepTimerHandlerProvider.notifier);
                                if (sleepTimer.isChapterTimer) {
                                  handler.extendChapter();
                                } else {
                                  handler.extend(const Duration(minutes: 5));
                                }
                              },
                        icon: const Icon(Icons.add),
                        label: Text(sleepTimer.isChapterTimer ? 'Add chapter' : 'Add 5 min'),
                      ),
                      TextButton.icon(
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
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _startQuickMinutes(int minutes) {
    setState(() {
      _mode = SleepTimerMode.minutes;
      _selectedMinutes = minutes;
      _customController.text = '$minutes';
    });
    ref.read(sleepTimerHandlerProvider.notifier).start(Duration(minutes: minutes));
    HapticFeedback.lightImpact();
  }

  void _startQuickChapterTimer() {
    setState(() {
      _mode = SleepTimerMode.chapters;
      _selectedMinutes = null;
      _customController.text = '1';
    });
    _startChapters(1, closeModal: false);
  }

  void _startChapters(int count, {bool closeModal = true}) {
    if (!ref.read(sleepTimerHandlerProvider.notifier).startChapters(count)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No chapter is available at the current position'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (closeModal) Navigator.of(context).pop();
    HapticFeedback.lightImpact();
  }

  void _handleCustomInput(bool chapterMode) {
    final input = _customController.text.trim();
    if (input.isEmpty) return;

    final value = int.tryParse(input);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter a number greater than zero'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (chapterMode) {
      _startChapters(value);
      return;
    }
    final duration = Duration(minutes: value);
    ref.read(sleepTimerHandlerProvider.notifier).start(duration);

    Navigator.of(context).pop();
    HapticFeedback.lightImpact();
  }
}

class _ActiveTimerCard extends StatelessWidget {
  const _ActiveTimerCard({required this.sleepTimer});

  final SleepTimerData sleepTimer;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final description = sleepTimer.isChapterTimer
        ? '${sleepTimer.remainingChapters} chapter${sleepTimer.remainingChapters == 1 ? '' : 's'} remaining'
              ' • ${sleepTimer.remainingTime.toCompactRemainingString()} remaining'
        : '${sleepTimer.remainingTime.toCompactRemainingString()} remaining';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(
            sleepTimer.isRunning ? Icons.timer_outlined : Icons.pause_circle_outline,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sleepTimer.isRunning ? 'Timer active' : 'Timer paused',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onSecondaryContainer),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.onSecondaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SleepTimerOption {
  final String label;
  final Duration duration;

  const SleepTimerOption({required this.label, required this.duration});
}
