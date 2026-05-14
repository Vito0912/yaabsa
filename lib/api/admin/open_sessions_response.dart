import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_listening_session.dart';
import 'package:yaabsa/api/admin/open_share_session.dart';

part 'open_sessions_response.freezed.dart';

@freezed
abstract class OpenSessionsResponse with _$OpenSessionsResponse {
  const factory OpenSessionsResponse({
    @Default(<AdminListeningSession>[]) List<AdminListeningSession> sessions,
    @Default(<OpenShareSession>[]) List<OpenShareSession> shareSessions,
  }) = _OpenSessionsResponse;

  factory OpenSessionsResponse.fromJson(Map<String, dynamic> json) {
    return OpenSessionsResponse(
      sessions: adminListeningSessionsFromDynamic(json['sessions'] ?? const <dynamic>[]),
      shareSessions: openShareSessionsFromDynamic(json['shareSessions'] ?? const <dynamic>[]),
    );
  }
}
