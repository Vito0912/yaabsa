import 'package:buchshelfly/api/me/permissions.dart';
import 'package:buchshelfly/api/me/server.dart';
import 'package:buchshelfly/api/me/server_settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'bookmark.dart';
import 'media_progress.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@unfreezed
abstract class User with _$User {
  factory User({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "username") required String username,
    @JsonKey(name: "email") required dynamic email,
    @JsonKey(name: "type") required String type,
    @JsonKey(name: "token") required String? token,
    @JsonKey(name: "mediaProgress") List<MediaProgress>? mediaProgress,
    @JsonKey(name: "seriesHideFromContinueListening")
    List<String>? seriesHideFromContinueListening,
    @JsonKey(name: "bookmarks") List<Bookmark>? bookmarks,
    @JsonKey(name: "isActive") bool? isActive,
    @JsonKey(name: "isLocked") bool? isLocked,
    @JsonKey(name: "lastSeen") int? lastSeen,
    @JsonKey(name: "createdAt") int? createdAt,
    @JsonKey(name: "permissions") required Permissions permissions,
    @JsonKey(name: "librariesAccessible") List<String>? librariesAccessible,
    @JsonKey(name: "itemTagsSelected") List<String>? itemTagsSelected,
    @JsonKey(name: "hasOpenIDLink") bool? hasOpenIdLink,
    ServerSettings? setting,
    Server? server,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
