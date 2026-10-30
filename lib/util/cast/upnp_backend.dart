import 'dart:async';
import 'dart:io';

import 'package:upnp_client/didl.dart';
import 'package:upnp_client/upnp_client.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/cast/upnp_seek.dart';
import 'package:yaabsa/util/cast/upnp_formats.dart';
import 'package:yaabsa/util/logger.dart';

class UpnpBackend extends CastBackend {
  UpnpBackend() : super(CastProtocol.upnp) {
    features.add({});
  }

  DeviceDiscoverer? _discoverer;
  StreamSubscription<Device>? _deviceSubscription;
  StreamSubscription<Never>? _errorSubscription;
  final Map<String, MediaRenderer> _targets = {};
  MediaRenderer? _renderer;
  CastMedia? _media;
  Timer? _pollTimer;
  bool _polling = false;
  int _generation = 0;
  int _pollFailures = 0;
  Duration? _lastReceiverPosition;
  DateTime? _lastPositionAdvance;
  DateTime? _playRequestedAt;
  Completer<void>? _startup;
  bool _seeking = false;
  bool _starting = false;
  bool _primed = false;
  bool _requestedPlaying = false;
  int _commandRevision = 0;
  Duration? _pendingStartPosition;
  Future<void>? _startOperation;

  static const _startupTimeout = Duration(seconds: 20);
  static const _stallThreshold = Duration(seconds: 3);

  AvTransportService get _transport {
    final transport = _renderer?.avTransport;
    if (transport == null) {
      throw StateError('No UPnP playback device is connected');
    }

    return transport;
  }

  @override
  Future<List<String>> supportedMimeTypes(CastDevice device) => readUpnpMimeTypes(_targets[device.id]);

  @override
  Future<void> startDiscovery() async {
    await stopDiscovery();
    _targets.clear();
    devices.add(const []);

    final discoverer = DeviceDiscoverer();
    _discoverer = discoverer;
    _deviceSubscription = discoverer.devices.listen(_addDevice);
    _errorSubscription = discoverer.errors.listen(
      (_) {},
      onError: (Object error) {
        logger('UPnP discovery failed: $error', tag: 'Casting', level: InfoLevel.warning);
      },
    );

    try {
      await discoverer.start(addressTypes: [InternetAddressType.IPv4]);
      await discoverer.getDevices(searchTarget: UpnpDeviceType.mediaRenderer.urn());
    } catch (_) {
      await stopDiscovery();
      rethrow;
    }
  }

  void _addDevice(Device device) {
    if (device is MediaRenderer && device.avTransport != null) {
      final id = device.description?.udn ?? device.url;
      if (id != null) {
        _targets[id] = device;
        devices.add([
          for (final entry in _targets.entries)
            CastDevice(id: entry.key, name: entry.value.description?.friendlyName ?? 'UPnP device', protocol: protocol),
        ]);
      }
    }

    for (final embedded in device.devices) {
      _addDevice(embedded);
    }
  }

  @override
  Future<void> stopDiscovery() async {
    _discoverer?.dispose();
    _discoverer = null;
    await _deviceSubscription?.cancel();
    await _errorSubscription?.cancel();
    _deviceSubscription = null;
    _errorSubscription = null;
  }

  @override
  Future<void> connect(CastDevice device) async {
    final renderer = _targets[device.id];
    if (renderer == null) {
      throw StateError('This UPnP device is no longer available');
    }

    await renderer.avTransport!.getTransportInfo().timeout(const Duration(seconds: 8));
    _renderer = renderer;
    _generation++;
    _pollFailures = 0;
    connected.add(true);
  }

  @override
  Future<void> load(CastMedia media) async {
    _pollTimer?.cancel();
    _pollTimer = null;
    _generation++;
    _commandRevision++;
    _media = media;
    _primed = false;
    _pendingStartPosition = media.position;
    _requestedPlaying = media.autoPlay;
    position.add(media.position);
    status.add(RemoteMediaStatus(playerState: RemotePlayerState.loading, contentId: media.contentId));

    final metadata = MusicTrack(
      id: media.contentId,
      uri: media.uri.toString(),
      title: media.title,
      artist: media.subtitle,
      album: media.title,
      duration: media.duration,
      artUri: media.cover?.toString(),
      protocolInfo: 'http-get:*:${media.mimeType}:*',
    );
    try {
      await _transport.setAVTransportURI(media.uri.toString(), metadata: metadata.toXml());
      if (media.autoPlay) {
        await play();
      } else {
        _publishState(RemotePlayerState.paused);
      }
    } on UPnPException catch (error) {
      if ({501, 704, 714, 716}.contains(error.errorCode)) {
        throw CastPlaybackException('The receiver could not play this audio: $error');
      }

      rethrow;
    }
  }

  void _publishState(RemotePlayerState state) {
    status.add(RemoteMediaStatus(playerState: state, contentId: _media?.contentId));
  }

