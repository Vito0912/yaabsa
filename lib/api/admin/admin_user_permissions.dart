import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user_permissions.freezed.dart';
part 'admin_user_permissions.g.dart';

@freezed
abstract class AdminUserPermissions with _$AdminUserPermissions {
  const factory AdminUserPermissions({
    @JsonKey(name: 'download') @Default(true) bool download,
    @JsonKey(name: 'update') @Default(false) bool update,
    @JsonKey(name: 'delete') @Default(false) bool delete,
    @JsonKey(name: 'upload') @Default(false) bool upload,
    @JsonKey(name: 'createEreader') @Default(false) bool createEreader,
    @JsonKey(name: 'accessAllLibraries') @Default(true) bool accessAllLibraries,
    @JsonKey(name: 'accessAllTags') @Default(true) bool accessAllTags,
    @JsonKey(name: 'accessExplicitContent') @Default(false) bool accessExplicitContent,
    @JsonKey(name: 'selectedTagsNotAccessible') @Default(false) bool selectedTagsNotAccessible,
    @JsonKey(name: 'librariesAccessible') @Default(<String>[]) List<String> librariesAccessible,
    @JsonKey(name: 'itemTagsSelected') @Default(<String>[]) List<String> itemTagsSelected,
  }) = _AdminUserPermissions;

  factory AdminUserPermissions.fromJson(Map<String, dynamic> json) => _$AdminUserPermissionsFromJson(json);
}

AdminUserPermissions defaultAdminUserPermissionsForType(String? type) {
  final normalizedType = (type ?? 'user').trim().toLowerCase();
  final isAdminOrUp = normalizedType == 'admin' || normalizedType == 'root';
  final isRoot = normalizedType == 'root';

  return AdminUserPermissions(
    download: true,
    update: isAdminOrUp,
    delete: isRoot,
    upload: isAdminOrUp,
    createEreader: isAdminOrUp,
    accessAllLibraries: true,
    accessAllTags: true,
    accessExplicitContent: isAdminOrUp,
    selectedTagsNotAccessible: false,
    librariesAccessible: const <String>[],
    itemTagsSelected: const <String>[],
  );
}
