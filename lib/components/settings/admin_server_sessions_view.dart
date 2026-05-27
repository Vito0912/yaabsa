import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_listening_session.dart';
import 'package:yaabsa/api/admin/open_share_session.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/sessions/listening_session_editor_dialog.dart';
import 'package:yaabsa/components/sessions/listening_session_list.dart';
import 'package:yaabsa/components/sessions/listening_sessions_pagination_controls.dart';
import 'package:yaabsa/components/sessions/open_share_session_dialog.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/logger.dart';

class AdminServerSessionsView extends ConsumerStatefulWidget {
  const AdminServerSessionsView({super.key});

  @override
  ConsumerState<AdminServerSessionsView> createState() => _AdminServerSessionsViewState();
}

class _AdminServerSessionsViewState extends ConsumerState<AdminServerSessionsView> {
  static const int _defaultItemsPerPage = 10;
  static const List<int> _pageSizeOptions = <int>[10, 20, 50, 100];

  final Map<String, String> _librarySessionUsers = <String, String>{};
  final Map<String, String> _openSessionUsers = <String, String>{};

  String? _activeUserId;
  String? _selectedFilterUserId;

  bool _isLoadingUsers = true;
  bool _isLoadingLibrarySessions = true;
  bool _isLoadingOpenSessions = true;
  bool _isBulkDeleting = false;

  String? _errorMessage;

  int _currentPage = 0;
  int _numPages = 1;
  int _totalSessions = 0;
  int _itemsPerPage = _defaultItemsPerPage;

  final Set<String> _selectedLibrarySessionIds = <String>{};

  List<SessionUserSummary> _availableUsers = <SessionUserSummary>[];
  List<AdminListeningSession> _librarySessions = <AdminListeningSession>[];
  List<AdminListeningSession> _openSessions = <AdminListeningSession>[];
  List<OpenShareSession> _shareSessions = <OpenShareSession>[];

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  ABSApi? _api() {
    return ref.read(absApiProvider);
  }

  Future<void> _loadAllData({bool resetPage = false}) async {
    if (resetPage) {
      setState(() {
        _currentPage = 0;
      });
    }

    await Future.wait<void>([_loadUsers(), _loadLibrarySessions(), _loadOpenSessions()]);
  }

