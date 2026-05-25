import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'server_log_entry.freezed.dart';
part 'server_log_entry.g.dart';

@freezed
abstract class ServerLogEntry with _$ServerLogEntry {
  const factory ServerLogEntry({
    @JsonKey(name: 'timestamp') required String timestamp,
    @JsonKey(name: 'source') String? source,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'levelName') required String levelName,
    @JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic) required int level,
  }) = _ServerLogEntry;

  factory ServerLogEntry.fromJson(Map<String, dynamic> json) => _$ServerLogEntryFromJson(json);
}
