import 'dart:async';

import 'package:upnp_client/upnp_client.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';

Duration? parseUpnpTime(String? value) {
  final parts = value?.split(':');
  if (parts == null || parts.length != 3) {
    return null;
  }

  final hours = int.tryParse(parts[0]);
  final minutes = int.tryParse(parts[1]);
  final seconds = double.tryParse(parts[2]);
  if (hours == null || minutes == null || seconds == null) {
    return null;
  }

  return Duration(hours: hours, minutes: minutes, milliseconds: (seconds * 1000).round());
}

Future<Duration> seekUpnp(AvTransportService transport, Duration target, {required bool Function() isCurrent}) async {
  final seconds = target.inSeconds.clamp(0, 0x7fffffff);
  final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
  final minutes = ((seconds ~/ 60) % 60).toString().padLeft(2, '0');
  final remainder = (seconds % 60).toString().padLeft(2, '0');

  for (var attempt = 0; attempt < 3; attempt++) {
    if (!isCurrent()) {
      throw StateError('Cast playback was cancelled');
    }

    await transport.seek(SeekMode.relTime, '$hours:$minutes:$remainder');
    var confirmations = 0;
    for (var check = 0; check < 4; check++) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!isCurrent()) {
        throw StateError('Cast playback was cancelled');
      }

      final progress = await transport.getPositionInfo().timeout(const Duration(seconds: 5));
      if (!isCurrent()) {
        throw StateError('Cast playback was cancelled');
      }

      final actual = parseUpnpTime(progress.relTime);
      if (actual != null && (actual - target).abs() <= const Duration(seconds: 3)) {
        confirmations++;
        if (confirmations >= 2) {
          return actual;
        }
      } else {
        confirmations = 0;
      }
    }
  }

  throw const CastPlaybackException('The receiver could not seek to the requested position', canTranscode: false);
}
