import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

Future<void> showCastDevicePicker(BuildContext context, {bool ensureInitialized = true}) async {
  if (!(Platform.isAndroid || Platform.isIOS)) {
    _showCastMessage(context, 'Chrome Cast is unavailable on this platform.');
    return;
  }

  if (ensureInitialized) {
    final initialized = await ChromeCastService.ensureInitialized();
    if (!initialized) {
      _showCastMessage(context, 'Chrome Cast is unavailable on this device.');
      return;
    }
  }

  await GoogleCastDiscoveryManager.instance.startDiscovery();

  try {
    if (!context.mounted) {
      return;
    }

    final selectedDevice = await showModalBottomSheet<GoogleCastDevice>(
      context: context,
      showDragHandle: true,
      builder: (context) => _CastDeviceSheet(onDisconnect: () => _disconnectSession(context)),
    );

    if (selectedDevice == null) {
      return;
    }

    await _connectAndCast(context, selectedDevice);
  } finally {
    await GoogleCastDiscoveryManager.instance.stopDiscovery();
  }
}

void _showCastMessage(BuildContext context, String message) {
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> _disconnectSession(BuildContext context) async {
  try {
    await GoogleCastSessionManager.instance.endSessionAndStopCasting();
    audioHandler.deactivateCastControl();
    _showCastMessage(context, 'Disconnected from cast device.');
  } catch (e) {
    _showCastMessage(context, 'Failed to disconnect: $e');
  }
}

Future<void> _connectAndCast(BuildContext context, GoogleCastDevice device) async {
  try {
    final started = await GoogleCastSessionManager.instance.startSessionWithDevice(device);
    final connected = started
        ? await _waitForConnectedSession()
        : GoogleCastSessionManager.instance.hasConnectedSession;

    if (!connected) {
      _showCastMessage(context, 'Unable to connect to ${device.friendlyName}.');
      return;
    }

    final castTarget = await _castCurrentTrack(context);
    if (castTarget == null) {
      return;
    }

    await audioHandler.pause();
    audioHandler.activateCastControl(contentId: castTarget.contentId, trackIndex: castTarget.trackIndex);
    _showCastMessage(context, 'Casting to ${device.friendlyName}.');
  } catch (e) {
    logger('Failed to connect and cast: $e', tag: 'CastButton', level: InfoLevel.warning);
    _showCastMessage(context, 'Failed to cast: $e');
  }
}

Future<bool> _waitForConnectedSession() async {
  if (GoogleCastSessionManager.instance.hasConnectedSession) {
    return true;
  }

  try {
    await GoogleCastSessionManager.instance.currentSessionStream
        .firstWhere((session) => session?.connectionState == GoogleCastConnectState.connected)
        .timeout(const Duration(seconds: 8));

    return true;
  } catch (_) {
    return GoogleCastSessionManager.instance.hasConnectedSession;
  }
}

Future<_CastTarget?> _castCurrentTrack(BuildContext context) async {
  final media = audioHandler.currentMediaItem;
  if (media == null || media.tracks.isEmpty) {
    _showCastMessage(context, 'Nothing is currently playing to cast.');
    return null;
  }

  final currentTrackIndex = audioHandler.player.currentIndex ?? 0;
  if (currentTrackIndex < 0 || currentTrackIndex >= media.tracks.length) {
    _showCastMessage(context, 'Unable to determine the current track.');
    return null;
  }

  final currentTrack = media.tracks[currentTrackIndex];
  final trackUrl = currentTrack.url;

  if (trackUrl == null || trackUrl.isEmpty) {
    _showCastMessage(context, 'Current track does not have a playable URL.');
    return null;
  }

  final trackUri = Uri.tryParse(trackUrl);
  if (trackUri == null || !(trackUri.scheme == 'http' || trackUri.scheme == 'https')) {
    _showCastMessage(context, 'Casting local files is not supported.');
    return null;
  }

  final metadataImages = <GoogleCastImage>[];
  final coverUri = media.cover;
  if (coverUri != null && (coverUri.scheme == 'http' || coverUri.scheme == 'https')) {
    metadataImages.add(GoogleCastImage(url: coverUri));
  }

  final metadata = GoogleCastGenericMediaMetadata(
    title: media.title,
    subtitle: media.author ?? media.subtitle,
    images: metadataImages.isEmpty ? null : metadataImages,
  );

  final contentType = currentTrack.mimeType.isNotEmpty ? currentTrack.mimeType : 'audio/mpeg';

  final GoogleCastMediaInformation mediaInfo;
  if (Platform.isAndroid) {
    mediaInfo = GoogleCastMediaInformationAndroid(
      contentId: media.id,
      streamType: CastMediaStreamType.buffered,
      contentType: contentType,
      contentUrl: trackUri,
      metadata: metadata,
    );
  } else {
    mediaInfo = GoogleCastMediaInformationIOS(
      contentId: media.id,
      streamType: CastMediaStreamType.buffered,
      contentType: contentType,
      contentUrl: trackUri,
      metadata: metadata,
    );
  }

  final requestHeaders = audioHandler.currentRequestHeaders;

  await GoogleCastRemoteMediaClient.instance.loadMedia(
    mediaInfo,
    autoPlay: true,
    playPosition: audioHandler.player.position,
    customData: requestHeaders.isEmpty ? null : <String, dynamic>{'headers': requestHeaders},
  );

  return _CastTarget(contentId: media.id, trackIndex: currentTrackIndex);
}

class _CastTarget {
  const _CastTarget({required this.contentId, required this.trackIndex});

  final String contentId;
  final int trackIndex;
}

class CastButton extends ConsumerStatefulWidget {
  const CastButton({super.key, this.iconSize});

  final double? iconSize;

  @override
  ConsumerState<CastButton> createState() => _CastButtonState();
}

class _CastButtonState extends ConsumerState<CastButton> {
  bool _initializationAttempted = false;
  bool _isInitialized = false;

  bool get _isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    unawaited(_ensureInitialized());
  }

  Future<bool> _ensureInitialized() async {
    if (!_isSupportedPlatform) {
      return false;
    }

    final initialized = await ChromeCastService.ensureInitialized();
    if (!mounted) {
      return initialized;
    }

    setState(() {
      _initializationAttempted = true;
      _isInitialized = initialized;
    });

    return initialized;
  }

  Future<void> _handlePressed() async {
    final initialized = _isInitialized || await _ensureInitialized();
    if (!initialized) {
      _showCastMessage(context, 'Chrome Cast is unavailable on this device.');
      return;
    }

    await showCastDevicePicker(context, ensureInitialized: false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupportedPlatform) {
      return const SizedBox.shrink();
    }

    if (!_isInitialized && _initializationAttempted) {
      return IconButton(
        onPressed: _handlePressed,
        tooltip: 'Retry Cast setup',
        iconSize: widget.iconSize,
        icon: const Icon(Icons.cast),
      );
    }

    if (!_isInitialized) {
      return IconButton(
        onPressed: _handlePressed,
        tooltip: 'Connect to a cast device',
        iconSize: widget.iconSize,
        icon: const Icon(Icons.cast),
      );
    }

    return StreamBuilder<GoogleCastSession?>(
      stream: GoogleCastSessionManager.instance.currentSessionStream,
      initialData: GoogleCastSessionManager.instance.currentSession,
      builder: (context, snapshot) {
        final hasConnectedSession = GoogleCastSessionManager.instance.hasConnectedSession;
        final session = snapshot.data;
        final isConnected = hasConnectedSession || session?.connectionState == GoogleCastConnectState.connected;

        return IconButton(
          onPressed: _handlePressed,
          tooltip: isConnected ? 'Manage cast device' : 'Connect to a cast device',
          iconSize: widget.iconSize,
          icon: Icon(isConnected ? Icons.cast_connected : Icons.cast),
        );
      },
    );
  }
}

