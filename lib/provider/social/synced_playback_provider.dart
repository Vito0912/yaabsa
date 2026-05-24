import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/socket/abs_socket_client.dart';
import 'package:yaabsa/api/socket/events/user_message_event.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/models/social/synced_playback_invite_user.dart';
import 'package:yaabsa/models/social/synced_playback_message.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/social/user_message_consents_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'synced_playback_provider.g.dart';

const String syncedPlaybackFeatureKey = 'yaabsa/synced_playback';
const String syncedPlaybackClientName = 'yaabsa';
const int _syncedPlaybackMessageVersion = 1;
const Duration _syncedPlaybackPositionDriftThreshold = Duration(seconds: 2);
const Duration _localControlBroadcastInterval = Duration(seconds: 6);
const Duration _localControlRebroadcastWindow = Duration(seconds: 10);
const Duration _localBroadcastSuppressionDuration = Duration(milliseconds: 900);
const Duration _inviteResponseTimeout = Duration(seconds: 45);

const Map<String, int> syncedPlaybackFeatureMinBuildByType = <String, int>{
  'invite': 62,
  'invite_response': 62,
  'control': 62,
  'session_end': 62,
};

enum SyncedPlaybackInviteDecision { accept, decline, ignore }

class SyncedPlaybackInvitePrompt {
  const SyncedPlaybackInvitePrompt({
    required this.id,
    required this.sessionId,
    required this.senderUserId,
    required this.senderUsername,
    required this.initialSnapshot,
  });

  final String id;
  final String sessionId;
  final String senderUserId;
  final String senderUsername;
  final SyncedPlaybackControlPayload? initialSnapshot;
}

class SyncedPlaybackNotice {
  const SyncedPlaybackNotice({required this.id, required this.message});

  final String id;
  final String message;
}

class SyncedPlaybackState {
  const SyncedPlaybackState({
    required this.enabled,
    required this.serverSupportsSocial,
    required this.accessDenied,
    required this.clientId,
    required this.clientVersion,
    required this.mutualUsers,
    required this.inviteTargets,
    required this.pendingInvites,
    required this.notices,
    required this.sessionId,
    required this.sessionPeerUserId,
    required this.awaitingInviteResponse,
  });

  final bool enabled;
  final bool serverSupportsSocial;
  final bool accessDenied;
  final String clientId;
  final int clientVersion;
  final List<SyncedPlaybackInviteUser> mutualUsers;
  final List<SyncedPlaybackInviteUser> inviteTargets;
  final List<SyncedPlaybackInvitePrompt> pendingInvites;
  final List<SyncedPlaybackNotice> notices;
  final String? sessionId;
  final String? sessionPeerUserId;
  final bool awaitingInviteResponse;

  bool get isFeatureReady => enabled && serverSupportsSocial && !accessDenied;

  bool get showPlayerMenuEntry => isFeatureReady && inviteTargets.isNotEmpty;

  bool get hasActiveSession => sessionId != null && sessionPeerUserId != null;

  SyncedPlaybackInvitePrompt? get nextInvite => pendingInvites.isEmpty ? null : pendingInvites.first;

  SyncedPlaybackNotice? get nextNotice => notices.isEmpty ? null : notices.first;
}

@Riverpod(keepAlive: true)
class SyncedPlaybackNotifier extends _$SyncedPlaybackNotifier {
  String? _activeUserId;
  String? _activeUsername;

  bool _lastKnownServerSupportsSocial = false;
  bool _lastKnownAccessDenied = false;

  String _clientId = '';
  int _clientVersion = 0;

  List<SyncedPlaybackInviteUser> _cachedMutualUsers = const <SyncedPlaybackInviteUser>[];

  final List<SyncedPlaybackInvitePrompt> _pendingInvites = <SyncedPlaybackInvitePrompt>[];
  final List<SyncedPlaybackNotice> _pendingNotices = <SyncedPlaybackNotice>[];

  String? _activeSessionId;
  String? _activeSessionPeerUserId;
  bool _awaitingInviteResponse = false;

  final Map<String, String> _outgoingInviteSessionToUser = <String, String>{};
  final Map<String, Timer> _inviteTimeoutBySession = <String, Timer>{};

  DateTime _suppressOutgoingUntil = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastControlSnapshotSentAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _awaitingInitialRemoteSync = false;
  String? _lastControlSnapshotHash;
  int _localControlSequence = 0;
  int _lastRemoteControlSequence = 0;

  Future<void> _remoteControlQueue = Future<void>.value();

