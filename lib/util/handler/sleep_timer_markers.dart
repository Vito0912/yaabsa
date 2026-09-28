part of 'sleep_timer_handler.dart';

const _sleepTimerMarkerPinVisibilityDuration = Duration(seconds: 10);

extension SleepTimerMarkers on SleepTimerHandler {
  Future<void> _persistMarker(SleepTimerMarker? marker) async {
    try {
      await _settings.setGlobalSetting<String>(SettingKeys.sleepTimerMarker, marker?.toRawJson() ?? '');
    } catch (e) {
      logger('Failed to persist sleep timer marker: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    }
  }

  void _cancelMarkerVisibilityTimers() {
    _markerPinHideTimer?.cancel();
    _markerPinHideTimer = null;
    _markerRangeHideTimer?.cancel();
    _markerRangeHideTimer = null;
  }

  void _setMarkerVisibility({bool? showPin, bool? showRange, bool? forceMarkerVisibility}) {
    final marker = _data.marker;
    if (marker == null) {
      return;
    }

    final nextShowPin = showPin ?? _data.showMarkerPin;
    final nextShowRange = showRange ?? _data.showMarkerRange;
    final nextForceMarkerVisibility = forceMarkerVisibility ?? _data.forceMarkerVisibility;
    if (nextShowPin == _data.showMarkerPin &&
        nextShowRange == _data.showMarkerRange &&
        nextForceMarkerVisibility == _data.forceMarkerVisibility) {
      return;
    }

    _data = _data.copyWith(
      marker: marker,
      showMarkerPin: nextShowPin,
      showMarkerRange: nextShowRange,
      forceMarkerVisibility: nextForceMarkerVisibility,
    );
  }

  void _showMarker({bool showPin = true}) {
    final marker = _data.marker;
    if (marker == null) {
      return;
    }

    _markerPinHideTimer?.cancel();
    _markerPinHideTimer = null;
    _markerRangeHideTimer?.cancel();
    _markerRangeHideTimer = null;
    final hasEnded = marker.endPosition != null;
    _setMarkerVisibility(showPin: showPin && hasEnded, showRange: hasEnded);
  }

  void _scheduleMarkerPinHide() {
    if (_data.marker == null || !_data.showMarkerPin) {
      return;
    }

    _markerPinHideTimer?.cancel();
    _markerPinHideTimer = Timer(_sleepTimerMarkerPinVisibilityDuration, () {
      _markerPinHideTimer = null;
      _setMarkerVisibility(showPin: false, showRange: false, forceMarkerVisibility: false);
    });
  }

  void dismissMarkerPin() {
    if (_data.marker == null) {
      return;
    }

    _markerPinHideTimer?.cancel();
    _markerPinHideTimer = null;
    _markerRangeHideTimer?.cancel();
    _setMarkerVisibility(showPin: false, showRange: true, forceMarkerVisibility: false);
    _markerRangeHideTimer = Timer(_sleepTimerMarkerPinVisibilityDuration, () {
      _markerRangeHideTimer = null;
      _setMarkerVisibility(showRange: false);
    });
  }

  bool toggleSleepTimerMarker() {
    final marker = _data.marker;
    final media = audioHandler.currentMediaItem;
    if (marker == null || media == null || !marker.matches(itemId: media.itemId, episodeId: media.episodeId)) {
      return false;
    }

    final showMarkerSetting = _settings.getGlobalSetting<bool>(SettingKeys.sleepTimerShowMarker);
    final isMarkerVisible =
        _data.forceMarkerVisibility || (showMarkerSetting && (_data.showMarkerPin || _data.showMarkerRange));
    if (isMarkerVisible) {
      _cancelMarkerVisibilityTimers();
      _data = _data.copyWith(showMarkerPin: false, showMarkerRange: false, forceMarkerVisibility: false);
      return true;
    }

    final markerWithEnd = marker.endPosition == null ? _completeMarkerAtCurrentPosition() : marker;
    if (markerWithEnd == null) {
      return false;
    }

    _cancelMarkerVisibilityTimers();
    _data = _data.copyWith(
      marker: markerWithEnd,
      showMarkerPin: markerWithEnd.endPosition != null,
      showMarkerRange: markerWithEnd.endPosition != null,
      forceMarkerVisibility: true,
    );
    unawaited(_persistMarker(markerWithEnd));
    return true;
  }

  SleepTimerMarker? _createMarker() {
    final media = audioHandler.currentMediaItem;
    if (media == null) {
      return null;
    }

    return SleepTimerMarker(itemId: media.itemId, episodeId: media.episodeId, startPosition: audioHandler.position);
  }

  SleepTimerMarker? _completeMarkerAtCurrentPosition() {
    final marker = _data.marker;
    final media = audioHandler.currentMediaItem;
    if (marker == null || media == null || !marker.matches(itemId: media.itemId, episodeId: media.episodeId)) {
      return marker;
    }

    return marker.copyWith(endPosition: audioHandler.position);
  }
}
