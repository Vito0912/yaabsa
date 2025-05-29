import 'package:buchshelfly/util/handler/bg_audio_handler.dart';
import 'package:buchshelfly/util/handler/download_handler.dart';
import 'package:buchshelfly/util/handler/shake_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String appName = 'Buchshelfly';

final ProviderContainer containerRef = ProviderContainer();
late final PackageInfo packageInfo;
late final BGAudioHandler audioHandler;
late final DownloadHandler downloadHandler;
late final ShakeRewindHandler? rewindShakeHandler;

const double kTabletBreakpoint = 800.0;
const double kDesktopBreakpoint = 1200.0;
