import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_backup.dart';

part 'admin_backups_response.freezed.dart';
part 'admin_backups_response.g.dart';

@freezed
abstract class AdminBackupsResponse with _$AdminBackupsResponse {
  const factory AdminBackupsResponse({
    @JsonKey(name: 'backups') @Default(<AdminBackup>[]) List<AdminBackup> backups,
    @JsonKey(name: 'backupLocation') String? backupLocation,
    @JsonKey(name: 'backupPathEnvSet') @Default(false) bool backupPathEnvSet,
  }) = _AdminBackupsResponse;

  factory AdminBackupsResponse.fromJson(Map<String, dynamic> json) => _$AdminBackupsResponseFromJson(json);
}
