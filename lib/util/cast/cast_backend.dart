import 'package:yaabsa/models/playback_feature.dart';
import 'package:rxdart/rxdart.dart';

enum CastProtocol {
  chromecast('Chromecast'),
  upnp('DLNA / UPnP');

  const CastProtocol(this.label);

  final String label;
}

enum RemotePlayerState { playing, paused, buffering, loading, idle, unknown }

enum RemoteIdleReason { finished, cancelled, error }

class CastDevice {
  const CastDevice({required this.id, required this.name, required this.protocol});

  final String id;
  final String name;
  final CastProtocol protocol;
}

class CastMedia {
  const CastMedia({
    required this.contentId,
    required this.uri,
    required this.mimeType,
    required this.title,
    required this.duration,
    this.subtitle,
    this.cover,
    this.position = Duration.zero,
    this.autoPlay = true,
    this.headers = const {},
    this.trackOffset = Duration.zero,
    this.release,
    this.isTranscoded = false,
  });

  final String contentId;
  final Uri uri;
  final String mimeType;
  final String title;
  final String? subtitle;
  final Uri? cover;
  final Duration duration;
  final Duration position;
  final Duration trackOffset;
  final Future<void> Function()? release;
  final bool autoPlay;
  final bool isTranscoded;
  final Map<String, String> headers;
}

class RemoteMediaStatus {
  const RemoteMediaStatus({required this.playerState, this.contentId, this.idleReason, this.playbackRate = 1});

  final RemotePlayerState playerState;
  final String? contentId;
  final RemoteIdleReason? idleReason;
  final double playbackRate;
}

class CastPlaybackException implements Exception {
  const CastPlaybackException(this.message, {this.canTranscode = true});

  final String message;
  final bool canTranscode;

  @override
  String toString() => message;
}

abstract class CastBackend {
  CastBackend(this.protocol);

  final CastProtocol protocol;
  final features = BehaviorSubject<Set<PlaybackFeature>>.seeded(PlaybackFeature.values.toSet());
  final devices = BehaviorSubject<List<CastDevice>>.seeded(const []);
  final connected = BehaviorSubject<bool>.seeded(false);
  final status = BehaviorSubject<RemoteMediaStatus?>.seeded(null);
  final position = BehaviorSubject<Duration>.seeded(Duration.zero);

  Future<List<String>> supportedMimeTypes(CastDevice device) async {
    return const ['audio/mpeg', 'audio/mp4', 'audio/aac', 'audio/flac', 'audio/wav'];
  }

  Future<Duration> refreshPosition() async => position.value;

  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<void> connect(CastDevice device);
  Future<void> load(CastMedia media);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> setVolume(double volume);
  Future<void> setSpeed(double speed);
  Future<void> disconnect();

  Future<void> dispose() async {
    try {
      await stopDiscovery();
      await disconnect();
    } finally {
      await features.close();
      await devices.close();
      await connected.close();
      await status.close();
      await position.close();
    }
  }
}
