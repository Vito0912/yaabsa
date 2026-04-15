import 'package:freezed_annotation/freezed_annotation.dart';

part 'status.freezed.dart';
part 'status.g.dart';

@freezed
abstract class ServerStatus with _$ServerStatus {
  const factory ServerStatus({
    @JsonKey(name: 'app') required String app,
    @JsonKey(name: 'serverVersion') required String serverVersion,
    @JsonKey(name: 'isInit') required bool isInit,
    @JsonKey(name: 'language') required String language,
    @JsonKey(name: 'authMethods') @Default(<String>[]) List<String> authMethods,
    @JsonKey(name: 'authFormData') AuthFormData? authFormData,
    @JsonKey(name: 'ConfigPath') String? configPath,
    @JsonKey(name: 'MetadataPath') String? metadataPath,
  }) = _ServerStatus;

  factory ServerStatus.fromJson(Map<String, dynamic> json) => _$ServerStatusFromJson(json);
}

@freezed
abstract class AuthFormData with _$AuthFormData {
  const factory AuthFormData({
    @JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,
    @JsonKey(name: 'authOpenIDButtonText') String? authOpenIDButtonText,
    @JsonKey(name: 'authOpenIDAutoLaunch') bool? authOpenIDAutoLaunch,
  }) = _AuthFormData;

  factory AuthFormData.fromJson(Map<String, dynamic> json) => _$AuthFormDataFromJson(json);
}
