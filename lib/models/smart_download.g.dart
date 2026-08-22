// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SmartDownloadPolicy _$SmartDownloadPolicyFromJson(Map<String, dynamic> json) => _SmartDownloadPolicy(
  targetCount: (json['targetCount'] as num?)?.toInt() ?? 3,
  maxAgeDays: (json['maxAgeDays'] as num?)?.toInt(),
  maxStorageBytes: (json['maxStorageBytes'] as num?)?.toInt(),
  deleteAfterHours: (json['deleteAfterHours'] as num?)?.toInt() ?? 24,
  downloadType: json['downloadType'] as String? ?? 'audiobook',
  descending: json['descending'] as bool? ?? true,
);

Map<String, dynamic> _$SmartDownloadPolicyToJson(_SmartDownloadPolicy instance) => <String, dynamic>{
  'targetCount': instance.targetCount,
  'maxAgeDays': instance.maxAgeDays,
  'maxStorageBytes': instance.maxStorageBytes,
  'deleteAfterHours': instance.deleteAfterHours,
  'downloadType': instance.downloadType,
  'descending': instance.descending,
};

_SmartDownloadProfile _$SmartDownloadProfileFromJson(Map<String, dynamic> json) => _SmartDownloadProfile(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  enabled: json['enabled'] as bool? ?? true,
  policy: json['policy'] == null
      ? const SmartDownloadPolicy()
      : SmartDownloadPolicy.fromJson(json['policy'] as Map<String, dynamic>),
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map((e) => MediaSourceDescriptor.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MediaSourceDescriptor>[],
);

Map<String, dynamic> _$SmartDownloadProfileToJson(_SmartDownloadProfile instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'enabled': instance.enabled,
  'policy': instance.policy,
  'sources': instance.sources,
};

_SmartDownloadClaim _$SmartDownloadClaimFromJson(Map<String, dynamic> json) => _SmartDownloadClaim(
  profileId: json['profileId'] as String,
  ref: PlayableRef.fromJson(json['ref'] as Map<String, dynamic>),
  source: MediaSourceDescriptor.fromJson(json['source'] as Map<String, dynamic>),
  state: json['state'] as String? ?? 'planned',
  estimatedBytes: (json['estimatedBytes'] as num?)?.toInt(),
  completedAt: (json['completedAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$SmartDownloadClaimToJson(_SmartDownloadClaim instance) => <String, dynamic>{
  'profileId': instance.profileId,
  'ref': instance.ref,
  'source': instance.source,
  'state': instance.state,
  'estimatedBytes': instance.estimatedBytes,
  'completedAt': instance.completedAt,
};
