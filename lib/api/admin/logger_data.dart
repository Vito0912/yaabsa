import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/server_log_entry.dart';

part 'logger_data.freezed.dart';
part 'logger_data.g.dart';

List<ServerLogEntry> _serverLogEntriesFromJson(dynamic value) {
  if (value is! List) {
    return const <ServerLogEntry>[];
  }

  return value
      .map((entry) {
        if (entry is Map<String, dynamic>) {
          return ServerLogEntry.fromJson(entry);
        }
        if (entry is Map) {
          return ServerLogEntry.fromJson(Map<String, dynamic>.from(entry));
        }
        return null;
      })
      .whereType<ServerLogEntry>()
      .toList(growable: false);
}

@freezed
abstract class LoggerData with _$LoggerData {
  const factory LoggerData({
    @JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson)
    @Default(<ServerLogEntry>[])
    List<ServerLogEntry> currentDailyLogs,
  }) = _LoggerData;

  factory LoggerData.fromJson(Map<String, dynamic> json) => _$LoggerDataFromJson(json);
}
