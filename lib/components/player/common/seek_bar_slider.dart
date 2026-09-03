import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:yaabsa/util/setting_key.dart';

enum SeekTimelineMarkerType { chapter, bookmark }

class SeekTimelineMarker {
  const SeekTimelineMarker({required this.position, required this.type});

  final Duration position;
  final SeekTimelineMarkerType type;
}

class _SeekTimelineMarkerOffset {
  const _SeekTimelineMarkerOffset({required this.offset, required this.type});

  final double offset;
  final SeekTimelineMarkerType type;
}

class _MarkerPaintProfile {
  const _MarkerPaintProfile({required this.width, required this.alpha});

  final double width;
  final double alpha;
}

class _FullWidthRoundedSliderTrackShape extends RoundedRectSliderTrackShape {
  const _FullWidthRoundedSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 0;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(offset.dx, trackTop, parentBox.size.width, trackHeight);
  }
}

class SeekBarSlider extends StatefulWidget {
  const SeekBarSlider({
    super.key,
    required this.trackHeight,
    required this.timeLabelsBelow,
    required this.rangeStart,
    required this.rangeEnd,
    required this.sliderValue,
    required this.maxSliderValue,
    required this.hasSeekRange,
    required this.markers,
    required this.markerMode,
    required this.executeSeek,
    required this.buildPreviewLabel,
    this.previewLabelFontSize,
    this.sleepTimerMarker,
    this.showSleepTimerPin = true,
    this.showSleepTimerRange = true,
    this.onSleepTimerMarkerTap,
  });

  final double trackHeight;
  final bool timeLabelsBelow;
  final Duration rangeStart;
  final Duration rangeEnd;
  final double sliderValue;
  final double maxSliderValue;
  final bool hasSeekRange;
  final List<SeekTimelineMarker> markers;
  final SeekBarMarkerMode markerMode;
  final Future<void> Function(double seconds) executeSeek;
  final String Function(Duration position) buildPreviewLabel;
  final double? previewLabelFontSize;
  final SleepTimerMarker? sleepTimerMarker;
  final bool showSleepTimerPin;
  final bool showSleepTimerRange;
  final Future<void> Function()? onSleepTimerMarkerTap;

  @override
  State<SeekBarSlider> createState() => _SeekBarSliderState();
}

class _SeekBarSliderState extends State<SeekBarSlider> {
  static const Duration _backendSeekInterval = Duration(milliseconds: 120);
  static const double _sleepTimerPinHitboxSize = 48;
  static const double _sleepTimerPinVisualSize = 28;
  static const double _sleepTimerPinLayoutHeight = 32;

  double? _dragValue;
  bool _isDragging = false;
  double? _queuedSeekValue;
  bool _seekLoopActive = false;
  DateTime? _lastBackendSeekAt;
  double? _previewOffset;
  Duration? _previewPosition;
  String? _cachedPreviewKey;
  double _cachedPreviewWidth = 0;
  List<SeekTimelineMarker>? _cachedMarkers;
  Duration? _cachedRangeStart;
  Duration? _cachedRangeEnd;
  double? _cachedSliderWidth;
  List<_SeekTimelineMarkerOffset> _cachedMarkerOffsets = const <_SeekTimelineMarkerOffset>[];
  bool _isSleepTimerPinHovered = false;

  void _setSleepTimerPinHovered(bool hovered) {
    if (_isSleepTimerPinHovered == hovered) {
      return;
    }

    setState(() => _isSleepTimerPinHovered = hovered);
  }

  double? _resolvePositionOffset(Duration position, double sliderWidth) {
    final rangeDuration = widget.rangeEnd - widget.rangeStart;
    if (rangeDuration <= Duration.zero || sliderWidth <= 0) {
      return null;
    }

    final ratio = ((position - widget.rangeStart).inMicroseconds / rangeDuration.inMicroseconds)
        .clamp(0.0, 1.0)
        .toDouble();
    return ratio * sliderWidth;
  }

