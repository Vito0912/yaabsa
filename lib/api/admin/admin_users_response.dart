import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';

part 'admin_users_response.freezed.dart';

@freezed
abstract class AdminUsersResponse with _$AdminUsersResponse {
  const factory AdminUsersResponse({@Default(<SessionUserSummary>[]) List<SessionUserSummary> users}) =
      _AdminUsersResponse;

  factory AdminUsersResponse.fromDynamic(dynamic data) {
    if (data is List) {
      return AdminUsersResponse(users: sessionUserSummaryListFromDynamic(data));
    }

    if (data is Map<String, dynamic>) {
      return AdminUsersResponse(users: sessionUserSummaryListFromDynamic(data['users'] ?? data['data']));
    }

    if (data is Map) {
      final parsedMap = Map<String, dynamic>.from(data);
      return AdminUsersResponse(users: sessionUserSummaryListFromDynamic(parsedMap['users'] ?? parsedMap['data']));
    }

    return const AdminUsersResponse();
  }
}