  StreamSubscription<SocketUserMessageEvent>? _socketMessageSubscription;
  ABSSocketClient? _subscribedSocketClient;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<InternalMedia?>? _mediaSubscription;
  StreamSubscription<double>? _speedSubscription;

  @override
  SyncedPlaybackState build() {
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(settingsManagerProvider);

    final syncedPlaybackEnabled = _isSyncedPlaybackEnabledForUser(currentUser?.id);
    _handleUserSwitch(currentUser);

    if (syncedPlaybackEnabled && currentUser != null) {
      final socialState = ref.watch(userMessageConsentsProvider).value;
      if (socialState != null) {
        _updateFromSocialState(currentUser: currentUser, socialState: socialState);
      }
    }

    final socketClient = ref.watch(absSocketClientProvider);
    _ensureSocketSubscription(socketClient);

    _ensureAudioSubscriptions();
    _ensureClientIdentity();

    if (!syncedPlaybackEnabled && _activeSessionId != null) {
      unawaited(
        _endActiveSession(
          reason: 'disabled',
          notifyPeer: true,
          stopLocalPlayback: false,
          notice: 'Synced playback disabled. Session ended.',
        ),
      );
    }

    ref.onDispose(_disposeResources);

    return _buildCurrentState(
      userId: currentUser?.id,
      username: currentUser?.username,
      syncedPlaybackEnabled: syncedPlaybackEnabled,
    );
  }

  Future<void> sendInvite(String userId) async {
    final currentState = state;
    if (!currentState.isFeatureReady) {
      throw StateError('Synced playback is currently unavailable.');
    }

    final sessionPeerUserId = userId.trim();
    if (sessionPeerUserId.isEmpty) {
      throw StateError('No target user selected for invite.');
    }

    final snapshot = _buildLocalControlSnapshot(reason: 'invite', sequence: 0);
    if (snapshot == null || snapshot.itemId == null || snapshot.itemId!.isEmpty) {
      throw StateError('Start playback before sending a synced playback invite.');
    }

    final sessionId = const Uuid().v4();

    final payload = SyncedPlaybackMessage(
      feature: syncedPlaybackFeatureKey,
      type: 'invite',
      sessionId: sessionId,
      messageVersion: _syncedPlaybackMessageVersion,
      minClientVersion: _minClientVersionForType('invite'),
      invite: SyncedPlaybackInvitePayload(snapshot: snapshot),
    );

    final sent = _sendUserMessage(sessionPeerUserId, payload);
    if (!sent) {
      throw StateError('Could not send invite. Socket connection is unavailable.');
    }

    _outgoingInviteSessionToUser[sessionId] = sessionPeerUserId;
    _awaitingInviteResponse = true;
    _scheduleInviteTimeout(sessionId);
    _emitState();
  }

  Future<void> respondToInvite({required String promptId, required SyncedPlaybackInviteDecision decision}) async {
    final promptIndex = _pendingInvites.indexWhere((prompt) => prompt.id == promptId);
    if (promptIndex < 0) {
      return;
    }

    final prompt = _pendingInvites.removeAt(promptIndex);

    if (decision == SyncedPlaybackInviteDecision.ignore) {
      _emitState();
      return;
    }

    if (decision == SyncedPlaybackInviteDecision.decline) {
      _sendInviteResponse(
        sessionId: prompt.sessionId,
        userId: prompt.senderUserId,
        decision: 'declined',
        reason: 'declined',
      );
      _enqueueNotice('Invite declined.');
      _emitState();
      return;
    }

    if (decision == SyncedPlaybackInviteDecision.accept) {
      final invitedItemId = prompt.initialSnapshot?.itemId?.trim();
      if (invitedItemId == null || invitedItemId.isEmpty) {
        _sendInviteResponse(
          sessionId: prompt.sessionId,
          userId: prompt.senderUserId,
          decision: 'declined',
          reason: 'missing_item',
        );
        _enqueueNotice('Invite could not be accepted because no item was provided.');
        _emitState();
        return;
      }

      final hasItemAccess = await _hasLibraryItemAccess(invitedItemId);
      if (!hasItemAccess) {
        _sendInviteResponse(
          sessionId: prompt.sessionId,
          userId: prompt.senderUserId,
          decision: 'declined',
          reason: 'item_unavailable',
        );
        _enqueueNotice('Invite declined because this item is not available on your account.');
        _emitState();
        return;
      }

      if (_activeSessionId != null) {
        await _endActiveSession(reason: 'switch_session', notifyPeer: true, stopLocalPlayback: false);
      }

      _activeSessionId = prompt.sessionId;
      _activeSessionPeerUserId = prompt.senderUserId;
      _awaitingInviteResponse = false;
      _awaitingInitialRemoteSync = true;
      _localControlSequence = 0;
      _lastRemoteControlSequence = 0;

      _sendInviteResponse(sessionId: prompt.sessionId, userId: prompt.senderUserId, decision: 'accepted');

      if (prompt.initialSnapshot != null) {
        _enqueueRemoteControlApply(
          prompt.initialSnapshot!,
          expectedSessionId: prompt.sessionId,
          expectedPeerUserId: prompt.senderUserId,
        );
      }

      _enqueueNotice('Joined synced playback with ${prompt.senderUsername}.');
      _emitState();
    }
  }

