import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter/widgets.dart' show AppLifecycleListener, WidgetsBinding;
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

class DesktopWindowState {
  DesktopWindowState._(this._settings);

  static bool get isSupported => !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  static DesktopWindowState? _instance;
  static Future<void>? _initialization;
  static Future<void>? _closeOperation;
  static bool _shutdownRequested = false;
  static const _operationTimeout = Duration(seconds: 2);
  static const _shutdownTimeout = Duration(seconds: 10);

  final SettingsManager _settings;

  Window? _window;
  ListenerId? _windowListenerId;
  AppLifecycleListener? _exitListener;
  Timer? _saveTimer;

  Rect? _normalBounds;
  bool _maximized = false;
  String? _lastPersistedValue;

  Future<void>? _pendingSave;
  bool _preventClose = false;
  bool _closing = false;
  bool _saveRequested = false;
  bool _persistRequested = false;
  bool _disposed = false;

  static double get _coordinateScale {
    if (!Platform.isWindows) {
      return 1;
    }

    final scale = WidgetsBinding.instance.platformDispatcher.implicitView?.devicePixelRatio ?? 1.0;
    if (!scale.isFinite || scale <= 0) {
      return 1.0;
    }

    return scale;
  }

  static Rect _scaleBounds(Rect bounds, double scale) =>
      Rect.fromLTWH(bounds.left * scale, bounds.top * scale, bounds.width * scale, bounds.height * scale);

  Window _requireWindow() {
    final existingWindow = _window;
    if (existingWindow != null) {
      return existingWindow;
    }

    final currentWindow = WindowManager.instance.getCurrent();
    if (currentWindow == null) {
      throw StateError('No active desktop window available');
    }

    _window = currentWindow;
    return currentWindow;
  }

  ({bool minimized, bool maximized, bool fullScreen}) _readWindowState() {
    final window = _requireWindow();
    return (minimized: window.isMinimized, maximized: window.isMaximized, fullScreen: window.isFullScreen);
  }

  void _attachWindowListener() {
    if (_windowListenerId != null) {
      return;
    }

    final window = _requireWindow();
    _windowListenerId = window.addListener(_onWindowEvent);
  }

  void _detachWindowListener() {
    final listenerId = _windowListenerId;
    if (listenerId == null) {
      return;
    }

    _window?.removeListener(listenerId);
    _windowListenerId = null;
  }

