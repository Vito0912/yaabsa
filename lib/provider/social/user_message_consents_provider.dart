import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/me/user_message_consents.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

part 'user_message_consents_provider.g.dart';

const String socialWebsocketCompatibilityFlag = 'vito0912/websocket';

class SocialConnectionState {
  const SocialConnectionState({
    required this.consents,
    required this.serverSupportsSocial,
    required this.accessDenied,
    this.busyUserIds = const <String>{},
  });

  const SocialConnectionState.empty()
    : consents = const UserMessageConsents(),
      serverSupportsSocial = false,
      accessDenied = false,
      busyUserIds = const <String>{};

  final UserMessageConsents consents;
  final bool serverSupportsSocial;
  final bool accessDenied;
  final Set<String> busyUserIds;

  bool isBusyForUser(String userId) => busyUserIds.contains(userId);

  SocialConnectionState copyWith({
    UserMessageConsents? consents,
    bool? serverSupportsSocial,
    bool? accessDenied,
    Set<String>? busyUserIds,
  }) {
    return SocialConnectionState(
      consents: consents ?? this.consents,
      serverSupportsSocial: serverSupportsSocial ?? this.serverSupportsSocial,
      accessDenied: accessDenied ?? this.accessDenied,
      busyUserIds: busyUserIds ?? this.busyUserIds,
    );
  }
}

@Riverpod(keepAlive: true)
class UserMessageConsentsNotifier extends _$UserMessageConsentsNotifier {
  @override
  Future<SocialConnectionState> build() async {
    final currentUser = ref.watch(currentUserProvider).value;
    final api = ref.watch(absApiProvider);

    if (currentUser == null || api == null) {
      return const SocialConnectionState.empty();
    }

    return _fetchInitialState();
  }

  Future<SocialConnectionState> _fetchInitialState() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return const SocialConnectionState.empty();
    }

    final supportsSocial =
        (await api.getMeApi().getStatus()).data?.compatibility.contains(socialWebsocketCompatibilityFlag) ?? false;

    if (!supportsSocial) {
      return SocialConnectionState(
        consents: const UserMessageConsents(),
        serverSupportsSocial: false,
        accessDenied: false,
      );
    }

    try {
      final consentsResponse = await api.getMeApi().getUserMessageConsents();
      return SocialConnectionState(
        consents: consentsResponse.data ?? const UserMessageConsents(),
        serverSupportsSocial: true,
        accessDenied: false,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 403) {
        logger(
          'User message consents are not accessible for the current account.',
          tag: 'UserMessageConsentsProvider',
          level: InfoLevel.warning,
        );
        return SocialConnectionState(
          consents: const UserMessageConsents(),
          serverSupportsSocial: true,
          accessDenied: true,
        );
      }

      logger(
        'Failed to fetch user message consents: $error\n$stackTrace',
        tag: 'UserMessageConsentsProvider',
        level: InfoLevel.error,
      );
      rethrow;
    }
  }

  Future<void> refresh({bool withLoading = false}) async {
    final previousData = state.value;

    if (withLoading) {
      state = const AsyncLoading();
    }

    final nextState = await AsyncValue.guard(_fetchInitialState);
    if (!ref.mounted) {
      return;
    }

    if (nextState.hasError && previousData != null) {
      state = AsyncData(previousData);
      return;
    }

    state = nextState;
  }

  Future<void> addConsent(String userId) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('ABS API is unavailable.');
    }

    await _runMutation(userId, () => api.getMeApi().addUserMessageConsent(userId));
  }

  Future<void> removeConsent(String userId) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('ABS API is unavailable.');
    }

    await _runMutation(userId, () => api.getMeApi().removeUserMessageConsent(userId));
  }

  Future<void> blockUser(String userId) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('ABS API is unavailable.');
    }

    await _runMutation(userId, () => api.getMeApi().blockUserMessageConsent(userId));
  }

  Future<void> unblockUser(String userId) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('ABS API is unavailable.');
    }

    await _runMutation(userId, () => api.getMeApi().unblockUserMessageConsent(userId));
  }

  Future<void> _runMutation(String userId, Future<Response<UserMessageConsents>> Function() action) async {
    final currentState = state.value;
    if (currentState == null || !currentState.serverSupportsSocial || currentState.accessDenied) {
      return;
    }

    if (currentState.busyUserIds.contains(userId)) {
      return;
    }

    final busyUserIds = <String>{...currentState.busyUserIds, userId};
    state = AsyncData(currentState.copyWith(busyUserIds: busyUserIds));

    try {
      final response = await action();
      if (!ref.mounted) {
        return;
      }

      final nextBusyUserIds = <String>{...busyUserIds}..remove(userId);
      state = AsyncData(
        currentState.copyWith(consents: response.data ?? currentState.consents, busyUserIds: nextBusyUserIds),
      );
    } on DioException catch (error, stackTrace) {
      logger(
        'Social consent mutation failed for $userId: $error\n$stackTrace',
        tag: 'UserMessageConsentsProvider',
        level: InfoLevel.warning,
      );

      if (!ref.mounted) {
        return;
      }

      final nextBusyUserIds = <String>{...busyUserIds}..remove(userId);
      final isForbidden = error.response?.statusCode == 403;
      state = AsyncData(currentState.copyWith(busyUserIds: nextBusyUserIds, accessDenied: isForbidden));
      rethrow;
    } catch (error, stackTrace) {
      logger(
        'Unexpected social consent mutation failure for $userId: $error\n$stackTrace',
        tag: 'UserMessageConsentsProvider',
        level: InfoLevel.warning,
      );

      if (!ref.mounted) {
        return;
      }

      final nextBusyUserIds = <String>{...busyUserIds}..remove(userId);
      state = AsyncData(currentState.copyWith(busyUserIds: nextBusyUserIds));
      rethrow;
    }
  }
}
