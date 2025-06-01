import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sembast/sembast.dart' show Database;
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/handler/download_handler.dart';
import 'package:yaabsa/util/handler/shake_handler.dart';

const String appName = 'Yaabsa';

final ProviderContainer containerRef = ProviderContainer();
late final PackageInfo packageInfo;
late final BGAudioHandler audioHandler;
late final DownloadHandler downloadHandler;
late final ShakeRewindHandler? rewindShakeHandler;
late Database cacheDb;

const double kTabletBreakpoint = 800.0;
const double kDesktopBreakpoint = 1200.0;
