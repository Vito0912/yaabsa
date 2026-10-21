import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kDebugMode, kIsWeb;

bool get isLinuxDevelopmentBuild => kDebugMode && !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

String get developmentStoragePrefix => isLinuxDevelopmentBuild ? 'dev.' : '';
