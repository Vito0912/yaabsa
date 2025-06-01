import 'dart:math' as math;

import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: needs to be replaced with a more (design) fitting, non boilerplate solution
class SleepTimerButton extends ConsumerWidget {
  const SleepTimerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepTimer = ref.watch(sleepTimerHandlerProvider);
    final isActive = sleepTimer.isActive;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showSleepTimerModal(context, ref),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isActive ? Theme.of(context).colorScheme.primary.withOpacity(0.3) : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? Icons.bedtime : Icons.bedtime_outlined,
                    key: ValueKey(isActive),
                    color:
                        isActive
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    isActive ? _formatTime(sleepTimer.remainingTime) : 'Sleep Timer',
                    key: ValueKey(isActive ? sleepTimer.remainingTime.inSeconds : 0),
                    style: TextStyle(
                      color:
                          isActive
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (isActive) ...[const SizedBox(width: 8), _buildProgressIndicator(context, sleepTimer)],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, SleepTimerData sleepTimer) {
    final progress =
        sleepTimer.totalDuration != null && sleepTimer.totalDuration!.inSeconds > 0
            ? 1 - (sleepTimer.remainingTime.inSeconds / sleepTimer.totalDuration!.inSeconds)
            : 0.0;

    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          progress: progress,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SleepTimerModal(ref: ref),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _CircularProgressPainter({required this.progress, required this.color, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SleepTimerModal extends StatefulWidget {
  final WidgetRef ref;

  const SleepTimerModal({Key? key, required this.ref}) : super(key: key);

  @override
  State<SleepTimerModal> createState() => _SleepTimerModalState();
}

class _SleepTimerModalState extends State<SleepTimerModal> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _customController = TextEditingController();

  final List<SleepTimerOption> _quickOptions = [
    SleepTimerOption(label: 'Stop Timer', duration: Duration.zero, icon: Icons.stop_circle_outlined, isStop: true),
    SleepTimerOption(label: '5 Seconds', duration: const Duration(seconds: 5), icon: Icons.hourglass_bottom),
    SleepTimerOption(label: '1 Minute', duration: const Duration(minutes: 1), icon: Icons.timer_outlined),
    SleepTimerOption(label: '5 Minutes', duration: const Duration(minutes: 5), icon: Icons.timer_3_outlined),
    SleepTimerOption(label: '15 Minutes', duration: const Duration(minutes: 15), icon: Icons.timer_10_outlined),
    SleepTimerOption(label: '30 Minutes', duration: const Duration(minutes: 30), icon: Icons.schedule),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sleepTimer = widget.ref.watch(sleepTimerHandlerProvider);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, sleepTimer),
                _buildQuickOptions(context),
                _buildCustomInput(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SleepTimerData sleepTimer) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.bedtime, color: Theme.of(context).colorScheme.onPrimary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sleep Timer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (sleepTimer.isActive) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Remaining: ${_formatTime(sleepTimer.remainingTime)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Select', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _quickOptions.length,
            itemBuilder: (context, index) {
              final option = _quickOptions[index];
              return _buildOptionTile(context, option);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, SleepTimerOption option) {
    final isStop = option.isStop;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleOptionTap(option),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isStop ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isStop
                      ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                      : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                option.icon,
                size: 20,
                color:
                    isStop
                        ? Theme.of(context).colorScheme.onErrorContainer
                        : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  option.label,
                  style: TextStyle(
                    color:
                        isStop
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Edit', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Minutes',
                    prefixIcon: const Icon(Icons.edit_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: _handleCustomInput,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Icon(Icons.check),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleOptionTap(SleepTimerOption option) {
    final handler = widget.ref.read(sleepTimerHandlerProvider.notifier);

    if (option.isStop) {
      handler.stop();
    } else {
      handler.start(option.duration);
    }

    Navigator.of(context).pop();

    // TODO: When testing for Android again, check what HapticFeedback does specifically (maybe solution for vibration) and in general for better UX
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
  final IconData icon;
  final bool isStop;

  const SleepTimerOption({required this.label, required this.duration, required this.icon, this.isStop = false});
}
