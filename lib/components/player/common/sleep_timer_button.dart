import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SleepTimerButton extends ConsumerWidget {
  const SleepTimerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepTimer = ref.watch(sleepTimerHandlerProvider);
    final isActive = sleepTimer.isActive;
    final label = isActive ? 'Sleep ${_formatTime(sleepTimer.remainingTime)}' : 'Sleep timer';

    return OutlinedButton.icon(
      onPressed: () => _showSleepTimerModal(context, ref),
      icon: Icon(isActive ? Icons.bedtime : Icons.bedtime_outlined),
      label: Text(label),
    );
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  void _showSleepTimerModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SleepTimerModal(ref: ref),
    );
  }
}

class SleepTimerModal extends StatefulWidget {
  final WidgetRef ref;

  const SleepTimerModal({super.key, required this.ref});

  @override
  State<SleepTimerModal> createState() => _SleepTimerModalState();
}

class _SleepTimerModalState extends State<SleepTimerModal> {
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
    final sleepTimer = widget.ref.watch(sleepTimerHandlerProvider);
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
            Text('Remaining ${_formatTime(sleepTimer.remainingTime)}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickOptions
                .map(
                  (option) => ActionChip(
                    label: Text(option.label),
                    onPressed: () {
                      widget.ref.read(sleepTimerHandlerProvider.notifier).start(option.duration);
                      Navigator.of(context).pop();
                      HapticFeedback.lightImpact();
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          if (sleepTimer.isActive)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    if (sleepTimer.isRunning) {
                      widget.ref.read(sleepTimerHandlerProvider.notifier).pause();
                    } else {
                      widget.ref.read(sleepTimerHandlerProvider.notifier).resume();
                    }
                    setState(() {});
                  },
                  icon: Icon(sleepTimer.isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(sleepTimer.isRunning ? 'Pause' : 'Resume'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    widget.ref.read(sleepTimerHandlerProvider.notifier).extend(const Duration(minutes: 5));
                    setState(() {});
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('+5m'),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    widget.ref.read(sleepTimerHandlerProvider.notifier).stop();
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
    widget.ref.read(sleepTimerHandlerProvider.notifier).start(duration);

    Navigator.of(context).pop();
    HapticFeedback.lightImpact();
  }

  String _formatTime(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

class SleepTimerOption {
  final String label;
  final Duration duration;

  const SleepTimerOption({required this.label, required this.duration});
}
