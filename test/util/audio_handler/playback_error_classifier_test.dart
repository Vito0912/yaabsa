import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/util/audio_handler/playback_error_classifier.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test('transcodes Android direct-play runtime errors', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(
      classifyPlaybackError(PlayerException(2, 'Unexpected runtime error', 16), isDirectPlay: true),
      PlaybackFailureAction.transcode,
    );
  });

  test('fails Android runtime errors outside direct play', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(classifyPlaybackError(PlayerException(2, 'Unexpected runtime error', 16)), PlaybackFailureAction.fail);
  });

  test('fails direct-play runtime errors on other native platforms', () {
    for (final platform in TargetPlatform.values.where((platform) => platform != TargetPlatform.android)) {
      debugDefaultTargetPlatformOverride = platform;

      expect(
        classifyPlaybackError(PlayerException(2, 'Unexpected runtime error', 16), isDirectPlay: true),
        PlaybackFailureAction.fail,
      );
    }
  });

  test('preserves HTTP and network error handling during Android direct play', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(classifyPlaybackError(PlayerException(2, 'HTTP 403', 0), isDirectPlay: true), PlaybackFailureAction.fail);
    expect(
      classifyPlaybackError(PlayerException(2, 'Connection reset by peer', 0), isDirectPlay: true),
      PlaybackFailureAction.retryStream,
    );
  });

  test('classifies decoder initialization failures for transcoding', () {
    expect(
      classifyPlaybackError(PlayerException(1, 'Decoder initialization failed', 0)),
      PlaybackFailureAction.transcode,
    );
  });

  test('classifies codec and MediaCodec failures for transcoding', () {
    expect(
      classifyPlaybackError(PlayerException(1, 'MediaCodecAudioRenderer: decoder failed', 0)),
      PlaybackFailureAction.transcode,
    );
    expect(classifyPlaybackError(PlayerException(1, 'Unsupported codec: opus', 0)), PlaybackFailureAction.transcode);
    expect(classifyPlaybackError(PlayerException(1, 'could not open codec: aac', 0)), PlaybackFailureAction.transcode);
    expect(classifyPlaybackError(PlayerException(1, 'Unsupported codec: xHE-AAC', 0)), PlaybackFailureAction.transcode);
  });

  test('preserves stream retry behavior for interrupted reads', () {
    expect(classifyPlaybackError(PlayerException(0, 'ffurl_read failed', 0)), PlaybackFailureAction.retryStream);
    expect(classifyPlaybackError(PlayerException(0, 'Connection reset by peer', 0)), PlaybackFailureAction.retryStream);
  });

  test('does not transcode HTTP failures or unknown errors', () {
    expect(classifyPlaybackError(PlayerException(0, 'HTTP 403', 0)), PlaybackFailureAction.fail);
    expect(classifyPlaybackError(PlayerException(0, 'HTTP 404', 0)), PlaybackFailureAction.fail);
    expect(classifyPlaybackError(PlayerException(0, 'Unexpected end of input', 0)), PlaybackFailureAction.fail);
  });
}
