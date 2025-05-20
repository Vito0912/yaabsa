import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/util/bg_audio_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

const String appName = 'Buchshelfly';

final ProviderContainer containerRef = ProviderContainer();
late final PackageInfo packageInfo;
List<InternalMedia> internalMedia = [];
late final BGAudioHandler audioHandler;
