import 'dart:async';

import 'package:buchshelfly/util/globals.dart'; // Assuming audioHandler is here
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayBar extends HookWidget {
  const PlayBar({super.key});

  String _formatDuration(Duration? duration) {
    if (duration == null) return "--:--";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to streams from the audio handler
    final currentPosition =
        useStream(audioHandler.positionStream).data ?? Duration.zero;
    final totalDuration =
        useStream(audioHandler.durationStream).data ?? Duration.zero;

    // State for managing scrubbing behavior
    final scrubbingPosition = useState<double?>(
      null,
    ); // Visual position during scrub in seconds
    final isScrubbing = useState<bool>(
      false,
    ); // True if user is dragging the slider
    final lastSentSeekTime = useRef<DateTime?>(
      null,
    ); // Timestamp of the last sent seek command
    final onChangeEndDebounceTimer = useRef<Timer?>(
      null,
    ); // Timer for debouncing final seek

    // Determine the value to display on the slider
    double displaySliderValue;
    Duration displayCurrentTime;

    if (isScrubbing.value && scrubbingPosition.value != null) {
      displaySliderValue = scrubbingPosition.value!;
      displayCurrentTime = Duration(seconds: scrubbingPosition.value!.round());
    } else {
      displaySliderValue = currentPosition.inSeconds.toDouble();
      displayCurrentTime = currentPosition;
    }

    final maxSliderValue = totalDuration.inSeconds.toDouble();

    // Effect for cleaning up the debounce timer
    useEffect(
      () {
        return () {
          onChangeEndDebounceTimer.value?.cancel();
        };
      },
      const [],
    ); // Empty dependency array means this runs once on mount and cleanup on unmount

    // Function to actually send the seek command
    void _executeSeek(double seconds) {
      final seekPosition = Duration(seconds: seconds.round());
      // print('PlayBar: Sending seek to $seekPosition');
      audioHandler.seek(seekPosition);
      lastSentSeekTime.value = DateTime.now();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Track Button (Example - Add functionality if needed)
              // IconButton(
              //   icon: const Icon(Icons.skip_previous, color: Colors.black),
              //   iconSize: 36.0,
              //   onPressed: audioHandler.skipToPrevious,
              // ),
              // const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                iconSize: 36.0,
                onPressed: audioHandler.play,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.pause, color: Colors.black),
                iconSize: 36.0,
                onPressed: audioHandler.pause,
              ),
              // const SizedBox(width: 16),
              // Next Track Button (Example - Add functionality if needed)
              // IconButton(
              //   icon: const Icon(Icons.skip_next, color: Colors.black),
              //   iconSize: 36.0,
              //   onPressed: audioHandler.skipToNext,
              // ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                _formatDuration(displayCurrentTime),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  value: displaySliderValue.clamp(
                    0.0,
                    maxSliderValue > 0 ? maxSliderValue : 0.0,
                  ),
                  min: 0.0,
                  max:
                      maxSliderValue > 0
                          ? maxSliderValue
                          : 1.0, // Avoid max <= min
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                  onChangeStart:
                      maxSliderValue <= 0
                          ? null
                          : (startValue) {
                            isScrubbing.value = true;
                            scrubbingPosition.value = startValue;
                            onChangeEndDebounceTimer.value?.cancel();
                            // print('PlayBar: Scrubbing started at ${Duration(seconds: startValue.round())}');
                          },
                  onChanged:
                      maxSliderValue <= 0
                          ? null
                          : (newValue) {
                            scrubbingPosition.value = newValue;
                            if (!isScrubbing.value) {
                              isScrubbing.value = true;
                            }

                            final now = DateTime.now();
                            if (lastSentSeekTime.value == null ||
                                now.difference(lastSentSeekTime.value!) >
                                    const Duration(seconds: 1)) {
                              _executeSeek(newValue);
                            }
                          },
                  onChangeEnd:
                      maxSliderValue <= 0
                          ? null
                          : (endValue) {
                            onChangeEndDebounceTimer.value?.cancel();
                            onChangeEndDebounceTimer
                                .value = Timer(const Duration(milliseconds: 50), () {
                              _executeSeek(endValue);
                              isScrubbing.value = false;
                              // Optional: Clear scrubbingPosition to snap to player's actual currentPosition.
                              // If player updates slowly, slider might jump.
                              // Keeping it null makes it rely on the stream for the next update.
                              // scrubbingPosition.value = null;
                              // print('PlayBar: Scrubbing ended, final seek to ${Duration(seconds: endValue.round())}');
                            });
                          },
                ),
              ),
              Text(
                _formatDuration(totalDuration),
                style: const TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
