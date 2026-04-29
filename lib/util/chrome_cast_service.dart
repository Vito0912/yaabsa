import 'dart:io';

import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:yaabsa/util/logger.dart';

class ChromeCastService {
  ChromeCastService._();

  static const String defaultApplicationId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;

  static bool _initialized = false;
  static Future<bool>? _initializationFuture;

  static bool get isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  static bool get isInitialized => _initialized;

  static Future<bool> ensureInitialized({String applicationId = defaultApplicationId}) {
    if (!isSupportedPlatform) {
      return Future.value(false);
    }

    if (_initialized) {
      return Future.value(true);
    }

    final inFlight = _initializationFuture;
    if (inFlight != null) {
      return inFlight;
    }

    _initializationFuture = _initialize(applicationId);
    return _initializationFuture!;
  }

  static Future<bool> _initialize(String applicationId) async {
    try {
      final GoogleCastOptions options;
      if (Platform.isAndroid) {
        options = GoogleCastOptionsAndroid(appId: applicationId, stopCastingOnAppTerminated: true);
      } else {
        options = IOSGoogleCastOptions(
          GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(applicationId),
          stopCastingOnAppTerminated: true,
        );
      }

      final initialized = await GoogleCastContext.instance.setSharedInstanceWithOptions(options);
      _initialized = initialized;

      logger('Chrome Cast initialized: $initialized', tag: 'ChromeCastService', level: InfoLevel.info);
      return initialized;
    } catch (e) {
      logger('Chrome Cast initialization failed: $e', tag: 'ChromeCastService', level: InfoLevel.warning);
      return false;
    } finally {
      _initializationFuture = null;
    }
  }
}
