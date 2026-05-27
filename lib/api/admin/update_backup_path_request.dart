import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_backup_path_request.freezed.dart';
part 'update_backup_path_request.g.dart';

@freezed
abstract class UpdateBackupPathRequest with _$UpdateBackupPathRequest {
  const factory UpdateBackupPathRequest({@JsonKey(name: 'path') required String path}) = _UpdateBackupPathRequest;

  factory UpdateBackupPathRequest.fromJson(Map<String, dynamic> json) => _$UpdateBackupPathRequestFromJson(json);
}
