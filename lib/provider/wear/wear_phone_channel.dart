import 'package:flutter/services.dart';

/// Phone side: hands a freshly created token pair to the watch that is
/// waiting on a pending pairing request.
Future<bool> sendWearCredentialsToWatch({
  required String serverUrl,
  required String accessToken,
  String? refreshToken,
}) async {
  const channel = MethodChannel('de.vito0912.yaabsa/wear_data');
  try {
    final sent = await channel.invokeMethod<bool>('sendWearCredentials', {
      'serverUrl': serverUrl,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    });
    return sent ?? false;
  } on PlatformException catch (_) {
    return false;
  }
}
