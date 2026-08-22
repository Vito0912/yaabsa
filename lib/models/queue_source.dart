import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_source.freezed.dart';
part 'queue_source.g.dart';

@freezed
abstract class PlayableRef with _$PlayableRef {
  const factory PlayableRef({required String itemId, String? episodeId}) = _PlayableRef;

  factory PlayableRef.fromJson(Map<String, dynamic> json) => _$PlayableRefFromJson(json);
}

enum MediaSourceType { podcast, series, playlist, collection }

@freezed
abstract class MediaSourceDescriptor with _$MediaSourceDescriptor {
  const factory MediaSourceDescriptor({
    required MediaSourceType type,
    required String sourceId,
    required String libraryId,
    String? displayName,
    @Default(false) bool descending,
    int? revision,
  }) = _MediaSourceDescriptor;

  factory MediaSourceDescriptor.fromJson(Map<String, dynamic> json) => _$MediaSourceDescriptorFromJson(json);
}

@freezed
abstract class QueueCandidate with _$QueueCandidate {
  const factory QueueCandidate({
    required PlayableRef ref,
    String? title,
    String? subtitle,
    String? author,
    int? order,
    int? addedAt,
    int? publishedAt,
    int? estimatedBytes,
    @Default(false) bool isFinished,
  }) = _QueueCandidate;

  factory QueueCandidate.fromJson(Map<String, dynamic> json) => _$QueueCandidateFromJson(json);
}

@unfreezed
abstract class CandidatePage with _$CandidatePage {
  factory CandidatePage({
    @Default(<QueueCandidate>[]) List<QueueCandidate> candidates,
    int? total,
    int? page,
    int? pageSize,
    String? nextCursor,
    int? revision,
  }) = _CandidatePage;

  factory CandidatePage.fromJson(Map<String, dynamic> json) => _$CandidatePageFromJson(json);
}

@freezed
abstract class QueueIntentEntry with _$QueueIntentEntry {
  const factory QueueIntentEntry({required PlayableRef ref, String? title, String? subtitle, String? author}) =
      _QueueIntentEntry;

  factory QueueIntentEntry.fromJson(Map<String, dynamic> json) => _$QueueIntentEntryFromJson(json);
}

@unfreezed
abstract class QueueIntentSnapshot with _$QueueIntentSnapshot {
  factory QueueIntentSnapshot({
    @Default(1) int version,
    @Default(<QueueIntentEntry>[]) List<QueueIntentEntry> manualEntries,
    MediaSourceDescriptor? source,
    PlayableRef? anchor,
    @Default(<PlayableRef>[]) List<PlayableRef> suppressed,
    int? sourceRevision,
  }) = _QueueIntentSnapshot;

  factory QueueIntentSnapshot.fromJson(Map<String, dynamic> json) => _$QueueIntentSnapshotFromJson(json);
}
