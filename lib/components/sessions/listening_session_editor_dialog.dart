import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/sessions/session_duration_picker_field.dart';
import 'package:yaabsa/components/sessions/listening_session_utils.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/item_formatters.dart';

import 'package:yaabsa/generated/l10n.dart';

Future<bool?> showListeningSessionEditorDialog(
  BuildContext context, {
  required PlaybackSession session,
  required bool canEdit,
  required bool canDelete,
  String? username,
  Future<bool> Function(PlaybackSession updatedSession)? onSave,
  Future<bool> Function()? onDelete,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return _ListeningSessionEditorDialog(
        session: session,
        username: username,
        canEdit: canEdit,
        canDelete: canDelete,
        onSave: onSave,
        onDelete: onDelete,
      );
    },
  );
}

class _ListeningSessionEditorDialog extends StatefulWidget {
  const _ListeningSessionEditorDialog({
    required this.session,
    required this.canEdit,
    required this.canDelete,
    this.username,
    this.onSave,
    this.onDelete,
  });

  final PlaybackSession session;
  final bool canEdit;
  final bool canDelete;
  final String? username;
  final Future<bool> Function(PlaybackSession updatedSession)? onSave;
  final Future<bool> Function()? onDelete;

  @override
  State<_ListeningSessionEditorDialog> createState() => _ListeningSessionEditorDialogState();
}

class _ListeningSessionEditorDialogState extends State<_ListeningSessionEditorDialog> {
  late double _startSeconds;
  late double _endSeconds;
  late double _timeListeningSeconds;

