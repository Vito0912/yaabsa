import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:just_audio/just_audio.dart';

enum PlaybackFailureAction { transcode, retryStream, ignore, fail }

PlaybackFailureAction classifyPlaybackError(PlayerException error) {
  final message = '${error.message ?? ''} ${error.toString()}'.toLowerCase();

  if (RegExp(r'\bhttps?\s*(?:error|status)?\s*[:=]?\s*([45]\d{2})\b').hasMatch(message) ||
      RegExp(r'\b(?:401|403|404|500|501|502|503|504)\b').hasMatch(message) ||
      message.contains('server unavailable') ||
      message.contains('service unavailable') ||
      message.contains('bad gateway')) {
    return PlaybackFailureAction.fail;
  }

  if (message.contains('ffurl_read') ||
      message.contains('connection reset') ||
      message.contains('connection closed') ||
      message.contains('timed out') ||
      message.contains('timeout')) {
    return PlaybackFailureAction.retryStream;
  }

  if (kIsWeb && (error.code == 3 || error.code == 4)) {
    return PlaybackFailureAction.transcode;
  }

  // Please don't judge this :)
  // There probably is a better way to do this
  if (message.contains('decoder initialization') ||
      message.contains('decoder initialisation') ||
      message.contains('failed to initialize decoder') ||
      message.contains('failed to initialize a decoder') ||
      message.contains('failed to initialise decoder') ||
      message.contains('decoder failed') ||
      message.contains('unsupported codec') ||
      message.contains('codec not supported') ||
      message.contains('unsupported format') ||
      message.contains('format not supported') ||
      message.contains('unsupported audio') ||
      message.contains('no decoder') ||
      message.contains('open codec') ||
      message.contains('decoding audio') ||
      message.contains('cannot create codec') ||
      message.contains('unable to instantiate decoder') ||
      message.contains('mediacodec') ||
      message.contains('failed to open codec') ||
      message.contains('could not open codec') ||
      message.contains("couldn't open codec") ||
      message.contains('could not initialize codec') ||
      message.contains('could not initialise codec') ||
      message.contains('could not open decoder') ||
      message.contains('xhe-aac') ||
      message.contains('x-he aac')) {
    return PlaybackFailureAction.transcode;
  }

  return PlaybackFailureAction.fail;
}
