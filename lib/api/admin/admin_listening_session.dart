import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';

part 'admin_listening_session.freezed.dart';

List<AdminListeningSession> adminListeningSessionsFromDynamic(dynamic value) {
  if (value is! List) {
    throw const FormatException('Expected sessions to be a JSON list');
  }

  return value
      .asMap()
      .entries
      .map((entry) {
        final rawSession = entry.value;
        if (rawSession is Map<String, dynamic>) {
          return AdminListeningSession.fromJson(rawSession);
        }
        if (rawSession is Map) {
          return AdminListeningSession.fromJson(Map<String, dynamic>.from(rawSession));
        }
        throw FormatException('Session at index ${entry.key} is not a JSON object');
      })
      .toList(growable: false);
}

@freezed
abstract class AdminListeningSession with _$AdminListeningSession {
  const AdminListeningSession._();

  const factory AdminListeningSession({required PlaybackSession session, SessionUserSummary? user}) =
      _AdminListeningSession;

  factory AdminListeningSession.fromJson(Map<String, dynamic> json) {
    final payload = Map<String, dynamic>.from(json);
    payload['id'] = payload['id'] as String? ?? '';
    payload['userId'] = payload['userId'] as String? ?? '';
    payload['libraryItemId'] = payload['libraryItemId'] as String? ?? '';

    return AdminListeningSession(
      session: PlaybackSession.fromJson(payload),
      user: sessionUserSummaryFromDynamic(json['user']),
    );
  }
}
