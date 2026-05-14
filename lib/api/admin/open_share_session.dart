import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/api/library_items/device_info.dart';

part 'open_share_session.freezed.dart';

List<OpenShareSession> openShareSessionsFromDynamic(dynamic value) {
  if (value is! List) {
    throw const FormatException('Expected shareSessions to be a JSON list');
  }

  return value
      .asMap()
      .entries
      .map((entry) {
        final rawSession = entry.value;
        if (rawSession is Map<String, dynamic>) {
          return OpenShareSession.fromJson(rawSession);
        }

        if (rawSession is Map) {
          return OpenShareSession.fromJson(Map<String, dynamic>.from(rawSession));
        }

        throw FormatException('Share session at index ${entry.key} is not a JSON object');
      })
      .toList(growable: false);
}

@freezed
abstract class OpenShareSession with _$OpenShareSession {
  const factory OpenShareSession({
    required String id,
    String? userId,
    String? libraryItemId,
    String? episodeId,
    String? displayTitle,
    String? displayAuthor,
    int? playMethod,
    String? mediaPlayer,
    DeviceInfo? deviceInfo,
    double? currentTime,
    int? startedAt,
    int? updatedAt,
    SessionUserSummary? user,
  }) = _OpenShareSession;

  factory OpenShareSession.fromJson(Map<String, dynamic> json) {
    return OpenShareSession(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      libraryItemId: json['libraryItemId'] as String?,
      episodeId: json['episodeId'] as String?,
      displayTitle: json['displayTitle'] as String?,
      displayAuthor: json['displayAuthor'] as String?,
      playMethod: json['playMethod'] as int?,
      mediaPlayer: json['mediaPlayer'] as String?,
      deviceInfo: json['deviceInfo'] == null
          ? null
          : DeviceInfo.fromJson(Map<String, dynamic>.from(json['deviceInfo'] as Map)),
      currentTime: (json['currentTime'] as num?)?.toDouble(),
      startedAt: json['startedAt'] as int?,
      updatedAt: json['updatedAt'] as int?,
      user: sessionUserSummaryFromDynamic(json['user']),
    );
  }
}