  void _handleSliderChangeStart(double value) {
    setState(() {
      _isDragging = true;
      _dragValue = value;
    });
  }

  void _handleSliderChanged(double value) {
    if (_dragValue != value) {
      setState(() => _dragValue = value);
    }
    _queueBackendSeek(value);
  }

  void _handleSliderChangeEnd(double value) {
    setState(() {
      _isDragging = false;
      _dragValue = value;
    });
    _queueBackendSeek(value);
  }

  void _queueBackendSeek(double value) {
    _queuedSeekValue = value;
    if (!_seekLoopActive) {
      unawaited(_drainSeekQueue());
    }
  }

  Future<void> _drainSeekQueue() async {
    _seekLoopActive = true;
    try {
      while (mounted && _queuedSeekValue != null) {
        final lastSeekAt = _lastBackendSeekAt;
        if (lastSeekAt != null) {
          final elapsed = DateTime.now().difference(lastSeekAt);
          if (elapsed < _backendSeekInterval) {
            await Future<void>.delayed(_backendSeekInterval - elapsed);
          }
        }
        if (!mounted || _queuedSeekValue == null) {
          break;
        }
        final value = _queuedSeekValue!;
        _queuedSeekValue = null;
        _lastBackendSeekAt = DateTime.now();
        await widget.executeSeek(value);
      }
    } finally {
      _seekLoopActive = false;
      if (mounted && _queuedSeekValue != null) {
        unawaited(_drainSeekQueue());
      }
    }
  }

