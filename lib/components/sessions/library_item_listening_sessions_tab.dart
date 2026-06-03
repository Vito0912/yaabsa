import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/stats/listening_sessions_page.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/sessions/listening_session_editor_dialog.dart';
import 'package:yaabsa/components/sessions/listening_session_list.dart';
import 'package:yaabsa/components/sessions/listening_sessions_pagination_controls.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/item/podcast/podcast_episode_utils.dart';
import 'package:yaabsa/util/logger.dart';

class LibraryItemListeningSessionsTab extends ConsumerStatefulWidget {
  const LibraryItemListeningSessionsTab({super.key, required this.item, this.initialEpisodeId});

  final LibraryItem item;
  final String? initialEpisodeId;

  @override
  ConsumerState<LibraryItemListeningSessionsTab> createState() => _LibraryItemListeningSessionsTabState();
}

class _LibraryItemListeningSessionsTabState extends ConsumerState<LibraryItemListeningSessionsTab> {
  static const int _defaultItemsPerPage = 20;
  static const List<int> _pageSizeOptions = <int>[20, 50, 100];

  String? _activeUserId;
  String? _selectedEpisodeId;
  bool _isLoading = true;
  bool _isBulkDeleting = false;
  String? _errorMessage;

  int _currentPage = 0;
  int _numPages = 1;
  int _totalSessions = 0;
  int _itemsPerPage = _defaultItemsPerPage;

  List<PlaybackSession> _sessions = <PlaybackSession>[];
  final Set<String> _selectedSessionIds = <String>{};

  @override
  void initState() {
    super.initState();
    final initialEpisode = widget.initialEpisodeId;
    final hasInitialEpisode =
        initialEpisode != null &&
        (widget.item.media?.podcastMedia?.episodes?.any((episode) => episode.id == initialEpisode) ?? false);
    _selectedEpisodeId = hasInitialEpisode ? initialEpisode : null;
  }

  List<Episode> get _episodes {
    return widget.item.media?.podcastMedia?.episodes ?? const <Episode>[];
  }

  bool get _showEpisodeFilter {
    return _episodes.isNotEmpty;
  }

  ABSApi? _api() {
    return ref.read(absApiProvider);
  }

