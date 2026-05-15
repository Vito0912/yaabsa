import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';

part 'admin_user_upsert_request.freezed.dart';
part 'admin_user_upsert_request.g.dart';

@freezed
abstract class AdminUserUpsertRequest with _$AdminUserUpsertRequest {
  const factory AdminUserUpsertRequest({
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'password') String? password,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'type') @Default('user') String type,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    @JsonKey(name: 'permissions') @Default(AdminUserPermissions()) AdminUserPermissions permissions,
    @JsonKey(name: 'librariesAccessible') @Default(<String>[]) List<String> librariesAccessible,
    @JsonKey(name: 'itemTagsSelected') @Default(<String>[]) List<String> itemTagsSelected,
  }) = _AdminUserUpsertRequest;

  factory AdminUserUpsertRequest.fromJson(Map<String, dynamic> json) => _$AdminUserUpsertRequestFromJson(json);

  factory AdminUserUpsertRequest.fromUser(AdminUser user) {
    return AdminUserUpsertRequest(
      username: user.username,
      email: user.email,
      type: user.type,
      isActive: user.isActive,
      permissions: user.permissions,
      librariesAccessible: user.effectiveLibrariesAccessible,
      itemTagsSelected: user.effectiveItemTagsSelected,
    );
  }
}
