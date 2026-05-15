import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_user_summary.freezed.dart';
part 'session_user_summary.g.dart';

SessionUserSummary? sessionUserSummaryFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return SessionUserSummary.fromJson(value);
  }

  if (value is Map) {
    return SessionUserSummary.fromJson(Map<String, dynamic>.from(value));
  }

  return null;
}

List<SessionUserSummary> sessionUserSummaryListFromDynamic(dynamic value) {
  if (value is! List) {
    return const <SessionUserSummary>[];
  }

  return value.map(sessionUserSummaryFromDynamic).whereType<SessionUserSummary>().toList(growable: false);
}

@freezed
abstract class SessionUserSummary with _$SessionUserSummary {
  const factory SessionUserSummary({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'username') required String username,
    @JsonKey(name: 'type') String? type,
  }) = _SessionUserSummary;

  factory SessionUserSummary.fromJson(Map<String, dynamic> json) => _$SessionUserSummaryFromJson(json);
}