  Future<void> _loadSessions() async {
    final api = _api();
    final currentUser = ref.read(currentUserProvider).value;

    if (api == null || currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await api.getMeApi().getMeItemListeningSessions(
        widget.item.id,
        episodeId: _selectedEpisodeId,
        page: _currentPage,
        itemsPerPage: _itemsPerPage,
      );

      final pageData = response.data ?? const ListeningSessionsPage();

      if (!mounted) {
        return;
      }

      setState(() {
        _sessions = pageData.sessions;
        _selectedSessionIds.removeWhere((sessionId) => !_sessions.any((session) => session.id == sessionId));
        _totalSessions = pageData.total ?? pageData.sessions.length;
        _numPages = (pageData.numPages ?? 1) <= 0 ? 1 : pageData.numPages!;
        _currentPage = pageData.page ?? _currentPage;
      });
    } catch (error, stackTrace) {
      logger(
        'Failed to load item listening sessions for item=${widget.item.id} episode=$_selectedEpisodeId: '
        '$error\n$stackTrace',
        tag: 'LibraryItemListeningSessionsTab',
        level: InfoLevel.error,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load item sessions: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _goToPreviousPage() async {
    if (_currentPage <= 0 || _isLoading) {
      return;
    }

    setState(() {
      _currentPage -= 1;
    });
    await _loadSessions();
  }

  Future<void> _goToNextPage() async {
    final lastPage = _numPages <= 0 ? 0 : _numPages - 1;
    if (_currentPage >= lastPage || _isLoading) {
      return;
    }

    setState(() {
      _currentPage += 1;
    });
    await _loadSessions();
  }

  Future<void> _changeEpisodeFilter(String? episodeId) async {
    setState(() {
      _selectedEpisodeId = episodeId;
      _currentPage = 0;
      _errorMessage = null;
      _selectedSessionIds.clear();
    });

    await _loadSessions();
  }

  Future<void> _changeItemsPerPage(int itemsPerPage) async {
    if (itemsPerPage == _itemsPerPage) {
      return;
    }

    setState(() {
      _itemsPerPage = itemsPerPage;
      _currentPage = 0;
      _errorMessage = null;
      _selectedSessionIds.clear();
    });

    await _loadSessions();
  }

  void _onSessionSelectionChanged(PlaybackSession session, bool selected) {
    setState(() {
      if (selected) {
        _selectedSessionIds.add(session.id);
      } else {
        _selectedSessionIds.remove(session.id);
      }
    });
  }

  bool _canDeleteSession(User currentUser, PlaybackSession session) {
    return currentUser.permissions.delete || session.userId == currentUser.id;
  }

  bool _canDeleteSelectedSessions(User currentUser) {
    if (_selectedSessionIds.isEmpty) {
      return false;
    }

    if (currentUser.permissions.delete) {
      return true;
    }

    return _sessions
        .where((session) => _selectedSessionIds.contains(session.id))
        .every((session) => session.userId == currentUser.id);
  }

  Future<void> _bulkDeleteSelectedSessions(User currentUser) async {
    final api = _api();
    if (api == null || _isBulkDeleting || !_canDeleteSelectedSessions(currentUser)) {
      return;
    }

    final selectedSessions = _sessions.where((session) => _selectedSessionIds.contains(session.id)).toList();
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
          'Failed deleting item session ${session.id}: $error\n$stackTrace',
          tag: 'LibraryItemListeningSessionsTab',
          level: InfoLevel.error,
        );
        failedSessionIds.add(session.id);
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedSessionIds.clear();
      _isBulkDeleting = false;
    });

    await _loadSessions();

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

  Future<void> _openSessionDialog(PlaybackSession session, User currentUser) async {
    final api = _api();
    if (api == null) {
      return;
    }

    final canEdit = session.userId == currentUser.id;
    final canDelete = _canDeleteSession(currentUser, session);

    final changed = await showListeningSessionEditorDialog(
      context,
      session: session,
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
      await _loadSessions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Center(child: Text('No active user.'));
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadSessions());
          });
        }

        if (_isLoading && _sessions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _loadSessions,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            children: [
              if (_showEpisodeFilter)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: YaabsaExpressiveDropdownField<String?>(
                    value: _selectedEpisodeId,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Episode',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    options: [
                      const YaabsaDropdownOption<String?>(value: null, label: 'All Episodes'),
                      ..._episodes.map(
                        (episode) =>
                            YaabsaDropdownOption<String?>(value: episode.id, label: podcastEpisodeTitle(episode)),
                      ),
                    ],
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            unawaited(_changeEpisodeFilter(value));
                          },
                  ),
                ),
              if (_errorMessage != null && _errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
                      ),
                    ),
                  ),
                ),
              ListeningSessionsPaginationControls(
                page: _currentPage,
                numPages: _numPages,
                total: _totalSessions,
                itemsPerPage: _itemsPerPage,
                pageSizeOptions: _pageSizeOptions,
                isLoading: _isLoading,
                onItemsPerPageChanged: (value) {
                  unawaited(_changeItemsPerPage(value));
                },
                onPrevious: _currentPage > 0 ? _goToPreviousPage : null,
                onNext: _currentPage < (_numPages - 1) ? _goToNextPage : null,
              ),
              if (_isLoading)
                const Padding(padding: EdgeInsets.only(bottom: 8), child: LinearProgressIndicator(minHeight: 2)),
              if (_selectedSessionIds.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text('${_selectedSessionIds.length} selected'),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: (_isBulkDeleting || !_canDeleteSelectedSessions(currentUser))
                            ? null
                            : () {
                                unawaited(_bulkDeleteSelectedSessions(currentUser));
                              },
                        icon: _isBulkDeleting
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.delete_outline_rounded),
                        label: const Text('Delete Selected'),
                      ),
                    ],
                  ),
                ),
              ListeningSessionTable(
                sessions: _sessions,
                showSelection: true,
                selectedSessionIds: _selectedSessionIds,
                onSelectionChanged: _onSessionSelectionChanged,
                onSessionTap: (session) async {
                  await _openSessionDialog(session, currentUser);
                },
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load user: $error')),
    );
  }
}
