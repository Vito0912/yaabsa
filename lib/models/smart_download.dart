import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/models/queue_source.dart';

export 'package:yaabsa/models/queue_source.dart' show ListeningDownloadTrigger;

part 'smart_download.freezed.dart';
part 'smart_download.g.dart';

const legacyContinueDownloadProfileId = '__continue_shelf__';

String migratedContinueDownloadProfileId(String userId) => 'continue_shelves_$userId';

String normalizeSmartDownloadProfileId(String profileId, String userId) {
  if (profileId == legacyContinueDownloadProfileId) {
    return migratedContinueDownloadProfileId(userId);
  }

  return profileId;
}

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