  Future<void> _waitForAdvancement() async {
    final startup = Completer<void>();
    _startup = startup;
    _lastReceiverPosition = null;
    _lastPositionAdvance = null;
    _playRequestedAt = DateTime.now();
    _pollTimer ??= Timer.periodic(const Duration(seconds: 1), (_) {
      unawaited(_poll());
    });

    try {
      await startup.future.timeout(
        _startupTimeout,
        onTimeout: () {
          throw const CastPlaybackException(
            'The receiver did not start playback. Check its audio format support and output',
          );
        },
      );
    } finally {
      if (identical(_startup, startup)) {
        _startup = null;
      }
    }
  }

  Future<void> _startPlayback() async {
    final generation = _generation;
    final transport = _transport;
    _starting = true;
    _publishState(RemotePlayerState.loading);

    try {
      await transport.play();
      await _waitForAdvancement();
      if (generation != _generation) {
        throw StateError('Cast playback was cancelled');
      }

      final target = _pendingStartPosition ?? Duration.zero;
      if (target > Duration.zero) {
        await seek(target);
        await _waitForAdvancement();
      }
      if (generation != _generation) {
        throw StateError('Cast playback was cancelled');
      }

      _primed = true;
      _pendingStartPosition = null;
      position.add(_lastReceiverPosition ?? target);
      _publishState(_requestedPlaying ? RemotePlayerState.playing : RemotePlayerState.paused);
    } on UPnPException catch (error) {
      throw CastPlaybackException('The receiver could not start playback: $error');
    } finally {
      if (generation == _generation) {
        _starting = false;
      }
    }
  }

  Future<void> _poll() async {
    if (_polling || _seeking || !connected.value) {
      return;
    }

    _polling = true;
    final generation = _generation;
    final revision = _commandRevision;
    try {
      final transport = _transport;
      final progress = await transport.getPositionInfo().timeout(const Duration(seconds: 5));
      final info = await transport.getTransportInfo().timeout(const Duration(seconds: 5));
      if (generation != _generation || revision != _commandRevision || _seeking) {
        return;
      }

      _pollFailures = 0;
      final media = _media;
      final uri = progress.trackURI;
      if (uri != null && uri.isNotEmpty && uri != media?.uri.toString()) {
        _pollTimer?.cancel();
        status.add(
          const RemoteMediaStatus(playerState: RemotePlayerState.idle, idleReason: RemoteIdleReason.cancelled),
        );
        return;
      }

      final stopped =
          info.currentTransportState == TransportState.stopped ||
          info.currentTransportState == TransportState.noMediaPresent;
      final parsedPosition = parseUpnpTime(progress.relTime);
      final isStopReset = stopped && parsedPosition != null && parsedPosition < position.value;
      if (parsedPosition != null && !isStopReset) {
        final previous = _lastReceiverPosition;
        if (previous != null && parsedPosition > previous && parsedPosition - previous <= const Duration(seconds: 5)) {
          _lastPositionAdvance = DateTime.now();
          final startup = _startup;
          if (startup != null && !startup.isCompleted) {
            startup.complete();
          }
        }

        _lastReceiverPosition = parsedPosition;
        if (!_starting) {
          position.add(parsedPosition);
        }
      }

      var state = switch (info.currentTransportState) {
        TransportState.playing => RemotePlayerState.playing,
        TransportState.pausedPlayback => RemotePlayerState.paused,
        TransportState.transitioning => RemotePlayerState.buffering,
        TransportState.stopped || TransportState.noMediaPresent => RemotePlayerState.idle,
        _ => RemotePlayerState.unknown,
      };
      RemoteIdleReason? reason;
      if (state == RemotePlayerState.playing) {
        _playRequestedAt ??= DateTime.now();
        final lastActivity = _lastPositionAdvance ?? _playRequestedAt!;
        final stalledFor = DateTime.now().difference(lastActivity);
        if (stalledFor >= _startupTimeout) {
          reason = RemoteIdleReason.error;
          _pollTimer?.cancel();
          _failStartup('The receiver stopped advancing playback. Check its audio format support and output');
          unawaited(_stopStalledPlayback(transport));
        } else if (_lastPositionAdvance == null || stalledFor >= _stallThreshold) {
          state = RemotePlayerState.buffering;
        }
      } else if (state == RemotePlayerState.paused) {
        _playRequestedAt = null;
        _lastPositionAdvance = null;
      }

      if (info.currentTransportStatus == TransportStatus.errorOccurred) {
        reason = RemoteIdleReason.error;
        _failStartup('The receiver reported a playback error');
      } else if (state == RemotePlayerState.idle && !_starting) {
        final reportedDuration = parseUpnpTime(progress.trackDuration);
        final duration = reportedDuration != null && reportedDuration > Duration.zero
            ? reportedDuration
            : media?.duration ?? Duration.zero;
        final remaining = duration - position.value;
        reason = duration > Duration.zero && remaining <= const Duration(seconds: 2)
            ? RemoteIdleReason.finished
            : RemoteIdleReason.cancelled;

        _pollTimer?.cancel();
        _pollTimer = null;
        if (reason == RemoteIdleReason.finished) {
          position.add(duration);
        }
      }

      if (reason != null) {
        _failStartup('The receiver could not play this audio');
      }

      status.add(
        RemoteMediaStatus(
          playerState: reason == RemoteIdleReason.error
              ? RemotePlayerState.idle
              : (_starting ? RemotePlayerState.loading : state),
          contentId: media?.contentId,
          idleReason: reason,
          playbackRate: double.tryParse(info.currentSpeed ?? '') ?? 1,
        ),
      );
    } catch (error) {
      if (generation == _generation && ++_pollFailures >= 3) {
        _pollTimer?.cancel();
        connected.add(false);
        _failStartup('The receiver stopped responding');
        logger('UPnP receiver stopped responding', tag: 'Casting', level: InfoLevel.warning);
      }
    } finally {
      _polling = false;
    }
  }