  @override
  void didUpdateWidget(SeekBarSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && _dragValue != null && oldWidget.sliderValue != widget.sliderValue) {
      _dragValue = null;
    }
  }

  @override
  void dispose() {
    _queuedSeekValue = null;
    super.dispose();
  }

  List<_SeekTimelineMarkerOffset> _resolveMarkerOffsetsCached(double sliderWidth) {
    final shouldRefresh =
        !identical(_cachedMarkers, widget.markers) ||
        _cachedRangeStart != widget.rangeStart ||
        _cachedRangeEnd != widget.rangeEnd ||
        _cachedSliderWidth == null ||
        (_cachedSliderWidth! - sliderWidth).abs() >= 0.5;

    if (!shouldRefresh) {
      return _cachedMarkerOffsets;
    }

    const trackInset = 0.0;
    final trackWidth = sliderWidth;
    _cachedMarkerOffsets =
        _resolveMarkerOffsets(
              markers: widget.markers,
              rangeStart: widget.rangeStart,
              rangeEnd: widget.rangeEnd,
              sliderWidth: trackWidth,
            )
            .map((marker) {
              return _SeekTimelineMarkerOffset(offset: marker.offset + trackInset, type: marker.type);
            })
            .toList(growable: false);
    _cachedMarkers = widget.markers;
    _cachedRangeStart = widget.rangeStart;
    _cachedRangeEnd = widget.rangeEnd;
    _cachedSliderWidth = sliderWidth;
    return _cachedMarkerOffsets;
  }

  void _updatePreview({required double dx, required double sliderWidth, required Duration rangeDuration}) {
    if (!widget.hasSeekRange || sliderWidth <= 0) {
      _clearPreview();
      return;
    }

    final clampedDx = dx.clamp(0.0, sliderWidth).toDouble();
    final ratio = clampedDx / sliderWidth;
    final positionMs = widget.rangeStart.inMilliseconds + (rangeDuration.inMilliseconds * ratio).round();
    final nextPosition = Duration(milliseconds: positionMs);

    final offsetChanged = _previewOffset == null || (_previewOffset! - clampedDx).abs() >= 0.5;
    final positionChanged = _previewPosition != nextPosition;
    if (!offsetChanged && !positionChanged) {
      return;
    }

    setState(() {
      _previewOffset = clampedDx;
      _previewPosition = nextPosition;
    });
  }

  void _clearPreview() {
    if (_previewOffset == null && _previewPosition == null) {
      return;
    }

    setState(() {
      _previewOffset = null;
      _previewPosition = null;
      _cachedPreviewKey = null;
      _cachedPreviewWidth = 0;
    });
  }

  double _measurePreviewWidth({
    required String label,
    required TextStyle textStyle,
    required double maxWidth,
    required TextDirection textDirection,
  }) {
    final measurementKey = '$label|${textStyle.hashCode}|${maxWidth.round()}';
    if (_cachedPreviewKey == measurementKey) {
      return _cachedPreviewWidth;
    }

    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      maxLines: 1,
      textDirection: textDirection,
    )..layout(maxWidth: maxWidth);

    _cachedPreviewKey = measurementKey;
    _cachedPreviewWidth = textPainter.width + 14;
    return _cachedPreviewWidth;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.timeLabelsBelow ? 0 : 4),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          padding: EdgeInsets.zero,
          trackHeight: widget.trackHeight,
          trackShape: const _FullWidthRoundedSliderTrackShape(),
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 5,
            disabledThumbRadius: 0,
            elevation: 0,
            pressedElevation: 1,
          ),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          activeTrackColor: colorScheme.primary,
          inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.22),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sliderWidth = constraints.maxWidth;
            final rangeDuration = widget.rangeEnd - widget.rangeStart;
            final markerOffsets = _resolveMarkerOffsetsCached(sliderWidth);
            final markerProfile = _resolveMarkerPaintProfile(markerOffsets.length);
            final sleepTimerMarker = widget.sleepTimerMarker;
            final sleepTimerStartOffset = sleepTimerMarker == null
                ? null
                : _resolvePositionOffset(sleepTimerMarker.startPosition, sliderWidth);
            final sleepTimerEndOffset = sleepTimerMarker?.endPosition == null || !widget.showSleepTimerRange
                ? null
                : _resolvePositionOffset(sleepTimerMarker!.endPosition!, sliderWidth);
            final sleepTimerRangeStart = sleepTimerStartOffset == null || sleepTimerEndOffset == null
                ? null
                : sleepTimerStartOffset < sleepTimerEndOffset
                ? sleepTimerStartOffset
                : sleepTimerEndOffset;
            final sleepTimerRangeEnd = sleepTimerStartOffset == null || sleepTimerEndOffset == null
                ? null
                : sleepTimerStartOffset > sleepTimerEndOffset
                ? sleepTimerStartOffset
                : sleepTimerEndOffset;

            final previewPosition = _previewPosition;
            final previewLabel = previewPosition == null ? null : widget.buildPreviewLabel(previewPosition);

            final basePreviewStyle = theme.textTheme.labelMedium ?? const TextStyle(fontSize: 12);
            final previewTextStyle = basePreviewStyle.copyWith(
              color: colorScheme.onSurface,
              fontSize: widget.previewLabelFontSize ?? basePreviewStyle.fontSize ?? 12,
              height: 1.1,
            );

            final previewWidth = previewLabel == null
                ? 0.0
                : _measurePreviewWidth(
                    label: previewLabel,
                    textStyle: previewTextStyle,
                    maxWidth: sliderWidth,
                    textDirection: Directionality.of(context),
                  );

            final previewLeft = _previewOffset == null || previewLabel == null
                ? 0.0
                : (_previewOffset! - (previewWidth / 2))
                      .clamp(0.0, sliderWidth > previewWidth ? sliderWidth - previewWidth : 0.0)
                      .toDouble();
            final showSleepTimerPin = sleepTimerStartOffset != null && widget.showSleepTimerPin;
            final previewTop = showSleepTimerPin ? -14.0 : -20.0;

            return MouseRegion(
              onEnter: widget.hasSeekRange
                  ? (event) {
                      _updatePreview(
                        dx: event.localPosition.dx,
                        sliderWidth: sliderWidth,
                        rangeDuration: rangeDuration,
                      );
                    }
                  : null,
              onHover: widget.hasSeekRange
                  ? (event) {
                      _updatePreview(
                        dx: event.localPosition.dx,
                        sliderWidth: sliderWidth,
                        rangeDuration: rangeDuration,
                      );
                    }
                  : null,
              onExit: (_) => _clearPreview(),
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: widget.hasSeekRange
                    ? (event) {
                        if (event.kind == PointerDeviceKind.touch) return;
                        _updatePreview(
                          dx: event.localPosition.dx,
                          sliderWidth: sliderWidth,
                          rangeDuration: rangeDuration,
                        );
                      }
                    : null,
                onPointerMove: widget.hasSeekRange
                    ? (event) {
                        if (event.kind == PointerDeviceKind.touch) return;
                        _updatePreview(
                          dx: event.localPosition.dx,
                          sliderWidth: sliderWidth,
                          rangeDuration: rangeDuration,
                        );
                      }
                    : null,
                onPointerUp: widget.hasSeekRange
                    ? (event) {
                        if (event.kind == PointerDeviceKind.touch) {
                          _clearPreview();
                          return;
                        }
                        _updatePreview(
                          dx: event.localPosition.dx,
                          sliderWidth: sliderWidth,
                          rangeDuration: rangeDuration,
                        );
                      }
                    : null,
                onPointerCancel: widget.hasSeekRange ? (_) => _clearPreview() : null,
                child: SizedBox(
                  height: showSleepTimerPin ? _sleepTimerPinLayoutHeight : null,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Slider(
                        value: (_dragValue ?? widget.sliderValue).clamp(
                          0.0,
                          widget.hasSeekRange ? widget.maxSliderValue : 0.0,
                        ),
                        min: 0.0,
                        max: widget.hasSeekRange ? widget.maxSliderValue : 1.0,
                        activeColor: colorScheme.primary,
                        inactiveColor: colorScheme.onSurface.withValues(alpha: 0.3),
                        onChangeStart: widget.hasSeekRange ? _handleSliderChangeStart : null,
                        onChanged: widget.hasSeekRange ? _handleSliderChanged : null,
                        onChangeEnd: widget.hasSeekRange ? _handleSliderChangeEnd : null,
                      ),
                      if (sleepTimerRangeStart != null && sleepTimerRangeEnd != null)
                        Positioned(
                          left: sleepTimerRangeStart,
                          width: sleepTimerRangeEnd - sleepTimerRangeStart,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: widget.trackHeight + 2,
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiaryContainer.withValues(alpha: 0.6),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(999),
                                    bottomLeft: Radius.circular(999),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (sleepTimerEndOffset != null)
                        Positioned(
                          left: sliderWidth > 2 ? (sleepTimerEndOffset - 1).clamp(0.0, sliderWidth - 2).toDouble() : 0,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Center(
                              child: Container(
                                width: 2,
                                height: widget.trackHeight + 12,
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                      for (final marker in markerOffsets)
                        Positioned(
                          left: (marker.offset - (markerProfile.width / 2))
                              .clamp(0.0, sliderWidth > markerProfile.width ? sliderWidth - markerProfile.width : 0.0)
                              .toDouble(),
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Center(
                              child: Container(
                                width: markerProfile.width,
                                height: widget.trackHeight,
                                decoration: BoxDecoration(
                                  color:
                                      (marker.type == SeekTimelineMarkerType.bookmark &&
                                                  widget.markerMode == SeekBarMarkerMode.both
                                              ? colorScheme.error
                                              : colorScheme.tertiary)
                                          .withValues(alpha: markerProfile.alpha),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (sleepTimerStartOffset != null && widget.showSleepTimerPin)
                        Positioned(
                          left: sleepTimerStartOffset - (_sleepTimerPinHitboxSize / 2),
                          top: (_sleepTimerPinLayoutHeight - _sleepTimerPinHitboxSize) / 2,
                          width: _sleepTimerPinHitboxSize,
                          height: _sleepTimerPinHitboxSize,
                          child: Tooltip(
                            message: 'Return to sleep timer start',
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) => _setSleepTimerPinHovered(true),
                              onExit: (_) => _setSleepTimerPinHovered(false),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: widget.onSleepTimerMarkerTap == null
                                    ? null
                                    : () => unawaited(widget.onSleepTimerMarkerTap!()),
                                child: Center(
                                  child: Material(
                                    color: _isSleepTimerPinHovered
                                        ? colorScheme.surfaceContainerHigh
                                        : colorScheme.surfaceContainerHighest,
                                    shape: const CircleBorder(),
                                    child: SizedBox.square(
                                      dimension: _sleepTimerPinVisualSize,
                                      child: Icon(Icons.bedtime_rounded, size: 20, color: colorScheme.onSurface),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (previewLabel != null && _previewOffset != null)
                        Positioned(
                          left: previewLeft,
                          top: previewTop,
                          child: IgnorePointer(
                            child: Container(
                              width: previewWidth,
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.82),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                previewLabel,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: previewTextStyle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

_MarkerPaintProfile _resolveMarkerPaintProfile(int markerCount) {
  if (markerCount <= 24) {
    return const _MarkerPaintProfile(width: 2.4, alpha: 0.95);
  }
  if (markerCount <= 70) {
    return const _MarkerPaintProfile(width: 2.0, alpha: 0.9);
  }
  if (markerCount <= 140) {
    return const _MarkerPaintProfile(width: 1.6, alpha: 0.84);
  }
  return const _MarkerPaintProfile(width: 1.2, alpha: 0.78);
}

List<_SeekTimelineMarkerOffset> _resolveMarkerOffsets({
  required List<SeekTimelineMarker> markers,
  required Duration rangeStart,
  required Duration rangeEnd,
  required double sliderWidth,
}) {
  final rangeDuration = rangeEnd - rangeStart;
  final rangeSeconds = rangeDuration.inMilliseconds / 1000.0;
  if (rangeSeconds <= 0 || sliderWidth <= 0 || markers.isEmpty) {
    return const <_SeekTimelineMarkerOffset>[];
  }

  final rawOffsets = <_SeekTimelineMarkerOffset>[];
  for (final marker in markers) {
    if (marker.position <= rangeStart || marker.position >= rangeEnd) {
      continue;
    }

    final markerSeconds = (marker.position - rangeStart).inMilliseconds / 1000.0;
    final offset = (markerSeconds / rangeSeconds) * sliderWidth;
    rawOffsets.add(_SeekTimelineMarkerOffset(offset: offset.clamp(0.0, sliderWidth).toDouble(), type: marker.type));
  }

  if (rawOffsets.length <= 1) {
    return rawOffsets;
  }

  rawOffsets.sort((left, right) => left.offset.compareTo(right.offset));

  final markerCount = rawOffsets.length;
  final minVisualGap = markerCount <= 24
      ? 0.0
      : markerCount <= 60
      ? 2.0
      : markerCount <= 140
      ? 3.0
      : 4.0;

  if (minVisualGap == 0.0) {
    return rawOffsets;
  }

  final filtered = <_SeekTimelineMarkerOffset>[rawOffsets.first];
  for (var i = 1; i < rawOffsets.length; i++) {
    final candidate = rawOffsets[i];
    final hasVisualGap = candidate.offset - filtered.last.offset >= minVisualGap;
    final hasDifferentMarkerType = candidate.type != filtered.last.type;
    if (hasVisualGap || hasDifferentMarkerType) {
      filtered.add(rawOffsets[i]);
    }
  }

  return filtered;
}