  String? _actionError;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _startSeconds = widget.session.startTime ?? 0;
    _endSeconds = widget.session.currentTime ?? 0;
    _timeListeningSeconds = widget.session.timeListening ?? 0;
  }

  Future<void> _save() async {
    final saveAction = widget.onSave;
    if (saveAction == null || !widget.canEdit || _isSaving) {
      return;
    }

    if (_startSeconds < 0 || _endSeconds < 0 || _timeListeningSeconds < 0) {
      setState(() {
        _actionError = S.current.componentsSessionsListeningSessionEditorDialogStartEndAndListenedTimeMustBeNonNegative;
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _actionError = null;
    });

    final updatedSession = widget.session.copyWith(
      startTime: _startSeconds,
      currentTime: _endSeconds,
      timeListening: _timeListeningSeconds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    try {
      final success = await saveAction(updatedSession);
      if (!mounted) {
        return;
      }

      if (success) {
        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _actionError = S.current.componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChanges;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _actionError = S.current.componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChangesError(
          error,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    final deleteAction = widget.onDelete;
    if (deleteAction == null || !widget.canDelete || _isDeleting) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.current.componentsSessionsListeningSessionEditorDialogDeleteSession),
          content: Text(S.current.componentsSessionsListeningSessionEditorDialogDeleteThisSessionPermanentlyThisCannot),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.current.componentsSessionsListeningSessionEditorDialogCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(S.current.componentsSessionsListeningSessionEditorDialogDelete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      _isDeleting = true;
      _actionError = null;
    });

    try {
      final success = await deleteAction();
      if (!mounted) {
        return;
      }

      if (success) {
        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _actionError = S.current.componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSession;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _actionError = S.current.componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSessionError(
          error,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Widget _buildSummaryTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 114,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDurationSeconds(double? value) {
    final totalSeconds = (value ?? 0).round();
    return formatDurationShort(Duration(seconds: totalSeconds));
  }

  String _formatTimestamp(int? value) {
    if (value == null || value <= 0) {
      return S.current.componentsSessionsListeningSessionEditorDialogUnknown;
    }
    return formatDateTimeLabel(DateTime.fromMillisecondsSinceEpoch(value));
  }

  String _playMethodLabel(int? value) {
    if (value == null) {
      return S.current.componentsSessionsListeningSessionEditorDialogUnknown;
    }

    return switch (value) {
      0 => S.current.componentsSessionsListeningSessionEditorDialogDirectPlay,
      1 => S.current.componentsSessionsListeningSessionEditorDialogDirectStream,
      2 => S.current.componentsSessionsListeningSessionEditorDialogTranscode,
      _ => value.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final author = listeningSessionAuthor(widget.session);
    final userLabel = widget.username?.trim();
    final displayTitle = widget.session.displayTitle?.trim();
    final title = (displayTitle != null && displayTitle.isNotEmpty)
        ? displayTitle
        : listeningSessionTitle(widget.session);
    final device = listeningSessionDeviceLabel(widget.session);
    final mediaPlayer = widget.session.mediaPlayer?.trim();
    final serverVersion = widget.session.serverVersion?.trim();
    final libraryItemId = widget.session.libraryItemId;
    final episodeId = widget.session.episodeId?.trim();

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogAuthor,
                author.isEmpty ? S.current.componentsSessionsListeningSessionEditorDialogUnknown : author,
              ),
              if (userLabel != null && userLabel.isNotEmpty)
                _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogUser, userLabel),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogDate,
                formatDateTimeLabel(listeningSessionDateTime(widget.session)),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogStarted,
                _formatTimestamp(widget.session.startedAt),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogUpdated,
                _formatTimestamp(widget.session.updatedAt),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogDuration,
                _formatDurationSeconds(widget.session.duration),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogListened,
                _formatDurationSeconds(widget.session.timeListening),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogCurrentPosition,
                _formatDurationSeconds(widget.session.currentTime),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogStartPosition,
                _formatDurationSeconds(widget.session.startTime),
              ),
              _buildSummaryTile(
                S.current.componentsSessionsListeningSessionEditorDialogPlayMethod,
                _playMethodLabel(widget.session.playMethod),
              ),
              if (device.isNotEmpty)
                _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogDevice, device),
              if (mediaPlayer != null && mediaPlayer.isNotEmpty)
                _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogPlayer, mediaPlayer),
              if (serverVersion != null && serverVersion.isNotEmpty)
                _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogServerVersion, serverVersion),
              _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogUserId, widget.session.userId),
              _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogItemId, libraryItemId),
              if (episodeId != null && episodeId.isNotEmpty)
                _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogEpisodeId, episodeId),
              _buildSummaryTile(S.current.componentsSessionsListeningSessionEditorDialogSessionId, widget.session.id),
              const SizedBox(height: 10),
              if (widget.canEdit)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SessionDurationPickerField(
                      label: S.current.componentsSessionsListeningSessionEditorDialogStart,
                      seconds: _startSeconds,
                      enabled: !_isSaving && !_isDeleting,
                      onChanged: (value) {
                        setState(() {
                          _startSeconds = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SessionDurationPickerField(
                      label: S.current.componentsSessionsListeningSessionEditorDialogEnd,
                      seconds: _endSeconds,
                      enabled: !_isSaving && !_isDeleting,
                      onChanged: (value) {
                        setState(() {
                          _endSeconds = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SessionDurationPickerField(
                      label: S.current.componentsSessionsListeningSessionEditorDialogTimeListened,
                      seconds: _timeListeningSeconds,
                      enabled: !_isSaving && !_isDeleting,
                      onChanged: (value) {
                        setState(() {
                          _timeListeningSeconds = value;
                        });
                      },
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryTile(
                      S.current.componentsSessionsListeningSessionEditorDialogStart,
                      _formatDurationSeconds(widget.session.startTime),
                    ),
                    _buildSummaryTile(
                      S.current.componentsSessionsListeningSessionEditorDialogEnd,
                      _formatDurationSeconds(widget.session.currentTime),
                    ),
                    _buildSummaryTile(
                      S.current.componentsSessionsListeningSessionEditorDialogListened,
                      _formatDurationSeconds(widget.session.timeListening),
                    ),
                  ],
                ),
              if (_actionError != null && _actionError!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(_actionError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving || _isDeleting ? null : () => Navigator.of(context).pop(false),
          child: Text(S.current.componentsSessionsListeningSessionEditorDialogClose),
        ),
        if (widget.canDelete)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: _isSaving || _isDeleting ? null : _delete,
            child: _isDeleting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(S.current.componentsSessionsListeningSessionEditorDialogDelete),
          ),
        if (widget.canEdit)
          FilledButton(
            onPressed: _isSaving || _isDeleting ? null : _save,
            child: _isSaving
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(S.current.componentsSessionsListeningSessionEditorDialogSave),
          ),
      ],
    );
  }
}
