import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';

part 'admin_api_key.freezed.dart';
part 'admin_api_key.g.dart';

@freezed
abstract class AdminApiKey with _$AdminApiKey {
  const AdminApiKey._();

  const factory AdminApiKey({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'expiresAt') DateTime? expiresAt,
    @JsonKey(name: 'lastUsedAt') DateTime? lastUsedAt,
    @JsonKey(name: 'isActive') @Default(false) bool isActive,
    @JsonKey(name: 'permissions') @Default(AdminUserPermissions()) AdminUserPermissions permissions,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'createdByUserId') String? createdByUserId,
    @JsonKey(name: 'user') SessionUserSummary? user,
    @JsonKey(name: 'createdByUser') SessionUserSummary? createdByUser,
    @JsonKey(name: 'apiKey') String? apiKey,
  }) = _AdminApiKey;

  factory AdminApiKey.fromJson(Map<String, dynamic> json) => _$AdminApiKeyFromJson(json);

  bool get isExpired {
    final value = expiresAt;
    if (value == null) {
      return false;
    }

    return value.isBefore(DateTime.now());
  }
}
