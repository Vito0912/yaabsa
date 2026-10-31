import 'package:yaabsa/models/playback_feature.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/cast/chromecast_backend.dart';
import 'package:yaabsa/util/cast/upnp_backend.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';
import 'package:yaabsa/util/logger.dart';

class CastService {
  CastService({List<CastBackend>? backends}) {
    _backends = backends ?? _createBackends();
    for (final backend in _backends) {
      _subscriptions.add(
        backend.features.listen((value) {
          if (identical(_active, backend)) {
            features.add(value);
          }
        }),
      );
      _subscriptions.add(
        backend.devices.listen((_) {
          devices.add([for (final source in _backends) ...source.devices.value]);
        }),
      );
      _subscriptions.add(
        backend.connected.listen((value) {
          if (identical(_active, backend) && value == backend.connected.value) {
            connected.add(value);
          }
        }),
      );
      _subscriptions.add(
        backend.status.listen((value) {
          if (identical(_active, backend) && !_loading) {
            _updateStatus(value);
          }
        }),
      );
      _subscriptions.add(
        backend.position.listen((value) {
          if (identical(_active, backend) && !_loading && position.value != value) {
            position.add(value);
          }
        }),
      );
    }
  }

  static bool get isSupportedPlatform => !kIsWeb;
  static bool get isUpnpSupportedPlatform => !kIsWeb && !Platform.isIOS;

  static List<CastBackend> _createBackends() {
    final backends = <CastBackend>[];
    if (ChromeCastService.isSupportedPlatform) {
      backends.add(ChromecastBackend());
    }
    if (isUpnpSupportedPlatform) {
      backends.add(UpnpBackend());
    }

    return backends;
  }

  List<CastProtocol> get supportedProtocols => _backends.map((backend) => backend.protocol).toList();

  late final List<CastBackend> _backends;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  CastBackend? _active;
  CastDevice? activeDevice;
  bool _connecting = false;
  CastMedia? currentMedia;
  bool _loading = false;
  bool _disposed = false;
  Future<void>? _discoveryFuture;
  int _discoveryGeneration = 0;
  int _connectionGeneration = 0;
  final features = BehaviorSubject<Set<PlaybackFeature>>.seeded(PlaybackFeature.values.toSet());
  final devices = BehaviorSubject<List<CastDevice>>.seeded(const []);
  final connected = BehaviorSubject<bool>.seeded(false);
  final status = BehaviorSubject<RemoteMediaStatus?>.seeded(null);
  final position = BehaviorSubject<Duration>.seeded(Duration.zero);
  final discoveryErrors = BehaviorSubject<List<String>>.seeded(const []);

  bool get hasConnectedSession => connected.value;
  RemoteMediaStatus? get mediaStatus => status.value;
  Duration get playerPosition => position.value;
  Stream<RemoteMediaStatus?> get mediaStatusStream => status.stream;
  Stream<Duration> get playerPositionStream => position.stream;

  CastBackend get _backend {
    final active = _active;
    if (active == null) {
      throw StateError('No cast device is connected');
    }

    return active;
  }

  Future<List<String>> supportedMimeTypes(CastDevice device) {
    return _backends.firstWhere((backend) => backend.protocol == device.protocol).supportedMimeTypes(device);
  }

  Future<void> startDiscovery() {
    if (_disposed) {
      return Future.value();
    }

    return _discoveryFuture ??= _startDiscovery().whenComplete(() {
      _discoveryFuture = null;
    });
  }

  Future<void> _startDiscovery() async {
    final generation = ++_discoveryGeneration;
    discoveryErrors.add(const []);
    await Future.wait(
      _backends.map((backend) async {
        try {
          await backend.startDiscovery();
          if (generation != _discoveryGeneration) {
            await backend.stopDiscovery();
          }
        } catch (error) {
          if (!_disposed) {
            discoveryErrors.add([...discoveryErrors.value, '${backend.protocol.label} discovery failed']);
          }
          logger('Cast discovery failed for ${backend.protocol}: $error', tag: 'Casting', level: InfoLevel.warning);
        }
      }),
    );
  }

  Future<void> stopDiscovery() async {
    _discoveryGeneration++;
    for (final backend in _backends) {
      try {
        await backend.stopDiscovery();
      } catch (error) {
        logger('Unable to stop discovery: $error', tag: 'Casting', level: InfoLevel.warning);
      }
    }
  }

