import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_log_entry.freezed.dart';
part 'server_log_entry.g.dart';

int _intFromDynamic(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

@freezed
abstract class ServerLogEntry with _$ServerLogEntry {
  const factory ServerLogEntry({
    @JsonKey(name: 'timestamp') required String timestamp,
    @JsonKey(name: 'source') String? source,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'levelName') required String levelName,
    @JsonKey(name: 'level', fromJson: _intFromDynamic) required int level,
  }) = _ServerLogEntry;

  factory ServerLogEntry.fromJson(Map<String, dynamic> json) => _$ServerLogEntryFromJson(json);
}