  void consumeNotice(String noticeId) {
    final nextNotices = _pendingNotices.where((notice) => notice.id != noticeId).toList(growable: false);
    if (nextNotices.length == _pendingNotices.length) {
      return;
    }

    _pendingNotices
      ..clear()
      ..addAll(nextNotices);

    _emitState();
  }

  Future<void> leaveSession() async {
    await _endActiveSession(reason: 'manual_leave', notifyPeer: true, stopLocalPlayback: false);
  }

  void _handleUserSwitch(User? nextUser) {
    final nextUserId = nextUser?.id;
    if (_activeUserId == nextUserId) {
      return;
    }

    _activeUserId = nextUserId;
    _activeUsername = nextUser?.username;
    _lastKnownAccessDenied = false;

    _pendingInvites.clear();
    _pendingNotices.clear();

    _cancelInviteTimeouts();
    _outgoingInviteSessionToUser.clear();
    _awaitingInviteResponse = false;

    _activeSessionId = null;
    _activeSessionPeerUserId = null;
    _awaitingInitialRemoteSync = false;
    _localControlSequence = 0;
    _lastRemoteControlSequence = 0;

    _cachedMutualUsers = _loadCachedMutualUsers(nextUserId);
    _lastKnownServerSupportsSocial = _cachedMutualUsers.isNotEmpty;
  }

  void _updateFromSocialState({required User currentUser, required SocialConnectionState socialState}) {
    _lastKnownServerSupportsSocial = socialState.serverSupportsSocial;
    _lastKnownAccessDenied = socialState.accessDenied;

    final nextUsers = socialState.consents.consents
        .where((entry) => entry.otherAccepted)
        .map((entry) {
          final username = (entry.username ?? '').trim();
          return SyncedPlaybackInviteUser(
            userId: entry.userId,
            displayName: username.isEmpty ? entry.userId : username,
          );
        })
        .toList(growable: false);

    nextUsers.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

    if (_sameInviteUserLists(_cachedMutualUsers, nextUsers)) {
      return;
    }

    _cachedMutualUsers = nextUsers;
    _persistCachedMutualUsers(currentUser.id, nextUsers);
  }

  bool _isSyncedPlaybackEnabledForUser(String? userId) {
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    return settingsManager.getUserSetting<bool>(userId, SettingKeys.socialSyncedPlayback, defaultValue: false);
  }

  SyncedPlaybackState _buildCurrentState({
    required String? userId,
    required String? username,
    required bool syncedPlaybackEnabled,
  }) {
    final featureReady = syncedPlaybackEnabled && _lastKnownServerSupportsSocial && !_lastKnownAccessDenied;

    final inviteTargets = <SyncedPlaybackInviteUser>[
      ..._cachedMutualUsers,
      if (featureReady && userId != null && username != null)
        SyncedPlaybackInviteUser(userId: userId, displayName: 'Your other clients', isSelf: true),
    ];

    return SyncedPlaybackState(
      enabled: syncedPlaybackEnabled,
      serverSupportsSocial: _lastKnownServerSupportsSocial,
      accessDenied: _lastKnownAccessDenied,
      clientId: _clientId,
      clientVersion: _clientVersion,
      mutualUsers: List<SyncedPlaybackInviteUser>.unmodifiable(_cachedMutualUsers),
      inviteTargets: List<SyncedPlaybackInviteUser>.unmodifiable(inviteTargets),
      pendingInvites: List<SyncedPlaybackInvitePrompt>.unmodifiable(_pendingInvites),
      notices: List<SyncedPlaybackNotice>.unmodifiable(_pendingNotices),
      sessionId: _activeSessionId,
      sessionPeerUserId: _activeSessionPeerUserId,
      awaitingInviteResponse: _awaitingInviteResponse,
    );
  }

  void _ensureSocketSubscription(ABSSocketClient socketClient) {
    if (identical(_subscribedSocketClient, socketClient) && _socketMessageSubscription != null) {
      return;
    }

    _socketMessageSubscription?.cancel();
    _subscribedSocketClient = socketClient;
    _socketMessageSubscription = socketClient.userMessages.listen(_onIncomingUserMessage);
  }

