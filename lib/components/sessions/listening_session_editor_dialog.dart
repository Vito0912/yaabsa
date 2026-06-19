import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/sessions/session_duration_picker_field.dart';
import 'package:yaabsa/components/sessions/listening_session_utils.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

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
  DateTime? _sessionDate;
  int? _startedAt;
  int? _updatedAt;

  String? _actionError;
  bool _isSaving = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _startSeconds = widget.session.startTime ?? 0;
    _endSeconds = widget.session.currentTime ?? 0;
    _timeListeningSeconds = widget.session.timeListening ?? 0;
    _sessionDate = listeningSessionDateTime(widget.session);
    _startedAt = widget.session.startedAt;
    _updatedAt = widget.session.updatedAt;
  }

  Future<void> _save() async {
    final saveAction = widget.onSave;
    if (saveAction == null || !widget.canEdit || _isSaving) {
      return;
    }

    if (_startSeconds < 0 || _endSeconds < 0 || _timeListeningSeconds < 0) {
      setState(() {
        _actionError = 'Start, end and listened time must be non-negative.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _actionError = null;
    });

    int? newStartedAt = _startedAt;
    int? newUpdatedAt = _updatedAt;
    String? newDateString = widget.session.date;
    String? newDayOfWeek = widget.session.dayOfWeek;

    if (_sessionDate != null) {
      newDateString =
          '${_sessionDate!.year.toString().padLeft(4, '0')}-${_sessionDate!.month.toString().padLeft(2, '0')}-${_sessionDate!.day.toString().padLeft(2, '0')}';
      switch (_sessionDate!.weekday) {
        case 1:
          newDayOfWeek = 'Monday';
          break;
        case 2:
          newDayOfWeek = 'Tuesday';
          break;
        case 3:
          newDayOfWeek = 'Wednesday';
          break;
        case 4:
          newDayOfWeek = 'Thursday';
          break;
        case 5:
          newDayOfWeek = 'Friday';
          break;
        case 6:
          newDayOfWeek = 'Saturday';
          break;
        case 7:
          newDayOfWeek = 'Sunday';
          break;
      }

      if (newStartedAt != null) {
        final originalStarted = DateTime.fromMillisecondsSinceEpoch(newStartedAt);
        newStartedAt = DateTime(
          _sessionDate!.year,
          _sessionDate!.month,
          _sessionDate!.day,
          originalStarted.hour,
          originalStarted.minute,
          originalStarted.second,
          originalStarted.millisecond,
        ).millisecondsSinceEpoch;
      }

      if (newUpdatedAt != null) {
        final originalUpdated = DateTime.fromMillisecondsSinceEpoch(newUpdatedAt);
        newUpdatedAt = DateTime(
          _sessionDate!.year,
          _sessionDate!.month,
          _sessionDate!.day,
          originalUpdated.hour,
          originalUpdated.minute,
          originalUpdated.second,
          originalUpdated.millisecond,
        ).millisecondsSinceEpoch;
      }
    }

    final updatedSession = widget.session.copyWith(
      startTime: _startSeconds,
      currentTime: _endSeconds,
      timeListening: _timeListeningSeconds,
      updatedAt: newUpdatedAt,
      startedAt: newStartedAt,
      date: newDateString,
      dayOfWeek: newDayOfWeek,
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
        _actionError = 'Failed to save listening session changes.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _actionError = 'Failed to save listening session changes: $error';
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
          title: const Text('Delete Session'),
          content: const Text('Delete this session permanently? This cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
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
        _actionError = 'Failed to delete listening session.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _actionError = 'Failed to delete listening session: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  Future<void> _editTimestamp(int? currentMs, ValueChanged<int?> onChanged) async {
    final current = currentMs != null && currentMs > 0
        ? DateTime.fromMillisecondsSinceEpoch(currentMs)
        : DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDate == null || !mounted) return;

    final newTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(current));
    if (newTime == null || !mounted) return;

    final updated = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
    onChanged(updated.millisecondsSinceEpoch);
  }

  Future<void> _editDuration(String title, double currentSeconds, ValueChanged<double> onChanged) async {
    final pickedSeconds = await showSessionDurationPickerDialog(
      context,
      title: title,
      initialSeconds: currentSeconds.round(),
    );
    if (pickedSeconds != null && mounted) {
      onChanged(pickedSeconds.toDouble());
    }
  }

  Widget _buildSummaryTile(String label, String value, {VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: onEdit != null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 114,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: onEdit != null
                ? Row(
                    children: [
                      Text(value),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: _isSaving || _isDeleting ? null : onEdit,
                      ),
                    ],
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDurationSeconds(double? value) {
    final totalSeconds = (value ?? 0).round();
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secondsPart = duration.inSeconds.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${secondsPart.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(int? value) {
    if (value == null || value <= 0) {
      return 'Unknown';
    }
    return formatDateTimeLabel(DateTime.fromMillisecondsSinceEpoch(value));
  }

  String _playMethodLabel(int? value) {
    if (value == null) {
      return 'Unknown';
    }

    return switch (value) {
      0 => 'Direct Play',
      1 => 'Direct Stream',
      2 => 'Transcode',
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
              _buildSummaryTile('Author', author.isEmpty ? 'Unknown' : author),
              if (userLabel != null && userLabel.isNotEmpty) _buildSummaryTile('User', userLabel),
              _buildSummaryTile(
                'Date',
                formatDateTimeLabel(_sessionDate),
                onEdit: widget.canEdit
                    ? () => _editTimestamp(_sessionDate?.millisecondsSinceEpoch, (val) {
                        if (val != null) {
                          setState(() => _sessionDate = DateTime.fromMillisecondsSinceEpoch(val));
                        }
                      })
                    : null,
              ),
              _buildSummaryTile(
                'Started',
                _formatTimestamp(_startedAt),
                onEdit: widget.canEdit
                    ? () => _editTimestamp(_startedAt, (val) => setState(() => _startedAt = val))
                    : null,
              ),
              _buildSummaryTile(
                'Updated',
                _formatTimestamp(_updatedAt),
                onEdit: widget.canEdit
                    ? () => _editTimestamp(_updatedAt, (val) => setState(() => _updatedAt = val))
                    : null,
              ),
              _buildSummaryTile('Duration', _formatDurationSeconds(widget.session.duration)),
              _buildSummaryTile(
                'Listened',
                _formatDurationSeconds(_timeListeningSeconds),
                onEdit: widget.canEdit
                    ? () => _editDuration(
                        'Time Listened',
                        _timeListeningSeconds,
                        (val) => setState(() => _timeListeningSeconds = val),
                      )
                    : null,
              ),
              _buildSummaryTile(
                'Current Position',
                _formatDurationSeconds(_endSeconds),
                onEdit: widget.canEdit
                    ? () => _editDuration('End', _endSeconds, (val) => setState(() => _endSeconds = val))
                    : null,
              ),
              _buildSummaryTile(
                'Start Position',
                _formatDurationSeconds(_startSeconds),
                onEdit: widget.canEdit
                    ? () => _editDuration('Start', _startSeconds, (val) => setState(() => _startSeconds = val))
                    : null,
              ),
              _buildSummaryTile('Play Method', _playMethodLabel(widget.session.playMethod)),
              if (device.isNotEmpty) _buildSummaryTile('Device', device),
              if (mediaPlayer != null && mediaPlayer.isNotEmpty) _buildSummaryTile('Player', mediaPlayer),
              if (serverVersion != null && serverVersion.isNotEmpty) _buildSummaryTile('Server Version', serverVersion),
              _buildSummaryTile('User ID', widget.session.userId),
              _buildSummaryTile('Item ID', libraryItemId),
              if (episodeId != null && episodeId.isNotEmpty) _buildSummaryTile('Episode ID', episodeId),
              _buildSummaryTile('Session ID', widget.session.id),
              const SizedBox(height: 10),
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
          child: const Text('Close'),
        ),
        if (widget.canDelete)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: _isSaving || _isDeleting ? null : _delete,
            child: _isDeleting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Delete'),
          ),
        if (widget.canEdit)
          FilledButton(
            onPressed: _isSaving || _isDeleting ? null : _save,
            child: _isSaving
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
      ],
    );
  }
}
