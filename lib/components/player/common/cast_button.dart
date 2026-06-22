import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/audio_track.dart';
import 'package:yaabsa/api/library_items/request/play_library_item_request.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/player_utils.dart';

String? _resolveCastAvailabilityMessage() {
  final media = audioHandler.currentMediaItem;
  if (media == null || media.tracks.isEmpty) {
    return 'Nothing is currently playing to cast.';
  }

  final currentTrackIndex = audioHandler.player.currentIndex ?? 0;
  if (currentTrackIndex < 0 || currentTrackIndex >= media.tracks.length) {
    return 'Unable to determine the current track.';
  }

  final currentTrack = media.tracks[currentTrackIndex];
  final trackUrl = currentTrack.url;
  if (trackUrl == null || trackUrl.isEmpty) {
    return 'Current track does not have a playable URL.';
  }

  final trackUri = Uri.tryParse(trackUrl);
  if (trackUri == null) {
    return 'Current track does not have a playable URL.';
  }

  if (!_isHttpUri(trackUri) && containerRef.read(absApiProvider) == null) {
    return 'Casting local downloads requires an active server connection.';
  }

  return null;
}

bool _isHttpUri(Uri uri) {
  return uri.scheme == 'http' || uri.scheme == 'https';
}

AudioTrack? _selectRemoteCastTrack({
  required List<AudioTrack> remoteTracks,
  required InternalTrack currentTrack,
  required int currentTrackIndex,
}) {
  for (final remoteTrack in remoteTracks) {
    if (remoteTrack.index != null && remoteTrack.index == currentTrack.index) {
      return remoteTrack;
    }
  }

  if (currentTrackIndex >= 0 && currentTrackIndex < remoteTracks.length) {
    return remoteTracks[currentTrackIndex];
  }

  return remoteTracks.isNotEmpty ? remoteTracks.first : null;
}

Future<_ResolvedCastTrack?> _resolveRemoteCastTrack({
  required InternalMedia media,
  required InternalTrack currentTrack,
  required int currentTrackIndex,
}) async {
  final api = containerRef.read(absApiProvider);
  if (api == null) {
    return null;
  }

  try {
    final playRequest = PlayLibraryItemRequest(
      deviceInfo: await PlayerUtils.getDeviceInfo(),
      forceDirectPlay: false,
      forceTranscode: false,
      supportedMimeTypes: await PlayerUtils.getSupportedMimeTypes(),
      mediaPlayer: '$appName cast',
    );

    final remoteSession = (await api.getLibraryItemApi().playLibraryItem(
      media.itemId,
      episodeId: media.episodeId,
      playRequest: playRequest,
    )).data;

    if (remoteSession == null) {
      return null;
    }

    final remoteTracks = remoteSession.audioTracks ?? const <AudioTrack>[];
    final remoteTrack = _selectRemoteCastTrack(
      remoteTracks: remoteTracks,
      currentTrack: currentTrack,
      currentTrackIndex: currentTrackIndex,
    );
    if (remoteTrack == null) {
      return null;
    }

    final resolvedRemoteIndex = remoteTrack.index ?? currentTrack.index;
    final remoteTrackUrl = remoteTrack
        .toInternalTrack(api.basePathOverride, remoteSession.id, localIndex: resolvedRemoteIndex)
        .url;

    if (remoteTrackUrl == null || remoteTrackUrl.isEmpty) {
      return null;
    }

    final remoteUri = Uri.tryParse(remoteTrackUrl);
    if (remoteUri == null || !_isHttpUri(remoteUri)) {
      return null;
    }

    return _ResolvedCastTrack(uri: remoteUri, mimeType: remoteTrack.mimeType);
  } catch (e, s) {
    logger('Failed to resolve remote cast track for ${media.id}: $e\n$s', tag: 'CastButton', level: InfoLevel.warning);
    return null;
  }
}

Future<_ResolvedCastTrack?> _resolveCastTrack({
  required InternalMedia media,
  required InternalTrack currentTrack,
  required int currentTrackIndex,
}) async {
  final trackUrl = currentTrack.url;
  if (trackUrl == null || trackUrl.isEmpty) {
    return null;
  }

  final parsedTrackUri = Uri.tryParse(trackUrl);
  if (parsedTrackUri != null && _isHttpUri(parsedTrackUri)) {
    return _ResolvedCastTrack(uri: parsedTrackUri, mimeType: currentTrack.mimeType);
  }

  return _resolveRemoteCastTrack(media: media, currentTrack: currentTrack, currentTrackIndex: currentTrackIndex);
}

