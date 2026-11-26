import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:yaabsa/api/library/stats/listening_sessions_page.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

const int _sessionsPageSize = 200;

class LongListeningSessionsScanResult {
  const LongListeningSessionsScanResult({required this.sessions, required this.totalHours, required this.usersScanned});

  final List<PlaybackSession> sessions;
  final double totalHours;
  final int usersScanned;
}

class DeleteLongListeningSessionsResult {
  const DeleteLongListeningSessionsResult({
    required this.deletedCount,
    required this.failedCount,
    required this.deletedHours,
  });

  final int deletedCount;
  final int failedCount;
  final double deletedHours;
}

Future<LongListeningSessionsScanResult> findLongListeningSessions({
  required ABSApi api,
  required User currentUser,
  required double thresholdHours,
  required bool includeAllUsers,
  int maxSessionsPerUser = 5000,
}) async {
  if (!thresholdHours.isFinite || thresholdHours < 0) {
    throw ArgumentError('Threshold hours must be a non-negative number.');
  }
  if (maxSessionsPerUser <= 0) {
    throw ArgumentError('maxSessionsPerUser must be greater than zero.');
  }

  final isAdmin = currentUser.type == 'admin' || currentUser.type == 'root';
  final scanAllUsers = includeAllUsers && isAdmin;

  final matchingSessions = <PlaybackSession>[];
  var totalHours = 0.0;
  var usersScanned = 0;

  if (scanAllUsers) {
    final usersResponse = await api.getAdminApi().getUsers();
    final users = usersResponse.data?.users ?? const [];
    final targetUserIds = users.isEmpty
        ? <String>[currentUser.id]
        : users.map((user) => user.id).where((id) => id.trim().isNotEmpty).toList(growable: false);

    for (final userId in targetUserIds) {
      usersScanned += 1;
      final userSessions = await _fetchUserSessions(
        api: api,
        userId: userId,
        useMeEndpointFirst: userId == currentUser.id,
        maxSessions: maxSessionsPerUser,
      );

      for (final session in userSessions) {
        final seconds = session.timeListening;
        if (seconds == null || seconds <= 0) {
          continue;
        }

        final hours = seconds / 3600.0;
        if (hours > thresholdHours) {
          matchingSessions.add(session);
          totalHours += hours;
        }
      }
    }
  } else {
    usersScanned = 1;
    final userSessions = await _fetchUserSessions(
      api: api,
      userId: currentUser.id,
      useMeEndpointFirst: true,
      maxSessions: maxSessionsPerUser,
    );

    for (final session in userSessions) {
      final seconds = session.timeListening;
      if (seconds == null || seconds <= 0) {
        continue;
      }

      final hours = seconds / 3600.0;
      if (hours > thresholdHours) {
        matchingSessions.add(session);
        totalHours += hours;
      }
    }
  }

  matchingSessions.sort((first, second) {
    final firstTime = first.timeListening ?? 0;
    final secondTime = second.timeListening ?? 0;
    return secondTime.compareTo(firstTime);
  });

  return LongListeningSessionsScanResult(
    sessions: matchingSessions,
    totalHours: totalHours,
    usersScanned: usersScanned,
  );
}

Future<DeleteLongListeningSessionsResult> deleteLongListeningSessions({
  required ABSApi api,
  required List<PlaybackSession> sessions,
  void Function(int processed, int total)? onProgress,
}) async {
  var deletedCount = 0;
  var failedCount = 0;
  var deletedHours = 0.0;

  for (var index = 0; index < sessions.length; index++) {
    final session = sessions[index];
    try {
      final deleted = await api.getSessionApi().deleteSessionById(session.id);
      if (deleted) {
        deletedCount += 1;
        deletedHours += (session.timeListening ?? 0) / 3600.0;
      } else {
        failedCount += 1;
      }
    } catch (_) {
      failedCount += 1;
    }

    onProgress?.call(index + 1, sessions.length);
  }

  return DeleteLongListeningSessionsResult(
    deletedCount: deletedCount,
    failedCount: failedCount,
    deletedHours: deletedHours,
  );
}

Future<List<PlaybackSession>> _fetchUserSessions({
  required ABSApi api,
  required String userId,
  required bool useMeEndpointFirst,
  required int maxSessions,
}) async {
  final sessions = <PlaybackSession>[];
  var page = 0;

  while (sessions.length < maxSessions) {
    final remaining = maxSessions - sessions.length;
    final itemsPerPage = math.min(_sessionsPageSize, remaining);
    final pageData = await _loadSessionPage(
      api: api,
      userId: userId,
      useMeEndpointFirst: useMeEndpointFirst,
      page: page,
      itemsPerPage: itemsPerPage,
    );

    if (pageData.sessions.isEmpty) {
      break;
    }

    sessions.addAll(pageData.sessions);

    final total = pageData.total;
    final numPages = pageData.numPages;
    if (total != null && sessions.length >= total) {
      break;
    }
    if (numPages != null && page + 1 >= numPages) {
      break;
    }
    if (pageData.sessions.length < itemsPerPage) {
      break;
    }

    page += 1;
  }

  return sessions;
}

Future<ListeningSessionsPage> _loadSessionPage({
  required ABSApi api,
  required String userId,
  required bool useMeEndpointFirst,
  required int page,
  required int itemsPerPage,
}) async {
  const extra = <String, dynamic>{'doNotCache': true};

  if (useMeEndpointFirst) {
    try {
      final response = await api.getMeApi().getMeListeningSessions(
        page: page,
        itemsPerPage: itemsPerPage,
        extra: extra,
      );
      return response.data ?? const ListeningSessionsPage();
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != 404 && statusCode != 405) {
        rethrow;
      }
    }
  }

  final fallbackResponse = await api.getMeApi().getUserListeningSessions(
    userId,
    page: page,
    itemsPerPage: itemsPerPage,
    extra: extra,
  );
  return fallbackResponse.data ?? const ListeningSessionsPage();
}
