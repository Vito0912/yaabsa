import 'dart:async';
import 'dart:io';

import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';

class ChromecastBackend extends CastBackend {
  ChromecastBackend() : super(CastProtocol.chromecast);

  final List<StreamSubscription<dynamic>> _subscriptions = [];
  final Map<String, GoogleCastDevice> _targets = {};
  bool _initialized = false;
  int _loadRevision = 0;
  String? _receiverContentId;
  CastMedia? _media;
  Completer<void>? _pendingLoad;
  DateTime? _positionGuardStartedAt;

  Future<void> _initialize() async {
    if (_initialized) {
      return;
    }

    if (!await ChromeCastService.ensureInitialized()) {
      throw StateError('Chromecast is unavailable on this device');
    }

    _initialized = true;
    _subscriptions.addAll([
      GoogleCastDiscoveryManager.instance.devicesStream.listen(_updateDevices),
      GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
        final isConnected = session?.connectionState == GoogleCastConnectState.connected;
        if (!isConnected) {
          _failPendingLoad('Cast connection was lost', canTranscode: false);
        }

        connected.add(isConnected);
      }),
      GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((value) {
        if (value == null) {
          if (_pendingLoad != null) {
            return;
          }

          status.add(null);
          return;
        }

        final pending = _pendingLoad;
        if (value.mediaInformation?.contentId != _receiverContentId) {
          if (pending != null) {
            if (value.mediaInformation == null &&
                value.playerState == CastMediaPlayerState.idle &&
                value.idleReason == GoogleCastMediaIdleReason.error) {
              _failPendingLoad('The receiver could not load this audio');
            }

            return;
          }
        } else if (pending != null && !pending.isCompleted) {
          if (value.playerState == CastMediaPlayerState.idle && value.idleReason == GoogleCastMediaIdleReason.error) {
            _failPendingLoad('The receiver could not load this audio');
          } else if (value.playerState == CastMediaPlayerState.playing ||
              value.playerState == CastMediaPlayerState.paused) {
            pending.complete();
          }
        }

        final state = switch (value.playerState) {
          CastMediaPlayerState.playing => RemotePlayerState.playing,
          CastMediaPlayerState.paused => RemotePlayerState.paused,
          CastMediaPlayerState.buffering => RemotePlayerState.buffering,
          CastMediaPlayerState.loading => RemotePlayerState.loading,
          CastMediaPlayerState.idle => RemotePlayerState.idle,
          CastMediaPlayerState.unknown => RemotePlayerState.unknown,
        };
        final reason = switch (value.idleReason) {
          GoogleCastMediaIdleReason.finished => RemoteIdleReason.finished,
          GoogleCastMediaIdleReason.cancelled => RemoteIdleReason.cancelled,
          GoogleCastMediaIdleReason.error => RemoteIdleReason.error,
          _ => null,
        };

        status.add(
          RemoteMediaStatus(
            playerState: state,
            contentId: value.mediaInformation?.contentId == _receiverContentId
                ? _media?.contentId
                : value.mediaInformation?.contentId,
            idleReason: reason,
            playbackRate: value.playbackRate.toDouble(),
          ),
        );
      }),
      GoogleCastRemoteMediaClient.instance.playerPositionStream.listen(_updatePosition),
    ]);
    _updateDevices(GoogleCastDiscoveryManager.instance.devices);
  }

  void _failPendingLoad(String message, {bool canTranscode = true}) {
    final pending = _pendingLoad;
    if (pending != null && !pending.isCompleted) {
      pending.completeError(CastPlaybackException(message, canTranscode: canTranscode));
    }
  }

  void _updatePosition(Duration value) {
    final media = _media;
    final remote = GoogleCastRemoteMediaClient.instance.mediaStatus;
    if (media == null ||
        _pendingLoad != null ||
        remote?.mediaInformation?.contentId != _receiverContentId ||
        remote?.playerState == CastMediaPlayerState.idle) {
      return;
    }

    final guardStartedAt = _positionGuardStartedAt;
    if (guardStartedAt != null) {
      final elapsed = DateTime.now().difference(guardStartedAt);
      const tolerance = Duration(seconds: 3);
      if (value < media.position - tolerance || value > media.position + elapsed + tolerance) {
        return;
      }

      _positionGuardStartedAt = null;
    }

    position.add(value);
  }

  void _updateDevices(List<GoogleCastDevice> values) {
    _targets.clear();
    for (final device in values) {
      _targets[device.deviceID] = device;
    }

    devices.add([
      for (final entry in _targets.entries)
        CastDevice(id: entry.key, name: entry.value.friendlyName, protocol: protocol),
    ]);
  }

  @override
  Future<void> startDiscovery() async {
    await _initialize();
    await GoogleCastDiscoveryManager.instance.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    if (_initialized) {
      await GoogleCastDiscoveryManager.instance.stopDiscovery();
    }
  }

  @override
  Future<void> connect(CastDevice device) async {
    await _initialize();
    final target = _targets[device.id];
    if (target == null) {
      throw StateError('This Chromecast is no longer available');
    }

    await GoogleCastSessionManager.instance.startSessionWithDevice(target);
    if (!GoogleCastSessionManager.instance.hasConnectedSession) {
      await GoogleCastSessionManager.instance.currentSessionStream
          .firstWhere((session) => session?.connectionState == GoogleCastConnectState.connected)
          .timeout(const Duration(seconds: 10));
    }

    connected.add(true);
  }

  @override
  Future<void> load(CastMedia media) async {
    final receiverContentId = '${media.contentId}:cast:${++_loadRevision}';
    final metadata = GoogleCastGenericMediaMetadata(
      title: media.title,
      subtitle: media.subtitle,
      images: media.cover == null ? null : [GoogleCastImage(url: media.cover!)],
    );
    final GoogleCastMediaInformation info;
    if (Platform.isAndroid) {
      info = GoogleCastMediaInformationAndroid(
        contentId: receiverContentId,
        streamType: CastMediaStreamType.buffered,
        contentType: media.mimeType,
        contentUrl: media.uri,
        metadata: metadata,
      );
    } else {
      info = GoogleCastMediaInformationIOS(
        contentId: receiverContentId,
        streamType: CastMediaStreamType.buffered,
        contentType: media.mimeType,
        contentUrl: media.uri,
        metadata: metadata,
      );
    }

    final pending = Completer<void>();
    _pendingLoad = pending;
    _media = media;
    _receiverContentId = receiverContentId;
    _positionGuardStartedAt = DateTime.now();
    position.add(media.position);
    status.add(RemoteMediaStatus(playerState: RemotePlayerState.loading, contentId: media.contentId));

    try {
      await Future.wait<void>([
        pending.future.timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw const CastPlaybackException('The receiver did not confirm loading this audio');
          },
        ),
        GoogleCastRemoteMediaClient.instance.loadMedia(
          info,
          autoPlay: media.autoPlay,
          playPosition: media.position,
          customData: media.headers.isEmpty ? null : <String, dynamic>{'headers': media.headers},
        ),
      ], eagerError: true);
    } finally {
      if (identical(_pendingLoad, pending)) {
        _pendingLoad = null;
      }
    }
  }

  @override
  Future<void> play() => GoogleCastRemoteMediaClient.instance.play();

  @override
  Future<void> pause() => GoogleCastRemoteMediaClient.instance.pause();

  @override
  Future<void> stop() async {
    _failPendingLoad('Cast playback was cancelled', canTranscode: false);
    await GoogleCastRemoteMediaClient.instance.stop();
  }

  @override
  Future<void> seek(Duration position) {
    _positionGuardStartedAt = null;
    return GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: position));
  }

  @override
  Future<void> setVolume(double volume) async {
    GoogleCastSessionManager.instance.setDeviceVolume(volume);
  }

  @override
  Future<void> setSpeed(double speed) => GoogleCastRemoteMediaClient.instance.setPlaybackRate(speed);

  @override
  Future<void> disconnect() async {
    _failPendingLoad('Cast playback was cancelled', canTranscode: false);
    _media = null;
    _receiverContentId = null;
    _positionGuardStartedAt = null;

    if (_initialized) {
      await GoogleCastSessionManager.instance.endSessionAndStopCasting();
    }

    connected.add(false);
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }

    await super.dispose();
  }
}