Uri? _resolveCastCoverUri(InternalMedia media) {
  final coverUri = media.cover;
  if (coverUri != null && _isHttpUri(coverUri)) {
    return coverUri;
  }

  final api = containerRef.read(absApiProvider);
  if (api == null) {
    return null;
  }

  return api.getLibraryItemApi().getCoverUri(media.itemId);
}

Future<void> showCastDevicePicker(BuildContext context, {bool ensureInitialized = true}) async {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
    _showCastMessage(context, 'Chrome Cast is unavailable on this platform.');
    return;
  }

  final castUnavailableMessage = _resolveCastAvailabilityMessage();
  if (castUnavailableMessage != null) {
    _showCastMessage(context, castUnavailableMessage);
    return;
  }

  if (ensureInitialized) {
    final initialized = await ChromeCastService.ensureInitialized();
    if (!context.mounted) {
      return;
    }

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
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => _CastDeviceSheet(onDisconnect: () => _disconnectSession(context)),
    );

    if (selectedDevice == null) {
      return;
    }

    if (!context.mounted) {
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
    final castPosition = audioHandler.position;

    await GoogleCastSessionManager.instance.endSessionAndStopCasting();
    if (!context.mounted) {
      return;
    }

    await audioHandler.deactivateCastControl(fallbackPosition: castPosition);
    if (!context.mounted) {
      return;
    }
    _showCastMessage(context, 'Disconnected from cast device.');
  } catch (e) {
    if (!context.mounted) {
      return;
    }

    _showCastMessage(context, 'Failed to disconnect: $e');
  }
}

Future<void> _connectAndCast(BuildContext context, GoogleCastDevice device) async {
  try {
    final started = await GoogleCastSessionManager.instance.startSessionWithDevice(device);
    final connected = started
        ? await _waitForConnectedSession()
        : GoogleCastSessionManager.instance.hasConnectedSession;

    if (!context.mounted) {
      return;
    }

    if (!connected) {
      _showCastMessage(context, 'Unable to connect to ${device.friendlyName}.');
      return;
    }

    final castTarget = await _castCurrentTrack(context);
    if (!context.mounted) {
      return;
    }

    if (castTarget == null) {
      return;
    }

    await audioHandler.pause();
    if (!context.mounted) {
      return;
    }

    audioHandler.activateCastControl(contentId: castTarget.contentId, trackIndex: castTarget.trackIndex);
    _showCastMessage(context, 'Casting to ${device.friendlyName}.');
  } catch (e) {
    if (!context.mounted) {
      return;
    }

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
  final resolvedCastTrack = await _resolveCastTrack(
    media: media,
    currentTrack: currentTrack,
    currentTrackIndex: currentTrackIndex,
  );
  if (!context.mounted) {
    return null;
  }

  if (resolvedCastTrack == null) {
    final hasApi = containerRef.read(absApiProvider) != null;
    _showCastMessage(
      context,
      hasApi
          ? 'Unable to prepare a server stream for this item.'
          : 'Casting local downloads requires an active server connection.',
    );
    return null;
  }

  final metadataImages = <GoogleCastImage>[];
  final coverUri = _resolveCastCoverUri(media);
  if (coverUri != null) {
    metadataImages.add(GoogleCastImage(url: coverUri));
  }

  final metadata = GoogleCastGenericMediaMetadata(
    title: media.title,
    subtitle: media.author ?? media.subtitle,
    images: metadataImages.isEmpty ? null : metadataImages,
  );

  final contentType = resolvedCastTrack.mimeType.isNotEmpty
      ? resolvedCastTrack.mimeType
      : (currentTrack.mimeType.isNotEmpty ? currentTrack.mimeType : 'audio/mpeg');

  final GoogleCastMediaInformation mediaInfo;
  if (!kIsWeb && Platform.isAndroid) {
    mediaInfo = GoogleCastMediaInformationAndroid(
      contentId: media.id,
      streamType: CastMediaStreamType.buffered,
      contentType: contentType,
      contentUrl: resolvedCastTrack.uri,
      metadata: metadata,
    );
  } else {
    mediaInfo = GoogleCastMediaInformationIOS(
      contentId: media.id,
      streamType: CastMediaStreamType.buffered,
      contentType: contentType,
      contentUrl: resolvedCastTrack.uri,
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

class _ResolvedCastTrack {
  const _ResolvedCastTrack({required this.uri, required this.mimeType});

  final Uri uri;
  final String mimeType;
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

  bool get _isSupportedPlatform => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

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
    final castUnavailableMessage = _resolveCastAvailabilityMessage();
    if (castUnavailableMessage != null) {
      _showCastMessage(context, castUnavailableMessage);
      return;
    }

    final initialized = _isInitialized || await _ensureInitialized();
    if (!mounted) {
      return;
    }

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
