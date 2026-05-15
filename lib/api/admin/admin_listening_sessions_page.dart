import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_listening_session.dart';

part 'admin_listening_sessions_page.freezed.dart';

@freezed
abstract class AdminListeningSessionsPage with _$AdminListeningSessionsPage {
  const factory AdminListeningSessionsPage({
    @Default(0) int total,
    @Default(0) int numPages,
    @Default(0) int page,
    @Default(0) int itemsPerPage,
    @Default(<AdminListeningSession>[]) List<AdminListeningSession> sessions,
  }) = _AdminListeningSessionsPage;

  factory AdminListeningSessionsPage.fromJson(Map<String, dynamic> json) {
    return AdminListeningSessionsPage(
      total: json['total'] as int? ?? 0,
      numPages: json['numPages'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      itemsPerPage: json['itemsPerPage'] as int? ?? 0,
      sessions: adminListeningSessionsFromDynamic(json['sessions'] ?? const <dynamic>[]),
    );
  }
}