  Future<void> _loadUsers() async {
    final api = _api();
    if (api == null) {
      setState(() {
        _isLoadingUsers = false;
      });
      return;
    }

    setState(() {
      _isLoadingUsers = true;
    });

    try {
      final response = await api.getAdminApi().getUsers();
      final users = List<SessionUserSummary>.from(response.data?.users ?? const <SessionUserSummary>[])
        ..sort((a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()));

      if (!mounted) {
        return;
      }

      final selectedFilterExists = users.any((entry) => entry.id == _selectedFilterUserId);
      setState(() {
        _availableUsers = users;
        if (!selectedFilterExists) {
          _selectedFilterUserId = null;
        }
      });
    } catch (error, stackTrace) {
      logger('Failed to load admin users: $error\n$stackTrace', tag: 'AdminServerSessionsView', level: InfoLevel.error);
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load users: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUsers = false;
        });
      }
    }
  }

  Future<void> _loadLibrarySessions() async {
    final api = _api();
    if (api == null) {
      setState(() {
        _isLoadingLibrarySessions = false;
      });
      return;
    }

    setState(() {
      _isLoadingLibrarySessions = true;
    });

    try {
      final response = await api.getSessionApi().getSessions(
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
        sortBy: 'updatedAt',
        desc: true,
        userId: _selectedFilterUserId,
      );

      final data = response.data;
      final sessions = List<AdminListeningSession>.from(data?.sessions ?? const <AdminListeningSession>[]);
      final userMap = <String, String>{
        for (final entry in sessions)
          if (entry.user != null && entry.user!.username.trim().isNotEmpty) entry.session.id: entry.user!.username,
      };

      if (!mounted) {
        return;
      }

      setState(() {
        _librarySessions = sessions;
        _selectedLibrarySessionIds.removeWhere(
          (sessionId) => !_librarySessions.any((entry) => entry.session.id == sessionId),
        );
        _librarySessionUsers
          ..clear()
          ..addAll(userMap);
        _totalSessions = data?.total ?? sessions.length;
        _numPages = (data?.numPages ?? 1) <= 0 ? 1 : data!.numPages;
        _currentPage = data?.page ?? _currentPage;
      });
    } catch (error, stackTrace) {
      logger(
        'Failed to load admin listening sessions: $error\n$stackTrace',
        tag: 'AdminServerSessionsView',
        level: InfoLevel.error,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load listening sessions: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLibrarySessions = false;
        });
      }
    }
  }

  Future<void> _loadOpenSessions() async {
    final api = _api();
    if (api == null) {
      setState(() {
        _isLoadingOpenSessions = false;
      });
      return;
    }

    setState(() {
      _isLoadingOpenSessions = true;
    });

    try {
      final response = await api.getSessionApi().getOpenSessions();
      final data = response.data;

      final openSessions = List<AdminListeningSession>.from(data?.sessions ?? const <AdminListeningSession>[]);
      final openSessionUsers = <String, String>{
        for (final entry in openSessions)
          if (entry.user != null && entry.user!.username.trim().isNotEmpty) entry.session.id: entry.user!.username,
      };

      if (!mounted) {
        return;
      }

      setState(() {
        _openSessions = openSessions;
        _openSessionUsers
          ..clear()
          ..addAll(openSessionUsers);
        _shareSessions = List<OpenShareSession>.from(data?.shareSessions ?? const <OpenShareSession>[]);
      });
    } catch (error, stackTrace) {
      logger(
        'Failed to load open/shared sessions: $error\n$stackTrace',
        tag: 'AdminServerSessionsView',
        level: InfoLevel.error,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load open sessions: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingOpenSessions = false;
        });
      }
    }
  }

  Future<void> _changeFilterUser(String? userId) async {
    setState(() {
      _selectedFilterUserId = userId;
      _currentPage = 0;
      _errorMessage = null;
      _selectedLibrarySessionIds.clear();
    });

    await _loadLibrarySessions();
  }

  Future<void> _changeItemsPerPage(int itemsPerPage) async {
    if (itemsPerPage == _itemsPerPage) {
      return;
    }

    setState(() {
      _itemsPerPage = itemsPerPage;
      _currentPage = 0;
      _errorMessage = null;
      _selectedLibrarySessionIds.clear();
    });

    await _loadLibrarySessions();
  }

  Future<void> _goToPreviousPage() async {
    if (_currentPage <= 0 || _isLoadingLibrarySessions) {
      return;
    }

    setState(() {
      _currentPage -= 1;
      _errorMessage = null;
    });
    await _loadLibrarySessions();
  }

  Future<void> _goToNextPage() async {
    final lastPage = _numPages <= 0 ? 0 : _numPages - 1;
    if (_currentPage >= lastPage || _isLoadingLibrarySessions) {
      return;
    }

    setState(() {
      _currentPage += 1;
      _errorMessage = null;
    });
    await _loadLibrarySessions();
  }

  void _onLibrarySessionSelectionChanged(PlaybackSession session, bool selected) {
    setState(() {
      if (selected) {
        _selectedLibrarySessionIds.add(session.id);
      } else {
        _selectedLibrarySessionIds.remove(session.id);
      }
    });
  }

  bool _canDeleteSelectedLibrarySessions(bool canDelete) {
    return canDelete && _selectedLibrarySessionIds.isNotEmpty;
  }

  Future<void> _bulkDeleteSelectedLibrarySessions({required bool canDelete}) async {
    final api = _api();
    if (api == null || _isBulkDeleting || !_canDeleteSelectedLibrarySessions(canDelete)) {
      return;
    }

    final selectedSessions = _librarySessions
        .where((entry) => _selectedLibrarySessionIds.contains(entry.session.id))
        .map((entry) => entry.session)
        .toList(growable: false);

    if (selectedSessions.isEmpty) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Selected Sessions'),
          content: Text('Delete ${selectedSessions.length} selected session(s)? This cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _isBulkDeleting = true;
      _errorMessage = null;
    });

    var deletedCount = 0;
    final failedSessionIds = <String>[];

    for (final session in selectedSessions) {
      try {
        final deleted = await api.getSessionApi().deleteSessionById(session.id);
        if (deleted) {
          deletedCount += 1;
        } else {
          failedSessionIds.add(session.id);
        }
      } catch (error, stackTrace) {
        logger(
          'Failed deleting admin session ${session.id}: $error\n$stackTrace',
          tag: 'AdminServerSessionsView',
          level: InfoLevel.error,
        );
        failedSessionIds.add(session.id);
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedLibrarySessionIds.clear();
      _isBulkDeleting = false;
    });

    await _loadAllData();

    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    if (deletedCount > 0) {
      messenger.showSnackBar(SnackBar(content: Text('Deleted $deletedCount session(s).')));
    }
    if (failedSessionIds.isNotEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to delete ${failedSessionIds.length} session(s). Check logs for details.')),
      );
    }
  }

  Future<void> _openPlaybackSessionDialog({
    required PlaybackSession session,
    required String? username,
    required bool canEdit,
    required bool canDelete,
  }) async {
    final api = _api();
    if (api == null) {
      return;
    }

    final changed = await showListeningSessionEditorDialog(
      context,
      session: session,
      username: username,
      canEdit: canEdit,
      canDelete: canDelete,
      onSave: canEdit
          ? (updatedSession) async {
              await api.getSessionApi().syncLocalSession(updatedSession);
              return true;
            }
          : null,
      onDelete: canDelete
          ? () async {
              return api.getSessionApi().deleteSessionById(session.id);
            }
          : null,
    );

    if (changed == true && mounted) {
      await _loadAllData();
    }
  }

  Future<void> _openShareSessionDetails(OpenShareSession shareSession, {required bool canDelete}) async {
    final api = _api();
    if (api == null) {
      return;
    }

    final changed = await showOpenShareSessionDialog(
      context,
      session: shareSession,
      canDelete: canDelete,
      onDelete: canDelete
          ? () async {
              return api.getSessionApi().deleteSessionById(shareSession.id);
            }
          : null,
    );

    if (changed == true && mounted) {
      await _loadOpenSessions();
    }
  }

  String? _usernameForLibrarySession(PlaybackSession session) {
    final username = _librarySessionUsers[session.id];
    if (username == null || username.trim().isEmpty) {
      return null;
    }

    return username;
  }

  String? _usernameForOpenSession(PlaybackSession session) {
    final username = _openSessionUsers[session.id];
    if (username == null || username.trim().isEmpty) {
      return null;
    }

    return username;
  }

  Widget _buildErrorCard() {
    if (_errorMessage == null || _errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(_errorMessage!)),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                unawaited(_loadAllData());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? trailingText}) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        if (trailingText != null && trailingText.isNotEmpty)
          Text(trailingText, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildLibrarySessionsSection({required bool canEdit, required bool canDelete}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Library Sessions'),
        const SizedBox(height: 8),
        ListeningSessionsPaginationControls(
          page: _currentPage,
          numPages: _numPages,
          total: _totalSessions,
          itemsPerPage: _itemsPerPage,
          pageSizeOptions: _pageSizeOptions,
          isLoading: _isLoadingLibrarySessions,
          onItemsPerPageChanged: (value) {
            unawaited(_changeItemsPerPage(value));
          },
          onPrevious: _currentPage > 0 ? _goToPreviousPage : null,
          onNext: _currentPage < (_numPages - 1) ? _goToNextPage : null,
        ),
        if (_isLoadingLibrarySessions)
          const Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator(minHeight: 2)),
        if (_selectedLibrarySessionIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Text('${_selectedLibrarySessionIds.length} selected'),
                const Spacer(),
                FilledButton.icon(
                  onPressed: (_isBulkDeleting || !_canDeleteSelectedLibrarySessions(canDelete))
                      ? null
                      : () {
                          unawaited(_bulkDeleteSelectedLibrarySessions(canDelete: canDelete));
                        },
                  icon: _isBulkDeleting
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.delete_outline_rounded),
                  label: const Text('Delete Selected'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListeningSessionList(
              sessions: _librarySessions.map((entry) => entry.session).toList(growable: false),
              usernameForSession: _usernameForLibrarySession,
              showSelection: true,
              selectedSessionIds: _selectedLibrarySessionIds,
              onSelectionChanged: _onLibrarySessionSelectionChanged,
              onSessionTap: (session) async {
                final canEditSession = canEdit && session.userId == _activeUserId;
                await _openPlaybackSessionDialog(
                  session: session,
                  username: _usernameForLibrarySession(session),
                  canEdit: canEditSession,
                  canDelete: canDelete,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpenSessionsSection({required bool canEdit, required bool canDelete}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Open Sessions', trailingText: '${_openSessions.length} active'),
        const SizedBox(height: 8),
        if (_isLoadingOpenSessions)
          const Padding(padding: EdgeInsets.only(bottom: 8), child: LinearProgressIndicator(minHeight: 2)),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: ListeningSessionList(
              sessions: _openSessions.map((entry) => entry.session).toList(growable: false),
              emptyMessage: 'No open sessions found.',
              usernameForSession: _usernameForOpenSession,
              onSessionTap: (session) async {
                final canEditSession = canEdit && session.userId == _activeUserId;
                await _openPlaybackSessionDialog(
                  session: session,
                  username: _usernameForOpenSession(session),
                  canEdit: canEditSession,
                  canDelete: canDelete,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareSessionsSection({required bool canDelete}) {
    final sortedSessions = List<OpenShareSession>.from(_shareSessions)
      ..sort((a, b) {
        final left = a.updatedAt ?? a.startedAt ?? 0;
        final right = b.updatedAt ?? b.startedAt ?? 0;
        return right.compareTo(left);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Shared Sessions', trailingText: '${sortedSessions.length} active'),
        const SizedBox(height: 8),
        if (_isLoadingOpenSessions)
          const Padding(padding: EdgeInsets.only(bottom: 8), child: LinearProgressIndicator(minHeight: 2)),
        Card(
          margin: EdgeInsets.zero,
          child: sortedSessions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  child: Center(child: Text('No shared sessions found.')),
                )
              : ListView.separated(
                  itemCount: sortedSessions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final session = sortedSessions[index];
                    final title = session.displayTitle?.trim();
                    final userName = session.user?.username.trim();
                    final subtitleParts = <String>[];
                    if (session.displayAuthor != null && session.displayAuthor!.trim().isNotEmpty) {
                      subtitleParts.add(session.displayAuthor!.trim());
                    }
                    if (userName != null && userName.isNotEmpty) {
                      subtitleParts.add(userName);
                    }
                    subtitleParts.add(
                      formatDateTimeLabel(
                        (session.updatedAt ?? 0) > 0
                            ? DateTime.fromMillisecondsSinceEpoch(session.updatedAt!)
                            : (session.startedAt ?? 0) > 0
                            ? DateTime.fromMillisecondsSinceEpoch(session.startedAt!)
                            : null,
                      ),
                    );

                    return ListTile(
                      dense: true,
                      title: Text(
                        (title == null || title.isEmpty) ? 'Unknown Item' : title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(subtitleParts.join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                      onTap: () async {
                        await _openShareSessionDetails(session, canDelete: canDelete);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage sessions.'),
          );
        }

        Widget centeredContent(Widget child) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 960), child: child),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('This page requires an admin account.'),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadAllData(resetPage: true));
          });
        }

        final canEdit = true;
        final canDelete = currentUser.permissions.delete;

        return RefreshIndicator(
          onRefresh: _loadAllData,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 18),
            children: [
              centeredContent(_buildErrorCard()),
              if (_errorMessage != null && _errorMessage!.isNotEmpty) centeredContent(const SizedBox(height: 10)),
              centeredContent(
                Row(
                  children: [
                    Expanded(
                      child: YaabsaExpressiveDropdownField<String?>(
                        value: _selectedFilterUserId,
                        decoration: const InputDecoration(labelText: 'Filter by User', border: OutlineInputBorder()),
                        options: [
                          const YaabsaDropdownOption<String?>(value: null, label: 'All Users'),
                          ..._availableUsers.map(
                            (user) => YaabsaDropdownOption<String?>(value: user.id, label: user.username),
                          ),
                        ],
                        onChanged: _isLoadingUsers
                            ? null
                            : (value) {
                                unawaited(_changeFilterUser(value));
                              },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Refresh sessions',
                      onPressed: (_isLoadingUsers || _isLoadingLibrarySessions || _isLoadingOpenSessions)
                          ? null
                          : () {
                              unawaited(_loadAllData());
                            },
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
              centeredContent(const SizedBox(height: 12)),
              centeredContent(_buildLibrarySessionsSection(canEdit: canEdit, canDelete: canDelete)),
              centeredContent(const SizedBox(height: 16)),
              centeredContent(_buildOpenSessionsSection(canEdit: canEdit, canDelete: canDelete)),
              centeredContent(const SizedBox(height: 16)),
              centeredContent(_buildShareSessionsSection(canDelete: canDelete)),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Failed to load user data: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
