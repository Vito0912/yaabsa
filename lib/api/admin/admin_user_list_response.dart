import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_user.dart';

part 'admin_user_list_response.freezed.dart';
part 'admin_user_list_response.g.dart';

@freezed
abstract class AdminUserListResponse with _$AdminUserListResponse {
  const factory AdminUserListResponse({@JsonKey(name: 'users') @Default(<AdminUser>[]) List<AdminUser> users}) =
      _AdminUserListResponse;

  factory AdminUserListResponse.fromJson(Map<String, dynamic> json) => _$AdminUserListResponseFromJson(json);

  factory AdminUserListResponse.fromResponse(Object? payload) {
    if (payload is List<Object?>) {
      return AdminUserListResponse(
        users: payload
            .whereType<Map>()
            .map((entry) => Map<String, dynamic>.from(entry))
            .map(AdminUser.fromJson)
            .toList(growable: false),
      );
    }

    if (payload is Map<String, dynamic>) {
      final users = payload['users'];
      if (users is List<Object?>) {
        return AdminUserListResponse(
          users: users
              .whereType<Map>()
              .map((entry) => Map<String, dynamic>.from(entry))
              .map(AdminUser.fromJson)
              .toList(growable: false),
        );
      }
      return AdminUserListResponse.fromJson(payload);
    }

    return const AdminUserListResponse();
  }
}
