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

class DesktopWindowState with WindowListener {
  DesktopWindowState._(this._settings);

  static bool get isSupported => !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  static DesktopWindowState? _instance;
  static Future<void>? _initialization;
  static Future<void>? _closeOperation;
  static bool _shutdownRequested = false;
  static const _operationTimeout = Duration(seconds: 2);
  static const _shutdownTimeout = Duration(seconds: 10);

  final SettingsManager _settings;
  Rect? _normalBounds;
  bool _maximized = false;
  bool _closing = false;
  Timer? _saveTimer;
  AppLifecycleListener? _exitListener;
  Future<void>? _pendingSave;
  bool _saveRequested = false;
  bool _persistRequested = false;
  bool _disposed = false;
  int _changeRevision = 0;
  String? _lastPersistedValue;

  static double get _coordinateScale {
    if (!Platform.isWindows) return 1;
    final scale = WidgetsBinding.instance.platformDispatcher.implicitView?.devicePixelRatio ?? 1.0;
    return scale.isFinite && scale > 0 ? scale : 1.0;
  }

  static Rect _scaleBounds(Rect bounds, double scale) =>
      Rect.fromLTWH(bounds.left * scale, bounds.top * scale, bounds.width * scale, bounds.height * scale);

  Future<({bool minimized, bool maximized, bool fullScreen})> _readWindowState() async {
    final flags = await Future.wait<bool>([
      windowManager.isMinimized(),
      windowManager.isMaximized(),
      windowManager.isFullScreen(),
    ]).timeout(_operationTimeout);
    return (minimized: flags[0], maximized: flags[1], fullScreen: flags[2]);
  }