  AppLifecycleListener _createExitListener() {
    return AppLifecycleListener(
      onExitRequested: () async {
        try {
          await _flush().timeout(_shutdownTimeout);
        } catch (e, s) {
          logger('Failed to flush window placement before exit: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
        }

        return AppExitResponse.exit;
      },
    );
  }

  void _dispose() {
    _disposed = true;
    _preventClose = false;
    _saveRequested = false;
    _persistRequested = false;
    _saveTimer?.cancel();
    _detachWindowListener();
    _window?.dispose();
    _window = null;
    _exitListener?.dispose();
    _exitListener = null;
  }

  static Future<void> initialize(SettingsManager settings) async {
    if (!isSupported) {
      return;
    }

    await (_initialization ??= _initialize(settings));
  }

  static Future<void> _initialize(SettingsManager settings) async {
    final instance = DesktopWindowState._(settings);

    try {
      if (_shutdownRequested) {
        instance._dispose();
        return;
      }

      instance._requireWindow();
      instance._restore();
      instance._preventClose = true;
      instance._attachWindowListener();

      if (Platform.isMacOS) {
        instance._exitListener = instance._createExitListener();
      }
      _instance = instance;
    } catch (e, s) {
      instance._dispose();
      logger('Failed to initialize window persistence: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
    }
  }

  Rect? _parseSavedBounds(Map<String, dynamic> decoded) {
    final x = jsonDoubleFromDynamic(decoded['x']);
    final y = jsonDoubleFromDynamic(decoded['y']);
    final width = jsonDoubleFromDynamic(decoded['width']);
    final height = jsonDoubleFromDynamic(decoded['height']);
    if (x == null || y == null || width == null || height == null) {
      return null;
    }
    if (!x.isFinite || !y.isFinite || !width.isFinite || !height.isFinite || width <= 0 || height <= 0) {
      return null;
    }

    var bounds = Rect.fromLTWH(x, y, width, height);
    if (!bounds.isFinite || bounds.isEmpty) {
      throw const FormatException('Invalid window bounds');
    }

    final usesPhysicalPixels = jsonBoolRequiredFromDynamic(decoded['physicalPixels']);
    if (Platform.isWindows && !usesPhysicalPixels) {
      bounds = _scaleBounds(bounds, _coordinateScale);
    }

    return bounds;
  }

  void _restore() {
    final encoded = _settings.getGlobalSetting<String>(SettingKeys.desktopWindowState);
    _lastPersistedValue = encoded;

    if (encoded.isNotEmpty) {
      try {
        final decoded = jsonDecode(encoded);
        if (decoded is Map<String, dynamic>) {
          final parsedBounds = _parseSavedBounds(decoded);
          if (parsedBounds != null) {
            final window = _requireWindow();
            final fittedBounds = _fitToDisplay(parsedBounds);
            final currentState = _readWindowState();
            final savedMaximized = jsonBoolRequiredFromDynamic(decoded['maximized']);

            if (!currentState.fullScreen) {
              if (currentState.maximized) {
                window.unmaximize();
              }

              final targetBounds = _scaleBounds(fittedBounds, 1 / _coordinateScale);
              window.bounds = targetBounds.toNative();

              if (savedMaximized) {
                window.maximize();
              }
            }

            _normalBounds = fittedBounds;
            _maximized = savedMaximized;
          }
        }
      } catch (e, s) {
        logger('Failed to restore window placement: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
      }
    }

    if (_normalBounds == null) {
      final window = _requireWindow();
      final currentState = _readWindowState();
      _maximized = currentState.maximized;

      if (!currentState.minimized && !currentState.maximized && !currentState.fullScreen) {
        final scale = _coordinateScale;
        final bounds = window.bounds.toRect();
        if (bounds.isFinite && !bounds.isEmpty) {
          _normalBounds = _scaleBounds(bounds, scale);
        }
      }
    }
  }

  static Rect? _displayWorkArea(Display display) {
    final workAreaRect = display.workArea.toRect();
    final displaySize = display.size.toSize();
    final displayPosition = display.position.toOffset();
    var area = !workAreaRect.isEmpty
        ? workAreaRect
        : Rect.fromLTWH(displayPosition.dx, displayPosition.dy, displaySize.width, displaySize.height);

    if (Platform.isWindows) {
      final scale = display.scaleFactor;
      if (!scale.isFinite || scale <= 0) {
        return null;
      }

      area = _scaleBounds(area, scale);
    }

    if (!area.isFinite || area.isEmpty) {
      return null;
    }

    return area;
  }

  Rect _fitToDisplay(Rect bounds) {
    final displays = DisplayManager.instance.getAll();
    Rect? workArea;
    double largestOverlap = 0;

    try {
      for (final display in displays) {
        final area = _displayWorkArea(display);
        if (area == null) {
          continue;
        }

        final overlap = bounds.intersect(area);
        final overlapArea = overlap.isEmpty ? 0.0 : overlap.width * overlap.height;
        if (overlapArea > largestOverlap) {
          largestOverlap = overlapArea;
          workArea = area;
        }
      }
    } finally {
      for (final display in displays) {
        display.dispose();
      }
    }

    if (workArea == null) {
      final primary = DisplayManager.instance.getPrimary();
      if (primary != null) {
        try {
          workArea = _displayWorkArea(primary);
        } finally {
          primary.dispose();
        }
      }
    }

    if (workArea == null) {
      throw StateError('No usable display bounds');
    }

    final width = bounds.width.clamp(1.0, workArea.width);
    final height = bounds.height.clamp(1.0, workArea.height);
    final left = largestOverlap > 0
        ? bounds.left.clamp(workArea.left, workArea.right - width)
        : workArea.left + (workArea.width - width) / 2;
    final top = largestOverlap > 0
        ? bounds.top.clamp(workArea.top, workArea.bottom - height)
        : workArea.top + (workArea.height - height) / 2;

    return Rect.fromLTWH(left, top, width, height);
  }

  void _scheduleSave() {
    if (_closing || _disposed) {
      return;
    }

    unawaited(_enqueueSave(persist: false));
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () {
      unawaited(_enqueueSave());
    });
  }

  void _saveNow() {
    if (_closing || _disposed) {
      return;
    }

    _saveTimer?.cancel();
    unawaited(_enqueueSave());
  }

  Future<void> _enqueueSave({bool persist = true}) {
    if (_disposed) {
      return Future<void>.value();
    }

    _saveRequested = true;
    _persistRequested = _persistRequested || persist;
    return _pendingSave ??= _drainSaves();
  }

  Future<void> _drainSaves() async {
    try {
      while (_saveRequested && !_disposed) {
        _saveRequested = false;
        final persist = _persistRequested;
        _persistRequested = false;
        await _save(persist: persist);
      }
    } finally {
      _pendingSave = null;
    }
  }

  Future<void> _flush() {
    _saveTimer?.cancel();
    return _enqueueSave();
  }

  Future<void> _save({required bool persist}) async {
    try {
      if (_disposed) {
        return;
      }

      final window = _requireWindow();
      final currentState = _readWindowState();
      if (!currentState.minimized && !currentState.fullScreen) {
        _maximized = currentState.maximized;
      }

      if (!currentState.minimized && !currentState.maximized && !currentState.fullScreen) {
        final bounds = window.bounds.toRect();
        if (bounds.isFinite && !bounds.isEmpty) {
          _normalBounds = _scaleBounds(bounds, _coordinateScale);
        }
      }

      if (!persist) {
        return;
      }

      final bounds = _normalBounds;
      if (bounds == null || !bounds.isFinite || bounds.isEmpty) {
        return;
      }

      final encoded = jsonEncode({
        'x': bounds.left,
        'y': bounds.top,
        'width': bounds.width,
        'height': bounds.height,
        'maximized': _maximized,
        'physicalPixels': Platform.isWindows,
      });
      if (encoded == _lastPersistedValue) {
        return;
      }

      await _settings.setGlobalSetting<String>(SettingKeys.desktopWindowState, encoded).timeout(_operationTimeout);
      _lastPersistedValue = encoded;
    } catch (e, s) {
      logger('Failed to save window placement: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
    }
  }

  static Future<void> close() async {
    if (!isSupported) {
      return;
    }

    _shutdownRequested = true;
    await (_closeOperation ??= _close());
  }

  static Future<void> _close() async {
    final initialization = _initialization;
    if (initialization != null) {
      try {
        await initialization.timeout(_shutdownTimeout);
      } catch (e, s) {
        logger(
          'Window initialization did not finish before exit: $e\n$s',
          tag: 'WindowState',
          level: InfoLevel.warning,
        );
      }
    }

    final instance = _instance;
    if (instance != null) {
      instance._closing = true;
      try {
        await instance._flush().timeout(_shutdownTimeout);
      } catch (e, s) {
        logger('Failed to flush window placement before closing: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
      }
    }

    try {
      final window = instance?._window ?? WindowManager.instance.getCurrent();
      if (instance != null) {
        instance._preventClose = false;
      }

      final closedNatively = window != null && Window.isCloseSupported() && window.close();
      if (window != null && !identical(window, instance?._window)) {
        window.dispose();
      }

      if (!closedNatively) {
        await SystemNavigator.pop().timeout(_operationTimeout);
      }
    } catch (e, s) {
      logger('Failed to close the window normally: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);

      try {
        await SystemNavigator.pop().timeout(_operationTimeout);
      } catch (fallbackError, fallbackStack) {
        if (instance != null) {
          instance._closing = false;
        }
        _shutdownRequested = false;
        _closeOperation = null;
        logger(
          'Failed to close the window: $fallbackError\n$fallbackStack',
          tag: 'WindowState',
          level: InfoLevel.warning,
        );
        return;
      }
    }

    instance?._dispose();
    _instance = null;
  }

  void _onWindowEvent(WindowEvent event) {
    switch (event) {
      case WindowCloseRequestedEvent(:final request):
        if (_preventClose) {
          request.cancel();
        }
        unawaited(close());
      case WindowMovedEvent():
      case WindowResizedEvent():
        _scheduleSave();
      case WindowMaximizedEvent():
        _maximized = true;
        _saveNow();
      case WindowMinimizedEvent():
        _saveNow();
      case WindowRestoredEvent():
        _maximized = _window?.isMaximized ?? false;
        _scheduleSave();
      case WindowEnteredFullScreenEvent():
        _saveNow();
      case WindowExitedFullScreenEvent():
        _scheduleSave();
      case WindowFocusedEvent():
      case WindowBlurredEvent():
      case WindowCreatedEvent():
      case WindowClosedEvent():
      case WindowPropertyChangedEvent():
      case WindowOcclusionChangedEvent():
      case WindowDockedEvent():
      case WindowUndockedEvent():
        break;
    }
  }
}
