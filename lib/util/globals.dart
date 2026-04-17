import 'package:flutter/widgets.dart' show BuildContext, MediaQuery;
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

enum Breakpoint {
  mobile(0, kTabletBreakpoint),
  tablet(kTabletBreakpoint, kDesktopBreakpoint),
  desktop(kDesktopBreakpoint, double.infinity);

  final double minWidth;
  final double maxWidth;

  const Breakpoint(this.minWidth, this.maxWidth);

  bool contains(double width) => width >= minWidth && width < maxWidth;

  static Breakpoint fromWidth(double width) {
    return Breakpoint.values.firstWhere((bp) => bp.contains(width));
  }
}

extension BreakpointContextX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  Breakpoint get breakpoint => Breakpoint.fromWidth(screenWidth);

  bool get isMobile => breakpoint == Breakpoint.mobile;
  bool get isTablet => breakpoint == Breakpoint.tablet;
  bool get isDesktop => breakpoint == Breakpoint.desktop;
}
