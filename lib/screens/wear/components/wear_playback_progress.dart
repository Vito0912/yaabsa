import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/screens/wear/components/wear_activity_scope.dart';
import 'package:yaabsa/util/extensions.dart';

class WearPlaybackPosition extends StatefulWidget {
  const WearPlaybackPosition({required this.builder, super.key});

  final Widget Function(BuildContext context, Duration position, Duration total) builder;

  @override
  State<WearPlaybackPosition> createState() => _WearPlaybackPositionState();
}

class _WearPlaybackPositionState extends State<WearPlaybackPosition> {
  StreamSubscription<Duration>? _subscription;
  Duration _position = Duration.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription?.cancel();
    _subscription = null;
    _position = wearAudioHandler.position;

    final active = WearActivityScope.isActive(context) && (ModalRoute.isCurrentOf(context) ?? true);
    if (active) {
      _subscription = wearAudioHandler.player
          .createPositionStream(minPeriod: const Duration(seconds: 1), maxPeriod: const Duration(seconds: 1))
          .listen((_) {
            if (mounted) {
              setState(() {
                _position = wearAudioHandler.position;
              });
            }
          });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = wearAudioHandler.media?.totalDuration ?? Duration.zero;
    return widget.builder(context, _position, total);
  }
}

class WearPlaybackTime extends StatelessWidget {
  const WearPlaybackTime({super.key});

  @override
  Widget build(BuildContext context) {
    return WearPlaybackPosition(
      builder: (context, position, total) {
        return Text(
          '${position.toCompactClockString()} / ${total.toCompactClockString()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, height: 1.1, decoration: TextDecoration.none),
        );
      },
    );
  }
}