  AppLifecycleListener _createExitListener() => AppLifecycleListener(
    onExitRequested: () async {
      try {
        await _flush().timeout(_shutdownTimeout);
      } catch (e, s) {
        logger('Failed to flush window placement before exit: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
      }
      return AppExitResponse.exit;
    },
  );

  void _dispose() {
    _disposed = true;
    _saveRequested = false;
    _persistRequested = false;
    _saveTimer?.cancel();
    windowManager.removeListener(this);
    _exitListener?.dispose();
    _exitListener = null;
  }

  static Future<void> initialize(SettingsManager settings) async {
    if (!isSupported) return;
    await (_initialization ??= _initialize(settings));
  }

  static Future<void> _initialize(SettingsManager settings) async {
    final instance = DesktopWindowState._(settings);
    var closeInterceptionRequested = false;
    try {
      if (_shutdownRequested) return;
      await windowManager.ensureInitialized().timeout(_operationTimeout);
      await instance._restore();
      if (_shutdownRequested) return;
      windowManager.addListener(instance);
      closeInterceptionRequested = true;
      await windowManager.setPreventClose(true).timeout(_operationTimeout);
      if (_shutdownRequested) {
        instance._dispose();
        await windowManager.setPreventClose(false).timeout(_operationTimeout);
        return;
      }
      if (Platform.isMacOS) instance._exitListener = instance._createExitListener();
      _instance = instance;
    } catch (e, s) {
      instance._dispose();
      if (closeInterceptionRequested) {
        try {
          await windowManager.setPreventClose(false).timeout(_operationTimeout);
        } catch (cleanupError) {
          logger(
            'Failed to release window close interception: $cleanupError',
            tag: 'WindowState',
            level: InfoLevel.warning,
          );
        }
      }
      logger('Failed to initialize window persistence: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
    }
  }

  Future<void> _restore() async {
    final encoded = _settings.getGlobalSetting<String>(SettingKeys.desktopWindowState);
    _lastPersistedValue = encoded;
    if (encoded.isNotEmpty) {
      try {
        final decoded = jsonDecode(encoded);
        if (decoded is Map<String, dynamic>) {
          final x = jsonDoubleFromDynamic(decoded['x']);
          final y = jsonDoubleFromDynamic(decoded['y']);
          final width = jsonDoubleFromDynamic(decoded['width']);
          final height = jsonDoubleFromDynamic(decoded['height']);
          if (x != null &&
              y != null &&
              width != null &&
              height != null &&
              x.isFinite &&
              y.isFinite &&
              width.isFinite &&
              height.isFinite &&
              width > 0 &&
              height > 0) {
            var bounds = Rect.fromLTWH(x, y, width, height);
            if (!bounds.isFinite || bounds.isEmpty) throw const FormatException('Invalid window bounds');
            if (Platform.isWindows && !jsonBoolRequiredFromDynamic(decoded['physicalPixels'])) {
              bounds = _scaleBounds(bounds, _coordinateScale);
            }
            final fittedBounds = await _fitToDisplay(bounds);
            final currentState = await _readWindowState();
            final savedMaximized = jsonBoolRequiredFromDynamic(decoded['maximized']);
            if (!currentState.fullScreen) {
              if (currentState.maximized) await windowManager.unmaximize().timeout(_operationTimeout);
              await windowManager
                  .setBounds(_scaleBounds(fittedBounds, 1 / _coordinateScale))
                  .timeout(_operationTimeout);
              if (savedMaximized) await windowManager.maximize().timeout(_operationTimeout);
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
      final currentState = await _readWindowState();
      _maximized = currentState.maximized;
      if (!currentState.minimized && !currentState.maximized && !currentState.fullScreen) {
        final scale = _coordinateScale;
        final bounds = await windowManager.getBounds().timeout(_operationTimeout);
        if (bounds.isFinite && !bounds.isEmpty) _normalBounds = _scaleBounds(bounds, scale);
      }
    }
  }

  static Rect? _displayWorkArea(Display display) {
    var area = Rect.fromLTWH(
      display.visiblePosition?.dx ?? 0,
      display.visiblePosition?.dy ?? 0,
      (display.visibleSize ?? display.size).width,
      (display.visibleSize ?? display.size).height,
    );
    if (Platform.isWindows) {
      final scale = display.scaleFactor?.toDouble() ?? 1.0;
      if (!scale.isFinite || scale <= 0) return null;
      area = _scaleBounds(area, scale);
    }
    return area.isFinite && !area.isEmpty ? area : null;
  }

  Future<Rect> _fitToDisplay(Rect bounds) async {
    final displays = await screenRetriever.getAllDisplays().timeout(_operationTimeout);
    Rect? workArea;
    double largestOverlap = 0;
    for (final display in displays) {
      final area = _displayWorkArea(display);
      if (area == null) continue;
      final overlap = bounds.intersect(area);
      final overlapArea = overlap.isEmpty ? 0.0 : overlap.width * overlap.height;
      if (overlapArea > largestOverlap) {
        largestOverlap = overlapArea;
        workArea = area;
      }
    }
    if (workArea == null) {
      final primary = await screenRetriever.getPrimaryDisplay().timeout(_operationTimeout);
      workArea = _displayWorkArea(primary);
    }
    if (workArea == null) throw StateError('No usable display bounds');
    final width = bounds.width.clamp(1.0, workArea.width);
    final height = bounds.height.clamp(1.0, workArea.height);
    return Rect.fromLTWH(
      largestOverlap > 0
          ? bounds.left.clamp(workArea.left, workArea.right - width)
          : workArea.left + (workArea.width - width) / 2,
      largestOverlap > 0
          ? bounds.top.clamp(workArea.top, workArea.bottom - height)
          : workArea.top + (workArea.height - height) / 2,
      width,
      height,
    );
  }

  void _scheduleSave() {
    _changeRevision++;
    if (_closing || _disposed) return;
    unawaited(_enqueueSave(persist: false));
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), () => unawaited(_enqueueSave()));
  }

  Future<void> _enqueueSave({bool persist = true}) {
    if (_disposed) return Future<void>.value();
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
      final revision = _changeRevision;
      var currentState = await _readWindowState();
      Rect? normalBounds;
      if (!currentState.minimized && !currentState.maximized && !currentState.fullScreen) {
        final scale = _coordinateScale;
        final bounds = await windowManager.getBounds().timeout(_operationTimeout);
        currentState = await _readWindowState();
        if (!currentState.minimized &&
            !currentState.maximized &&
            !currentState.fullScreen &&
            bounds.isFinite &&
            !bounds.isEmpty) {
          normalBounds = _scaleBounds(bounds, scale);
        }
      }
      if (_disposed) return;
      if (revision != _changeRevision) {
        _saveRequested = true;
        _persistRequested = _persistRequested || persist;
        return;
      }
      if (!currentState.minimized && !currentState.fullScreen) _maximized = currentState.maximized;
      if (normalBounds != null) _normalBounds = normalBounds;
      if (!persist) return;
      final bounds = _normalBounds;
      if (bounds == null || !bounds.isFinite || bounds.isEmpty) return;
      final encoded = jsonEncode({
        'x': bounds.left,
        'y': bounds.top,
        'width': bounds.width,
        'height': bounds.height,
        'maximized': _maximized,
        'physicalPixels': Platform.isWindows,
      });
      if (encoded == _lastPersistedValue) return;
      await _settings.setGlobalSetting<String>(SettingKeys.desktopWindowState, encoded).timeout(_operationTimeout);
      _lastPersistedValue = encoded;
    } catch (e, s) {
      logger('Failed to save window placement: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
    }
  }

  static Future<void> close() async {
    if (!isSupported) return;
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
      if (instance == null) {
        await SystemNavigator.pop().timeout(_operationTimeout);
      } else {
        await windowManager.setPreventClose(false).timeout(_operationTimeout);
        await windowManager.close().timeout(_operationTimeout);
      }
    } catch (e, s) {
      logger('Failed to close the window normally: $e\n$s', tag: 'WindowState', level: InfoLevel.warning);
      try {
        await windowManager.destroy().timeout(_operationTimeout);
      } catch (fallbackError, fallbackStack) {
        if (instance != null) instance._closing = false;
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

  @override
  void onWindowClose() => unawaited(close());

  @override
  void onWindowMove() => _scheduleSave();

  @override
  void onWindowResize() => _scheduleSave();

  @override
  void onWindowMoved() {
    if (Platform.isMacOS) {
      _scheduleSave();
    } else {
      _saveNow();
    }
  }

  @override
  void onWindowResized() => _saveNow();

  @override
  void onWindowMaximize() {
    _maximized = true;
    _saveNow();
  }

  @override
  void onWindowUnmaximize() {
    _maximized = false;
    _scheduleSave();
  }

  @override
  void onWindowMinimize() => _saveNow();

  @override
  void onWindowRestore() => _scheduleSave();

  @override
  void onWindowEnterFullScreen() => _saveNow();

  @override
  void onWindowLeaveFullScreen() => _scheduleSave();

  void _saveNow() {
    _changeRevision++;
    if (_closing || _disposed) return;
    _saveTimer?.cancel();
    unawaited(_enqueueSave());
  }
}