class _CastDeviceSheet extends StatelessWidget {
  const _CastDeviceSheet({required this.onDisconnect});

  final Future<void> Function() onDisconnect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Cast Devices', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              StreamBuilder<GoogleCastSession?>(
                stream: GoogleCastSessionManager.instance.currentSessionStream,
                initialData: GoogleCastSessionManager.instance.currentSession,
                builder: (context, sessionSnapshot) {
                  final hasConnectedSession = GoogleCastSessionManager.instance.hasConnectedSession;
                  final session = sessionSnapshot.data;
                  final isConnected =
                      hasConnectedSession || session?.connectionState == GoogleCastConnectState.connected;

                  return Expanded(
                    child: StreamBuilder<List<GoogleCastDevice>>(
                      stream: GoogleCastDiscoveryManager.instance.devicesStream,
                      initialData: GoogleCastDiscoveryManager.instance.devices,
                      builder: (context, devicesSnapshot) {
                        final devices = devicesSnapshot.data ?? const <GoogleCastDevice>[];

                        if (devices.isEmpty && !isConnected) {
                          return const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.4)),
                                SizedBox(height: 10),
                                Text('Searching for cast devices...'),
                              ],
                            ),
                          );
                        }

                        return ListView(
                          children: [
                            if (isConnected && session?.device != null)
                              ListTile(
                                leading: const Icon(Icons.cast_connected),
                                title: Text(session!.device!.friendlyName),
                                subtitle: const Text('Connected'),
                                trailing: TextButton(
                                  onPressed: () async {
                                    await onDisconnect();
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: const Text('Disconnect'),
                                ),
                              ),
                            for (final device in devices)
                              ListTile(
                                leading: const Icon(Icons.cast),
                                title: Text(device.friendlyName),
                                subtitle: Text(device.modelName ?? 'Unknown model'),
                                onTap: () => Navigator.of(context).pop(device),
                              ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