  void _ensureAudioSubscriptions() {
    if (_playerStateSubscription != null) {
      return;
    }

    try {
      _playerStateSubscription = audioHandler.playerControlStateStream.listen((playerState) {
        if (_activeSessionId != null &&
            !_awaitingInitialRemoteSync &&
            !playerState.playing &&
            playerState.processingState == ProcessingState.idle) {
          _sendStopControlSignal();
          unawaited(
            _endActiveSession(
              reason: 'stopped',
              notifyPeer: true,
              stopLocalPlayback: false,
              notice: 'Synced playback ended because playback was stopped.',
            ),
          );
          return;
        }

        _handleLocalPlaybackSignal('player_state', force: true);
      });

      _positionSubscription = audioHandler.positionStream.listen((_) {
        _handleLocalPlaybackSignal('position');
      });

      _mediaSubscription = audioHandler.mediaItemStream.listen((media) {
        if (_activeSessionId != null &&
            !_awaitingInitialRemoteSync &&
            media == null &&
            !audioHandler.queueTransitionLoading) {
          unawaited(
            _endActiveSession(
              reason: 'stopped',
              notifyPeer: true,
              stopLocalPlayback: false,
              notice: 'Synced playback ended because playback was stopped.',
            ),
          );
          return;
        }

        _handleLocalPlaybackSignal('media_change', force: true);
      });

      _speedSubscription = audioHandler.player.speedStream.listen((_) {
        _handleLocalPlaybackSignal('speed_change', force: true);
      });
    } catch (error) {
      logger(
        'Audio handler is not ready yet for synced playback listeners: $error',
        tag: 'SyncedPlaybackProvider',
        level: InfoLevel.debug,
      );
    }
  }

  void _ensureClientIdentity() {
    if (_clientVersion <= 0) {
      _clientVersion = int.tryParse(packageInfo.buildNumber) ?? 0;
    }

    if (_clientId.isNotEmpty) {
      return;
    }

    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final storedClientId = settingsManager.getGlobalSetting<String>(
      SettingKeys.socialSyncedPlaybackClientId,
      defaultValue: '',
    );

    if (storedClientId.trim().isNotEmpty) {
      _clientId = storedClientId.trim();
      return;
    }

    final generatedClientId = const Uuid().v4();
    _clientId = generatedClientId;
    unawaited(settingsManager.setGlobalSetting<String>(SettingKeys.socialSyncedPlaybackClientId, generatedClientId));
  }

