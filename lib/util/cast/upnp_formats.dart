import 'package:upnp_client/upnp_client.dart';
import 'package:yaabsa/util/logger.dart';

Future<List<String>> readUpnpMimeTypes(MediaRenderer? renderer) async {
  try {
    final formats = await renderer?.connectionManager?.getProtocolInfo();
    final supported = formats?.sink
        .where((format) {
          final mimeType = format.contentFormat.toLowerCase();
          return format.protocol == 'http-get' && (mimeType.startsWith('audio/') || mimeType.contains('mpegurl'));
        })
        .map((format) => format.contentFormat)
        .toSet()
        .toList();
    if (supported != null && supported.isNotEmpty) {
      return supported;
    }
  } catch (error) {
    logger('Unable to read receiver formats: $error', tag: 'Casting', level: InfoLevel.warning);
  }

  return const ['audio/mpeg'];
}
