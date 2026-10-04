import 'dart:convert';

enum SleepTimerMode { minutes, chapters }

enum SleepTimerState { inactive, running, paused }

class SleepTimerData {
  final SleepTimerMode mode;
  final int? configuredChapters;
  final int? remainingChapters;
  final int? targetChapterIndex;
  final Duration remainingTime;
  final SleepTimerState state;
  final Duration? totalDuration;
  final SleepTimerMarker? marker;
  final bool? _showMarkerPinValue;
  final bool? _showMarkerRangeValue;
  final bool? _forceMarkerVisibilityValue;

  const SleepTimerData({
    this.mode = SleepTimerMode.minutes,
    this.configuredChapters,
    this.remainingChapters,
    this.targetChapterIndex,
    required this.remainingTime,
    required this.state,
    this.totalDuration,
    this.marker,
    bool showMarkerPin = true,
    bool showMarkerRange = true,
    bool forceMarkerVisibility = false,
  }) : _showMarkerPinValue = showMarkerPin,
       _showMarkerRangeValue = showMarkerRange,
       _forceMarkerVisibilityValue = forceMarkerVisibility;

  bool get showMarkerPin => _showMarkerPinValue ?? marker?.endPosition != null;
  bool get showMarkerRange => _showMarkerRangeValue ?? marker?.endPosition != null;
  bool get forceMarkerVisibility => _forceMarkerVisibilityValue ?? false;

  bool get isChapterTimer => mode == SleepTimerMode.chapters;

  bool get isActive => state != SleepTimerState.inactive;
  bool get isRunning => state == SleepTimerState.running;

  SleepTimerData copyWith({
    int? configuredChapters,
    int? remainingChapters,
    int? targetChapterIndex,
    Duration? remainingTime,
    SleepTimerState? state,
    Duration? totalDuration,
    SleepTimerMarker? marker,
    bool? showMarkerPin,
    bool? showMarkerRange,
    bool? forceMarkerVisibility,
  }) {
    return SleepTimerData(
      mode: mode,
      configuredChapters: configuredChapters ?? this.configuredChapters,
      remainingChapters: remainingChapters ?? this.remainingChapters,
      targetChapterIndex: targetChapterIndex ?? this.targetChapterIndex,
      remainingTime: remainingTime ?? this.remainingTime,
      state: state ?? this.state,
      totalDuration: totalDuration ?? this.totalDuration,
      marker: marker ?? this.marker,
      showMarkerPin: showMarkerPin ?? this.showMarkerPin,
      showMarkerRange: showMarkerRange ?? this.showMarkerRange,
      forceMarkerVisibility: forceMarkerVisibility ?? this.forceMarkerVisibility,
    );
  }
}

class SleepTimerMarker {
  const SleepTimerMarker({
    required this.itemId,
    required this.episodeId,
    required this.startPosition,
    this.endPosition,
  });

  final String itemId;
  final String? episodeId;
  final Duration startPosition;
  final Duration? endPosition;

  SleepTimerMarker copyWith({Duration? endPosition, bool clearEndPosition = false}) {
    return SleepTimerMarker(
      itemId: itemId,
      episodeId: episodeId,
      startPosition: startPosition,
      endPosition: clearEndPosition ? null : endPosition ?? this.endPosition,
    );
  }

  bool matches({required String itemId, required String? episodeId}) {
    return this.itemId == itemId && this.episodeId == episodeId;
  }

  String toRawJson() {
    return jsonEncode(<String, Object?>{
      'itemId': itemId,
      'episodeId': episodeId,
      'startPositionMicros': startPosition.inMicroseconds,
      'endPositionMicros': endPosition?.inMicroseconds,
    });
  }

  static SleepTimerMarker? fromRawJson(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }

      final itemId = decoded['itemId'];
      final episodeId = decoded['episodeId'];
      final startPositionMicros = decoded['startPositionMicros'];
      final endPositionMicros = decoded['endPositionMicros'];
      if (itemId is! String || itemId.trim().isEmpty || startPositionMicros is! num) {
        return null;
      }

      return SleepTimerMarker(
        itemId: itemId.trim(),
        episodeId: episodeId is String && episodeId.trim().isNotEmpty ? episodeId.trim() : null,
        startPosition: Duration(microseconds: startPositionMicros.toInt()),
        endPosition: endPositionMicros is num ? Duration(microseconds: endPositionMicros.toInt()) : null,
      );
    } catch (_) {
      return null;
    }
  }
}