  List<SyncedPlaybackInviteUser> _loadCachedMutualUsers(String? userId) {
    if (userId == null || userId.isEmpty) {
      return const <SyncedPlaybackInviteUser>[];
    }

    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final rawValue = settingsManager.getUserSetting<String>(
      userId,
      SettingKeys.socialSyncedPlaybackAvailabilityCache,
      defaultValue: '',
    );

    if (rawValue.trim().isEmpty) {
      return const <SyncedPlaybackInviteUser>[];
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map<String, dynamic>) {
        return const <SyncedPlaybackInviteUser>[];
      }

      final usersJson = decoded['users'];
      if (usersJson is! List) {
        return const <SyncedPlaybackInviteUser>[];
      }

      return usersJson
          .whereType<Map>()
          .map((entry) {
            final userIdValue = (entry['userId'] ?? '').toString().trim();
            final displayNameValue = (entry['displayName'] ?? '').toString().trim();
            return SyncedPlaybackInviteUser(
              userId: userIdValue,
              displayName: displayNameValue.isEmpty ? userIdValue : displayNameValue,
            );
          })
          .where((entry) => entry.userId.isNotEmpty)
          .toList(growable: false);
    } catch (error) {
      logger(
        'Failed to parse synced playback availability cache: $error',
        tag: 'SyncedPlaybackProvider',
        level: InfoLevel.warning,
      );
      return const <SyncedPlaybackInviteUser>[];
    }
  }

  void _persistCachedMutualUsers(String userId, List<SyncedPlaybackInviteUser> users) {
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final payload = <String, dynamic>{
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'users': users
          .map((user) => <String, dynamic>{'userId': user.userId, 'displayName': user.displayName})
          .toList(growable: false),
    };

    unawaited(
      settingsManager.setUserSetting<String>(
        userId,
        SettingKeys.socialSyncedPlaybackAvailabilityCache,
        jsonEncode(payload),
      ),
    );
  }

  void _scheduleInviteTimeout(String sessionId) {
    _inviteTimeoutBySession[sessionId]?.cancel();
    _inviteTimeoutBySession[sessionId] = Timer(_inviteResponseTimeout, () {
      _inviteTimeoutBySession.remove(sessionId);
      if (_outgoingInviteSessionToUser.remove(sessionId) == null) {
        return;
      }

      _awaitingInviteResponse = _outgoingInviteSessionToUser.isNotEmpty;
      _enqueueNotice('Invite expired without response.');
      _emitState();
    });
  }

  void _cancelInviteTimeouts() {
    for (final timer in _inviteTimeoutBySession.values) {
      timer.cancel();
    }
    _inviteTimeoutBySession.clear();
  }

  void _onIncomingUserMessage(SocketUserMessageEvent event) {
    if (event.message.trim().isEmpty) {
      return;
    }

    if (_isFromThisClient(event)) {
      return;
    }

    final decodedPayload = _decodeSyncedPlaybackPayload(event.message);
    if (decodedPayload == null) {
      return;
    }

    if (!_passesVersionChecks(decodedPayload, event)) {
      if (decodedPayload.type == 'invite') {
        _sendInviteResponse(
          sessionId: decodedPayload.sessionId,
          userId: event.sender.id,
          decision: 'declined',
          reason: 'incompatible_client',
        );
      }
      return;
    }

    switch (decodedPayload.type) {
      case 'invite':
        _handleIncomingInvite(event, decodedPayload);
      case 'invite_response':
        _handleIncomingInviteResponse(event, decodedPayload);
      case 'control':
        _handleIncomingControl(event, decodedPayload);
      case 'session_end':
        _handleIncomingSessionEnd(event, decodedPayload);
      default:
        return;
    }
  }

  bool _isFromThisClient(SocketUserMessageEvent event) {
    final incomingClientId = event.client?.clientId?.trim();
    if (incomingClientId == null || incomingClientId.isEmpty) {
      return false;
    }

    return incomingClientId == _clientId;
  }

  SyncedPlaybackMessage? _decodeSyncedPlaybackPayload(String rawMessage) {
    try {
      final decoded = jsonDecode(rawMessage);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final payload = SyncedPlaybackMessage.fromJson(decoded);
      if (payload.feature != syncedPlaybackFeatureKey) {
        return null;
      }

      return payload;
    } catch (_) {
      return null;
    }
  }

  bool _passesVersionChecks(SyncedPlaybackMessage payload, SocketUserMessageEvent event) {
    final senderVersion = event.client?.clientVersion ?? 0;
    final localVersion = _clientVersion;

    final requiredSenderVersion = _minClientVersionForType(payload.type);
    if (senderVersion < requiredSenderVersion) {
      return false;
    }

    if (localVersion < payload.minClientVersion) {
      return false;
    }

    return true;
  }

  void _handleIncomingInvite(SocketUserMessageEvent event, SyncedPlaybackMessage payload) {
    final currentState = state;
    if (!currentState.isFeatureReady) {
      return;
    }

    if (_activeSessionId != null && _activeSessionId != payload.sessionId) {
      _sendInviteResponse(sessionId: payload.sessionId, userId: event.sender.id, decision: 'declined', reason: 'busy');
      return;
    }

    final promptId = '${payload.sessionId}:${event.sender.id}';
    final alreadyQueued = _pendingInvites.any((prompt) => prompt.id == promptId);
    if (alreadyQueued) {
      return;
    }

    _pendingInvites.add(
      SyncedPlaybackInvitePrompt(
        id: promptId,
        sessionId: payload.sessionId,
        senderUserId: event.sender.id,
        senderUsername: (event.sender.username ?? event.sender.id).trim(),
        initialSnapshot: payload.invite?.snapshot,
      ),
    );

    _emitState();
  }

  void _handleIncomingInviteResponse(SocketUserMessageEvent event, SyncedPlaybackMessage payload) {
    final inviteResponse = payload.inviteResponse;
    if (inviteResponse == null) {
      return;
    }

    final expectedUserId = _outgoingInviteSessionToUser[payload.sessionId];
    if (expectedUserId == null || expectedUserId != event.sender.id) {
      return;
    }

    _inviteTimeoutBySession.remove(payload.sessionId)?.cancel();
    _outgoingInviteSessionToUser.remove(payload.sessionId);
    _awaitingInviteResponse = _outgoingInviteSessionToUser.isNotEmpty;

    switch (inviteResponse.decision) {
      case 'accepted':
        _activeSessionId = payload.sessionId;
        _activeSessionPeerUserId = event.sender.id;
        _awaitingInitialRemoteSync = false;
        _localControlSequence = 0;
        _lastRemoteControlSequence = 0;
        _enqueueNotice('Invite accepted by ${(event.sender.username ?? event.sender.id).trim()}.');
        _handleLocalPlaybackSignal('invite_accepted', force: true);
      case 'declined':
        _enqueueNotice('Invite declined by ${(event.sender.username ?? event.sender.id).trim()}.');
      default:
        return;
    }

    _emitState();
  }

  void _handleIncomingControl(SocketUserMessageEvent event, SyncedPlaybackMessage payload) {
    if (_activeSessionId == null || _activeSessionPeerUserId == null) {
      return;
    }

    if (_activeSessionId != payload.sessionId || _activeSessionPeerUserId != event.sender.id) {
      return;
    }

    final control = payload.control;
    if (control == null) {
      return;
    }

    if (control.isStopped) {
      unawaited(
        _endActiveSession(
          reason: 'peer_stopped',
          notifyPeer: false,
          stopLocalPlayback: true,
          notice: 'Synced playback ended because the other client stopped playback.',
        ),
      );
      return;
    }

    _enqueueRemoteControlApply(control, expectedSessionId: payload.sessionId, expectedPeerUserId: event.sender.id);
  }

  void _handleIncomingSessionEnd(SocketUserMessageEvent event, SyncedPlaybackMessage payload) {
    if (_activeSessionId == null || _activeSessionPeerUserId == null) {
      return;
    }

    if (_activeSessionId != payload.sessionId || _activeSessionPeerUserId != event.sender.id) {
      return;
    }

    unawaited(
      _endActiveSession(
        reason: payload.sessionEnd?.reason ?? 'remote_end',
        notifyPeer: false,
        stopLocalPlayback: true,
        notice: 'Synced playback ended by ${(event.sender.username ?? event.sender.id).trim()}.',
      ),
    );
  }

  void _handleLocalPlaybackSignal(String reason, {bool force = false}) {
    if (_activeSessionId == null || _activeSessionPeerUserId == null) {
      return;
    }

    if (DateTime.now().isBefore(_suppressOutgoingUntil)) {
      return;
    }

    final now = DateTime.now();
    if (!force && now.difference(_lastControlSnapshotSentAt) < _localControlBroadcastInterval) {
      return;
    }

    final nextSequence = ++_localControlSequence;
    final snapshot = _buildLocalControlSnapshot(reason: reason, sequence: nextSequence);
    if (snapshot == null || snapshot.itemId == null || snapshot.itemId!.isEmpty) {
      return;
    }

    final nextHash = _snapshotHash(snapshot);
    if (!force &&
        nextHash == _lastControlSnapshotHash &&
        now.difference(_lastControlSnapshotSentAt) < _localControlRebroadcastWindow) {
      return;
    }

    _lastControlSnapshotHash = nextHash;
    _lastControlSnapshotSentAt = now;

    final payload = SyncedPlaybackMessage(
      feature: syncedPlaybackFeatureKey,
      type: 'control',
      sessionId: _activeSessionId!,
      messageVersion: _syncedPlaybackMessageVersion,
      minClientVersion: _minClientVersionForType('control'),
      control: snapshot,
    );

    final didSend = _sendUserMessage(_activeSessionPeerUserId!, payload);
    if (!didSend) {
      return;
    }
  }

  void _sendStopControlSignal() {
    final sessionId = _activeSessionId;
    final peerUserId = _activeSessionPeerUserId;
    if (sessionId == null || peerUserId == null) {
      return;
    }

    final payload = SyncedPlaybackMessage(
      feature: syncedPlaybackFeatureKey,
      type: 'control',
      sessionId: sessionId,
      messageVersion: _syncedPlaybackMessageVersion,
      minClientVersion: _minClientVersionForType('control'),
      control: SyncedPlaybackControlPayload(
        sequence: ++_localControlSequence,
        isPlaying: false,
        isStopped: true,
        reason: 'stopped',
      ),
    );

    _sendUserMessage(peerUserId, payload);
  }

  SyncedPlaybackControlPayload? _buildLocalControlSnapshot({required String reason, required int sequence}) {
    try {
      final media = audioHandler.currentMediaItem;
      if (media == null) {
        return null;
      }

      final playerState = audioHandler.playerControlState;
      final isPlaying = playerState.playing && playerState.processingState == ProcessingState.ready;

      return SyncedPlaybackControlPayload(
        itemId: media.itemId,
        episodeId: media.episodeId,
        positionMs: audioHandler.position.inMilliseconds,
        speed: audioHandler.player.speed,
        sequence: sequence,
        isBuffering:
            playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering,
        isPlaying: isPlaying,
        isStopped: false,
        reason: reason,
      );
    } catch (error) {
      logger(
        'Failed to create synced playback control snapshot: $error',
        tag: 'SyncedPlaybackProvider',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  void _enqueueRemoteControlApply(
    SyncedPlaybackControlPayload control, {
    required String expectedSessionId,
    required String expectedPeerUserId,
  }) {
    final incomingSequence = control.sequence;
    if (incomingSequence > 0) {
      if (incomingSequence <= _lastRemoteControlSequence) {
        return;
      }
      _lastRemoteControlSequence = incomingSequence;
    }

    _remoteControlQueue = _remoteControlQueue.catchError((_) {}).then((_) async {
      if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
        return;
      }

      await _applyRemoteControl(control, expectedSessionId: expectedSessionId, expectedPeerUserId: expectedPeerUserId);
    });
  }

  Future<void> _applyRemoteControl(
    SyncedPlaybackControlPayload control, {
    required String expectedSessionId,
    required String expectedPeerUserId,
  }) async {
    if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
      return;
    }

    _suppressOutgoingUntil = DateTime.now().add(_localBroadcastSuppressionDuration);

    try {
      final targetItemId = control.itemId?.trim();
      if (targetItemId == null || targetItemId.isEmpty) {
        return;
      }

      final targetEpisodeId = control.episodeId?.trim();
      final targetPosition = Duration(milliseconds: control.positionMs < 0 ? 0 : control.positionMs);

      final currentMedia = audioHandler.currentMediaItem;
      final itemMatches =
          currentMedia != null && currentMedia.itemId == targetItemId && currentMedia.episodeId == targetEpisodeId;

      if (!itemMatches) {
        if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
          return;
        }

        await audioHandler.playItemFromPosition(
          itemId: targetItemId,
          episodeId: targetEpisodeId,
          position: targetPosition,
        );
      } else {
        final currentPosition = audioHandler.position;
        if ((currentPosition - targetPosition).abs() > _syncedPlaybackPositionDriftThreshold) {
          if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
            return;
          }

          await audioHandler.seek(targetPosition);
        }
      }

      final currentSpeed = audioHandler.player.speed;
      if ((currentSpeed - control.speed).abs() > 0.01) {
        if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
          return;
        }

        await audioHandler.setSpeed(control.speed);
      }

      final currentPlayerState = audioHandler.playerControlState;
      final isPlayingNow = currentPlayerState.playing && currentPlayerState.processingState == ProcessingState.ready;

      if (control.isBuffering) {
        if (isPlayingNow) {
          if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
            return;
          }

          await audioHandler.pause();
        }
      } else if (control.isPlaying && !isPlayingNow) {
        if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
          return;
        }

        await audioHandler.play();
      } else if (!control.isPlaying && isPlayingNow) {
        if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
          return;
        }

        await audioHandler.pause();
      }

      final postApplyPosition = audioHandler.position;
      if ((postApplyPosition - targetPosition).abs() > _syncedPlaybackPositionDriftThreshold) {
        if (!_isExpectedSession(expectedSessionId, expectedPeerUserId)) {
          return;
        }

        await audioHandler.seek(targetPosition);
      }
    } catch (error, stackTrace) {
      logger(
        'Failed to apply remote synced playback control: $error\n$stackTrace',
        tag: 'SyncedPlaybackProvider',
        level: InfoLevel.warning,
      );
    } finally {
      _suppressOutgoingUntil = DateTime.now().add(_localBroadcastSuppressionDuration);
      _awaitingInitialRemoteSync = false;
    }
  }

  bool _isExpectedSession(String expectedSessionId, String expectedPeerUserId) {
    return _activeSessionId == expectedSessionId && _activeSessionPeerUserId == expectedPeerUserId;
  }

  Future<void> _endActiveSession({
    required String reason,
    required bool notifyPeer,
    required bool stopLocalPlayback,
    String? notice,
  }) async {
    final sessionId = _activeSessionId;
    final peerUserId = _activeSessionPeerUserId;

    if (sessionId == null || peerUserId == null) {
      return;
    }

    _activeSessionId = null;
    _activeSessionPeerUserId = null;
    _awaitingInitialRemoteSync = false;
    _localControlSequence = 0;
    _lastRemoteControlSequence = 0;
    _awaitingInviteResponse = _outgoingInviteSessionToUser.isNotEmpty;

    if (notifyPeer) {
      final payload = SyncedPlaybackMessage(
        feature: syncedPlaybackFeatureKey,
        type: 'session_end',
        sessionId: sessionId,
        messageVersion: _syncedPlaybackMessageVersion,
        minClientVersion: _minClientVersionForType('session_end'),
        sessionEnd: SyncedPlaybackSessionEndPayload(reason: reason),
      );
      _sendUserMessage(peerUserId, payload);
    }

    if (stopLocalPlayback) {
      _suppressOutgoingUntil = DateTime.now().add(_localBroadcastSuppressionDuration);
      await audioHandler.stop();
    }

    if (notice != null && notice.trim().isNotEmpty) {
      _enqueueNotice(notice.trim());
    }

    _emitState();
  }

  void _sendInviteResponse({
    required String sessionId,
    required String userId,
    required String decision,
    String? reason,
  }) {
    final payload = SyncedPlaybackMessage(
      feature: syncedPlaybackFeatureKey,
      type: 'invite_response',
      sessionId: sessionId,
      messageVersion: _syncedPlaybackMessageVersion,
      minClientVersion: _minClientVersionForType('invite_response'),
      inviteResponse: SyncedPlaybackInviteResponsePayload(decision: decision, reason: reason),
    );

    _sendUserMessage(userId, payload);
  }

  bool _sendUserMessage(String userId, SyncedPlaybackMessage payload) {
    if (_activeUserId == null || _activeUserId!.isEmpty) {
      return false;
    }

    if (_clientId.isEmpty) {
      _ensureClientIdentity();
    }

    final socketClient = _subscribedSocketClient;
    if (socketClient == null) {
      return false;
    }

    return socketClient.sendUserMessage(
      userId: userId,
      message: jsonEncode(payload.toJson()),
      client: syncedPlaybackClientName,
      clientVersion: _clientVersion,
      clientId: _clientId,
    );
  }

  String _snapshotHash(SyncedPlaybackControlPayload snapshot) {
    final quantizedPosition = (snapshot.positionMs / 500).round();
    final quantizedSpeed = (snapshot.speed * 100).round();
    return '${snapshot.itemId}|${snapshot.episodeId}|$quantizedPosition|$quantizedSpeed|${snapshot.isBuffering}|${snapshot.isPlaying}|${snapshot.isStopped}';
  }

  Future<bool> _hasLibraryItemAccess(String itemId) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return false;
    }

    try {
      final response = await api.getLibraryItemApi().getLibraryItem(itemId: itemId);
      final resolvedItemId = response.data?.id.trim();
      if (resolvedItemId == null || resolvedItemId.isEmpty) {
        return false;
      }
      return resolvedItemId == itemId;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 403 || statusCode == 404) {
        return false;
      }

      logger(
        'Failed to validate invited item access ($itemId): $error',
        tag: 'SyncedPlaybackProvider',
        level: InfoLevel.warning,
      );
      return false;
    } catch (error) {
      logger(
        'Failed to validate invited item access ($itemId): $error',
        tag: 'SyncedPlaybackProvider',
        level: InfoLevel.warning,
      );
      return false;
    }
  }

  int _minClientVersionForType(String type) {
    return syncedPlaybackFeatureMinBuildByType[type] ?? 0;
  }

  bool _sameInviteUserLists(List<SyncedPlaybackInviteUser> left, List<SyncedPlaybackInviteUser> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var i = 0; i < left.length; i++) {
      final leftUser = left[i];
      final rightUser = right[i];
      if (leftUser.userId != rightUser.userId || leftUser.displayName != rightUser.displayName) {
        return false;
      }
    }

    return true;
  }

  void _enqueueNotice(String message) {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return;
    }

    final noticeId = 'notice_${DateTime.now().microsecondsSinceEpoch}';
    _pendingNotices.add(SyncedPlaybackNotice(id: noticeId, message: trimmedMessage));
  }

  void _emitState() {
    if (!ref.mounted) {
      return;
    }

    final syncedPlaybackEnabled = _isSyncedPlaybackEnabledForUser(_activeUserId);
    state = _buildCurrentState(
      userId: _activeUserId,
      username: _activeUsername,
      syncedPlaybackEnabled: syncedPlaybackEnabled,
    );
  }

  void _disposeResources() {
    _socketMessageSubscription?.cancel();
    _socketMessageSubscription = null;
    _subscribedSocketClient = null;

    _playerStateSubscription?.cancel();
    _playerStateSubscription = null;

    _positionSubscription?.cancel();
    _positionSubscription = null;

    _mediaSubscription?.cancel();
    _mediaSubscription = null;

    _speedSubscription?.cancel();
    _speedSubscription = null;

    _cancelInviteTimeouts();
  }
}