  Future<void> connect(CastDevice device) async {
    if (_connecting) {
      throw StateError('A cast connection is already being prepared');
    }

    _connecting = true;
    try {
      await disconnect();
      final backend = _backends.firstWhere((backend) => backend.protocol == device.protocol);
      final generation = _connectionGeneration;
      _active = backend;
      activeDevice = device;
      await backend.connect(device);
      if (generation != _connectionGeneration) {
        await backend.disconnect();
        throw StateError('Cast connection was cancelled');
      }
      features.add(backend.features.value);
      connected.add(backend.connected.value);
    } catch (_) {
      await disconnect();
      rethrow;
    } finally {
      _connecting = false;
    }
  }

  Future<void> load(CastMedia media, {bool retainConnectionOnFailure = false}) async {
    if (_loading) {
      await _release(media);
      throw StateError('A cast track is already being prepared');
    }

    final backend = _backend;
    final generation = _connectionGeneration;
    final previous = currentMedia;
    _loading = true;
    currentMedia = media;
    position.add(media.position);
    status.add(RemoteMediaStatus(playerState: RemotePlayerState.loading, contentId: media.contentId));

    try {
      await backend.load(media);
      if (generation != _connectionGeneration) {
        throw StateError('Cast playback was cancelled');
      }

      position.add(backend.position.value);
      final loaded = backend.status.value;
      if (loaded?.contentId == media.contentId && loaded?.playerState != RemotePlayerState.idle) {
        status.add(loaded);
      }
    } catch (_) {
      if (generation == _connectionGeneration) {
        try {
          if (retainConnectionOnFailure) {
            await backend.stop();
          } else {
            await backend.disconnect();
          }
        } catch (error) {
          logger('Unable to stop failed cast: $error', tag: 'Casting', level: InfoLevel.warning);
        }

        connected.add(retainConnectionOnFailure && backend.connected.value);
        currentMedia = null;
        await _release(previous);
      }

      await _release(media);
      rethrow;
    } finally {
      _loading = false;
    }

    await _release(previous);
  }

  void _updateStatus(RemoteMediaStatus? value) {
    final previous = status.value;
    if (previous?.playerState == value?.playerState &&
        previous?.contentId == value?.contentId &&
        previous?.idleReason == value?.idleReason &&
        previous?.playbackRate == value?.playbackRate) {
      return;
    }

    status.add(value);
  }

  Future<void> _release(CastMedia? media) async {
    try {
      await media?.release?.call().timeout(const Duration(seconds: 8));
    } catch (error) {
      logger('Unable to close cast stream: $error', tag: 'Casting', level: InfoLevel.warning);
    }
  }

  Future<Duration> refreshPosition() async {
    final backend = _backend;
    final generation = _connectionGeneration;
    final updated = await backend.refreshPosition();
    if (generation == _connectionGeneration) {
      position.add(updated);
    }

    return updated;
  }

  Future<void> play() => _backend.play();
  Future<void> pause() async {
    await _backend.pause();
  }

  Future<void> stop() => disconnect();
  Future<void> seek(Duration position) async {
    await _backend.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _backend.setVolume(volume);
  }

  Future<void> setSpeed(double speed) async {
    if (!features.value.contains(PlaybackFeature.speed)) {
      return;
    }

    await _backend.setSpeed(speed);
  }

  Future<void> disconnect() async {
    _connectionGeneration++;
    final active = _active;
    _active = null;
    try {
      await active?.disconnect();
    } finally {
      _active = null;
      activeDevice = null;
      features.add(PlaybackFeature.values.toSet());
      connected.add(false);
      status.add(null);
      final media = currentMedia;
      currentMedia = null;
      await _release(media);
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    await stopDiscovery();
    await _discoveryFuture;

    try {
      await disconnect();
    } catch (error) {
      logger('Unable to disconnect cast: $error', tag: 'Casting', level: InfoLevel.warning);
    }

    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    for (final backend in _backends) {
      try {
        await backend.dispose();
      } catch (error) {
        logger('Cast cleanup failed: $error', tag: 'Casting', level: InfoLevel.warning);
      }
    }

    await features.close();
    await devices.close();
    await connected.close();
    await status.close();
    await position.close();
    await discoveryErrors.close();
  }
}
