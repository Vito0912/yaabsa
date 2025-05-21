import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_session_request.freezed.dart';
part 'sync_session_request.g.dart';

@freezed
abstract class SyncSessionRequest with _$SyncSessionRequest {
  const factory SyncSessionRequest({
    @JsonKey(name: "currentTime") required double currentTime,
    @JsonKey(name: "timeListened") required double timeListened,
    @JsonKey(name: "duration") required double duration,
  }) = _SyncSessionRequest;

  factory SyncSessionRequest.fromJson(Map<String, dynamic> json) => _$SyncSessionRequestFromJson(json);
}