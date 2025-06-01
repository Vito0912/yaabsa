// lib/provider/sleep_timer_handler.dart
import 'dart:async';

import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sleep_timer_handler.g.dart';

enum SleepTimerState { inactive, running, paused }

class SleepTimerData {
  final Duration remainingTime;
  final SleepTimerState state;
  final Duration? totalDuration;

  const SleepTimerData({required this.remainingTime, required this.state, this.totalDuration});

  bool get isActive => state != SleepTimerState.inactive;
  bool get isRunning => state == SleepTimerState.running;

  SleepTimerData copyWith({Duration? remainingTime, SleepTimerState? state, Duration? totalDuration}) {
    return SleepTimerData(
      remainingTime: remainingTime ?? this.remainingTime,
      state: state ?? this.state,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

@riverpod
class SleepTimerHandler extends _$SleepTimerHandler {
  Timer? _timer;
  DateTime? _startTime;

  @override
  SleepTimerData build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });

    return const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);
  }

  void start(Duration duration) {
    if (state.isRunning) {
      stop();
    }

    _startTime = DateTime.now();
    _timer?.cancel();

    logger('Sleep timer started for ${duration.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    state = SleepTimerData(remainingTime: duration, state: SleepTimerState.running, totalDuration: duration);

    _startTimer(duration);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;

    logger('Sleep timer stopped', tag: 'SleepTimer', level: InfoLevel.info);

    state = const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);
  }

  void pause() {
    if (!state.isRunning) return;

    _timer?.cancel();
    _timer = null;

    Duration remainingTime = state.remainingTime;
    if (_startTime != null && state.totalDuration != null) {
      final elapsed = DateTime.now().difference(_startTime!);
      remainingTime = state.totalDuration! - elapsed;

      if (remainingTime.isNegative) {
        remainingTime = Duration.zero;
      }
    }

    logger('Sleep timer paused', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(remainingTime: remainingTime, state: SleepTimerState.paused);
  }

  void resume() {
    if (state.state != SleepTimerState.paused || state.remainingTime <= Duration.zero) {
      return;
    }

    _startTime = DateTime.now();

    logger('Sleep timer resumed', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(state: SleepTimerState.running);
    _startTimer(state.remainingTime);
  }

  void extend(Duration additionalTime) {
    if (!state.isActive) return;

    final newRemainingTime = state.remainingTime + additionalTime;
    final newTotalDuration = (state.totalDuration ?? Duration.zero) + additionalTime;

    logger('Sleep timer extended by ${additionalTime.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(remainingTime: newRemainingTime, totalDuration: newTotalDuration);
  }

  void _startTimer(Duration duration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime == null) {
        timer.cancel();
        return;
      }

      final elapsed = DateTime.now().difference(_startTime!);
      final remaining = duration - elapsed;

      if (remaining <= Duration.zero) {
        _onTimerExpired();
        timer.cancel();
      } else {
        if ((state.remainingTime - remaining).abs() >= const Duration(seconds: 5)) {
          state = state.copyWith(remainingTime: remaining);
        }
      }
    });
  }

  void _onTimerExpired() {
    logger('Sleep timer expired, stopping playback', tag: 'SleepTimer', level: InfoLevel.info);

    audioHandler.stop();

    _timer = null;
    _startTime = null;

    state = const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);
  }
}

@riverpod
Duration sleepTimerRemainingTime(Ref ref) {
  return ref.watch(sleepTimerHandlerProvider).remainingTime;
}

@riverpod
SleepTimerState sleepTimerState(Ref ref) {
  return ref.watch(sleepTimerHandlerProvider).state;
}

@riverpod
bool sleepTimerIsActive(Ref ref) {
  return ref.watch(sleepTimerHandlerProvider).isActive;
}
