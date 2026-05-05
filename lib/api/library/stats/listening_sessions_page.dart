import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';

part 'listening_sessions_page.freezed.dart';
part 'listening_sessions_page.g.dart';

@freezed
abstract class ListeningSessionsPage with _$ListeningSessionsPage {
  const factory ListeningSessionsPage({
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'numPages') int? numPages,
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'itemsPerPage') int? itemsPerPage,
    @JsonKey(name: 'sessions') @Default(<PlaybackSession>[]) List<PlaybackSession> sessions,
  }) = _ListeningSessionsPage;

  factory ListeningSessionsPage.fromJson(Map<String, dynamic> json) => _$ListeningSessionsPageFromJson(json);
}
