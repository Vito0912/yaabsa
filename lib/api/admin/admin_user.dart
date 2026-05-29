import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';

part 'admin_user.freezed.dart';
part 'admin_user.g.dart';

@freezed
abstract class AdminUser with _$AdminUser {
  const AdminUser._();

  const factory AdminUser({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'type') @Default('user') String type,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
    @JsonKey(name: 'isLocked') bool? isLocked,
    @JsonKey(name: 'lastSeen') int? lastSeen,
    @JsonKey(name: 'createdAt') int? createdAt,
    @JsonKey(name: 'hasOpenIDLink') bool? hasOpenIdLink,
    @JsonKey(name: 'permissions') @Default(AdminUserPermissions()) AdminUserPermissions permissions,
    @JsonKey(name: 'librariesAccessible') @Default(<String>[]) List<String> librariesAccessible,
    @JsonKey(name: 'itemTagsSelected') @Default(<String>[]) List<String> itemTagsSelected,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

  static AdminUser? fromApiResponse(Object? payload) {
    if (payload is Map<String, dynamic>) {
      final rawUser = payload['user'] ?? payload['data'] ?? payload;
      if (rawUser is Map<String, dynamic>) {
        return AdminUser.fromJson(rawUser);
      }
      if (rawUser is Map) {
        return AdminUser.fromJson(Map<String, dynamic>.from(rawUser));
      }
      return null;
    }

    if (payload is Map) {
      return AdminUser.fromApiResponse(Map<String, dynamic>.from(payload));
    }

    return null;
  }

  bool get isRoot => type.trim().toLowerCase() == 'root';

  bool get isAdminOrUp {
    final normalizedType = type.trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  bool get hasLinkedOpenId => hasOpenIdLink ?? false;

  List<String> get effectiveLibrariesAccessible {
    if (librariesAccessible.isNotEmpty) {
      return librariesAccessible;
    }
    return permissions.librariesAccessible;
  }

  List<String> get effectiveItemTagsSelected {
    if (itemTagsSelected.isNotEmpty) {
      return itemTagsSelected;
    }
    return permissions.itemTagsSelected;
  }
}
