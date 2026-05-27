import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_backup.dart';

part 'admin_backup_list_response.freezed.dart';
part 'admin_backup_list_response.g.dart';

@freezed
abstract class AdminBackupListResponse with _$AdminBackupListResponse {
  const factory AdminBackupListResponse({
    @JsonKey(name: 'backups') @Default(<AdminBackup>[]) List<AdminBackup> backups,
  }) = _AdminBackupListResponse;

  factory AdminBackupListResponse.fromJson(Map<String, dynamic> json) => _$AdminBackupListResponseFromJson(json);
}
