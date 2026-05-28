import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/router.dart';

class AaosTelemetryState {
  const AaosTelemetryState({required this.isAndroid, required this.isAutomotiveDevice, this.statusMessage});

  const AaosTelemetryState.initial()
    : isAndroid = false,
      isAutomotiveDevice = false,
      statusMessage = 'AAOS integration is inactive.';

  final bool isAndroid;
  final bool isAutomotiveDevice;
  final String? statusMessage;

  AaosTelemetryState copyWith({
    bool? isAndroid,
    bool? isAutomotiveDevice,
    String? statusMessage,
    bool clearStatusMessage = false,
  }) {
    return AaosTelemetryState(
      isAndroid: isAndroid ?? this.isAndroid,
      isAutomotiveDevice: isAutomotiveDevice ?? this.isAutomotiveDevice,
      statusMessage: clearStatusMessage ? null : (statusMessage ?? this.statusMessage),
    );
  }
}

class AaosService {
  AaosService._();

  static final AaosService instance = AaosService._();

  static const String _automotiveFeatureFlag = 'android.hardware.type.automotive';
  static const MethodChannel _channel = MethodChannel('de.vito0912.yaabsa/aaos');

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  final StreamController<AaosTelemetryState> _stateController = StreamController<AaosTelemetryState>.broadcast();

  AaosTelemetryState _state = const AaosTelemetryState.initial();
  bool _initialized = false;

  Stream<AaosTelemetryState> get stream => _stateController.stream;
  AaosTelemetryState get currentState => _state;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;

    if (!Platform.isAndroid) {
      _emit(_state.copyWith(statusMessage: 'AAOS integration is only available on Android.'));
      return;
    }

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openSettings') {
        final currentUri = globalRouter.routeInformationProvider.value.uri;
        if (currentUri.path.startsWith('/add-user')) {
          return;
        }

        final isAlreadyInSettings = currentUri.path == '/' && currentUri.queryParameters['tab'] == 'settings';
        if (isAlreadyInSettings) {
          return;
        }

        final intent = DateTime.now().microsecondsSinceEpoch;
        globalRouter.go('/?tab=settings&intent=aaos-$intent');
      }
    });

    final isAutomotiveDevice = await _detectAutomotiveDevice();
    _emit(
      _state.copyWith(
        isAndroid: true,
        isAutomotiveDevice: isAutomotiveDevice,
        statusMessage: isAutomotiveDevice
            ? 'Android Automotive OS detected.'
            : 'Android Automotive OS not detected on this device.',
      ),
    );
  }

  Future<bool> _detectAutomotiveDevice() async {
    try {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.systemFeatures.contains(_automotiveFeatureFlag);
    } catch (error) {
      logger('Failed to detect AAOS feature flag: $error', tag: 'AAOS', level: InfoLevel.warning);
      return false;
    }
  }

  Future<bool> launchMediaCenter({bool finishActivity = false}) async {
    try {
      if (!Platform.isAndroid || !currentState.isAutomotiveDevice) {
        return false;
      }
      final result = await _channel.invokeMethod<bool>('launchMediaCenter', {'finishActivity': finishActivity});
      return result ?? false;
    } catch (e) {
      logger('Failed to launch AAOS Media Center: $e', tag: 'AAOS', level: InfoLevel.error);
      return false;
    }
  }

  void _emit(AaosTelemetryState nextState) {
    _state = nextState;
    if (!_stateController.isClosed) {
      _stateController.add(nextState);
    }
  }
}
