import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/models/queue_source.dart';

part 'smart_download.freezed.dart';
part 'smart_download.g.dart';

@freezed
abstract class SmartDownloadPolicy with _$SmartDownloadPolicy {
  const factory SmartDownloadPolicy({
    @Default(3) int targetCount,
    int? maxAgeDays,
    int? maxStorageBytes,
    @Default(24) int deleteAfterHours,
    @Default('audiobook') String downloadType,
    @Default(true) bool descending,
  }) = _SmartDownloadPolicy;

  factory SmartDownloadPolicy.fromJson(Map<String, dynamic> json) => _$SmartDownloadPolicyFromJson(json);
}

@unfreezed
abstract class SmartDownloadProfile with _$SmartDownloadProfile {
  factory SmartDownloadProfile({
    required String id,
    required String userId,
    required String name,
    @Default(true) bool enabled,
    @Default(SmartDownloadPolicy()) SmartDownloadPolicy policy,
    @Default(<MediaSourceDescriptor>[]) List<MediaSourceDescriptor> sources,
  }) = _SmartDownloadProfile;

  factory SmartDownloadProfile.fromJson(Map<String, dynamic> json) => _$SmartDownloadProfileFromJson(json);
}

@freezed
abstract class SmartDownloadClaim with _$SmartDownloadClaim {
  const factory SmartDownloadClaim({
    required String profileId,
    required PlayableRef ref,
    required MediaSourceDescriptor source,
    @Default('planned') String state,
    int? estimatedBytes,
    int? completedAt,
  }) = _SmartDownloadClaim;

  factory SmartDownloadClaim.fromJson(Map<String, dynamic> json) => _$SmartDownloadClaimFromJson(json);
}
