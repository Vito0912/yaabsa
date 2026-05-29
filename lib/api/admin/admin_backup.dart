import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_backup.freezed.dart';
part 'admin_backup.g.dart';

@freezed
abstract class AdminBackup with _$AdminBackup {
  const AdminBackup._();

  const factory AdminBackup({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'key') String? key,
    @JsonKey(name: 'backupDirPath') String? backupDirPath,
    @JsonKey(name: 'datePretty') String? datePretty,
    @JsonKey(name: 'fullPath') String? fullPath,
    @JsonKey(name: 'path') String? path,
    @JsonKey(name: 'filename') String? filename,
    @JsonKey(name: 'fileSize') int? fileSize,
    @JsonKey(name: 'createdAt') int? createdAt,
    @JsonKey(name: 'serverVersion') String? serverVersion,
  }) = _AdminBackup;

  factory AdminBackup.fromJson(Map<String, dynamic> json) => _$AdminBackupFromJson(json);

  bool get canRestore {
    final hasKey = (key ?? '').trim().isNotEmpty;
    final hasServerVersion = (serverVersion ?? '').trim().isNotEmpty;
    return hasKey && hasServerVersion;
  }

  DateTime? get createdDateTime {
    final value = createdAt;
    if (value == null || value <= 0) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(value);
  }
}