  void _failStartup(String message) {
    final startup = _startup;
    if (startup != null && !startup.isCompleted) {
      startup.completeError(CastPlaybackException(message));
    }
  }

  Future<void> _stopStalledPlayback(AvTransportService transport) async {
    logger('UPnP playback stalled', tag: 'Casting', level: InfoLevel.warning);
    try {
      await transport.stop();
    } catch (error) {
      logger('Unable to stop stalled receiver: $error', tag: 'Casting', level: InfoLevel.warning);
    }
  }

  @override
  Future<void> play() async {
    _requestedPlaying = true;
    _commandRevision++;
    if (!_primed) {
      final pending = _startOperation;
      if (pending != null) {
        await pending;
        return;
      }

      final operation = _startPlayback();
      _startOperation = operation;
      try {
        await operation;
      } finally {
        if (identical(_startOperation, operation)) {
          _startOperation = null;
        }
      }
      return;
    }

    _lastReceiverPosition = null;
    _lastPositionAdvance = null;
    _playRequestedAt = DateTime.now();
    await _transport.play();
    _publishState(RemotePlayerState.buffering);
  }

  @override
  Future<void> pause() async {
    _requestedPlaying = false;
    _commandRevision++;
    if (_primed || _starting) {
      await _transport.pause();
    }

    _playRequestedAt = null;
    _lastPositionAdvance = null;
    _publishState(RemotePlayerState.paused);
  }

  @override
  Future<void> stop() async {
    _pollTimer?.cancel();
    _pollTimer = null;
    _failStartup('Cast playback was cancelled');
    _generation++;
    _commandRevision++;
    _starting = false;
    _primed = false;
    _requestedPlaying = false;
    await _transport.stop();
    _publishState(RemotePlayerState.idle);
  }

  @override
  Future<Duration> refreshPosition() async {
    if (!_primed || _starting) {
      return position.value;
    }

    final generation = _generation;
    final revision = _commandRevision;
    final transport = _transport;
    final progress = await transport.getPositionInfo().timeout(const Duration(seconds: 5));
    final info = await transport.getTransportInfo().timeout(const Duration(seconds: 5));
    if (generation != _generation || revision != _commandRevision) {
      return position.value;
    }

    final stopped =
        info.currentTransportState == TransportState.stopped ||
        info.currentTransportState == TransportState.noMediaPresent;
    final updated = parseUpnpTime(progress.relTime);
    if (updated != null && (!stopped || updated >= position.value)) {
      position.add(updated);
    }

    return position.value;
  }

  @override
  Future<void> seek(Duration position) async {
    if (!_primed && !_starting) {
      _pendingStartPosition = position;
      this.position.add(position);
      return;
    }

    _commandRevision++;
    final generation = _generation;
    _seeking = true;
    try {
      final actual = await seekUpnp(
        _transport,
        position,
        isCurrent: () => generation == _generation && connected.value,
      );
      if (!_starting) {
        this.position.add(actual);
      }

      _lastReceiverPosition = null;
      _lastPositionAdvance = null;
      if (_playRequestedAt != null) {
        _playRequestedAt = DateTime.now();
      }
    } finally {
      _seeking = false;
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    final control = _renderer?.renderingControl;
    if (control == null) {
      throw UnsupportedError('This receiver does not support volume control');
    }

    await control.setVolume(volume: (volume.clamp(0, 1) * 100).round());
  }

  @override
  Future<void> setSpeed(double speed) async {
    throw UnsupportedError('Playback speed is unavailable on this UPnP device');
  }

  @override
  Future<void> disconnect() async {
    _failStartup('Cast playback was cancelled');
    _pollTimer?.cancel();
    _pollTimer = null;
    _generation++;
    _commandRevision++;
    _starting = false;
    _primed = false;
    _requestedPlaying = false;
    try {
      if (_renderer != null && connected.value) {
        await _transport.stop().timeout(const Duration(seconds: 5));
      }
    } finally {
      _renderer = null;
      _media = null;
      connected.add(false);
      status.add(null);
    }
  }
}
