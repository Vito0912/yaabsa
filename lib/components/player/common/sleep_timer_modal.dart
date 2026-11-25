import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:yaabsa/features/player/widgets/sleep_timer_active_presentation.dart';
import 'package:yaabsa/features/player/widgets/sleep_timer_custom_input.dart';
import 'package:yaabsa/util/l10n.dart';

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
    SleepTimerOption(duration: Duration(minutes: 5)),
    SleepTimerOption(duration: Duration(minutes: 10)),
    SleepTimerOption(duration: Duration(minutes: 15)),
    SleepTimerOption(duration: Duration(minutes: 30)),
    SleepTimerOption(duration: Duration(minutes: 45)),
    SleepTimerOption(duration: Duration(minutes: 60)),
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
                if (sleepTimer.isActive) ...[const SizedBox(height: 8), _buildActiveTimerPresentation(sleepTimer)],
                const SizedBox(height: 8),
                Text(context.l10n.sleepTimerQuickStart, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._quickOptions.map(
                      (option) => ChoiceChip(
                        label: Text(context.l10n.durationCompactMinutes(option.duration.inMinutes)),
                        selected: !chapterMode && _selectedMinutes == option.duration.inMinutes,
                        showCheckmark: false,
                        onSelected: (_) => _startQuickMinutes(option.duration.inMinutes),
                      ),
                    ),
                    if (hasChapters)
                      ChoiceChip(
                        avatar: const Icon(Icons.skip_next, size: 18),
                        label: Text(context.l10n.sleepTimerEndOfChapter),
                        selected: chapterMode,
                        showCheckmark: false,
                        onSelected: (_) => _startQuickChapterTimer(),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                SleepTimerCustomInput(
                  controller: _customController,
                  chapterMode: chapterMode,
                  onChanged: (_) {
                    if (!chapterMode) {
                      setState(() => _selectedMinutes = null);
                    }
                  },
                  onSet: () => _handleCustomInput(chapterMode),
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
                        label: Text(sleepTimer.isRunning ? context.l10n.playbackPause : context.l10n.actionResume),
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
                        label: Text(
                          sleepTimer.isChapterTimer
                              ? context.l10n.sleepTimerAddChapter
                              : context.l10n.sleepTimerAddMinutes(5),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ref.read(sleepTimerHandlerProvider.notifier).stop();
                          Navigator.of(context).pop();
                          HapticFeedback.lightImpact();
                        },
                        icon: const Icon(Icons.stop),
                        label: Text(context.l10n.playbackStop),
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
          content: Text(context.l10n.sleepTimerNoChapterAvailable),
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
          content: Text(context.l10n.validationPositiveNumberRequired),
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

  Widget _buildActiveTimerPresentation(SleepTimerData sleepTimer) {
    final timeRemaining = sleepTimer.remainingTime.toCompactRemainingString();
    final description = sleepTimer.isChapterTimer
        ? '${context.l10n.sleepTimerChaptersRemaining(sleepTimer.remainingChapters ?? 0)} · $timeRemaining'
        : '$timeRemaining remaining';

    return SleepTimerActivePresentation(isRunning: sleepTimer.isRunning, description: description);
  }
}

class SleepTimerOption {
  final Duration duration;

  const SleepTimerOption({required this.duration});
}
