import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/open_share_session.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

Future<bool?> showOpenShareSessionDialog(
  BuildContext context, {
  required OpenShareSession session,
  required bool canDelete,
  Future<bool> Function()? onDelete,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return _OpenShareSessionDialog(session: session, canDelete: canDelete, onDelete: onDelete);
    },
  );
}

class _OpenShareSessionDialog extends StatefulWidget {
  const _OpenShareSessionDialog({required this.session, required this.canDelete, this.onDelete});

  final OpenShareSession session;
  final bool canDelete;
  final Future<bool> Function()? onDelete;

  @override
  State<_OpenShareSessionDialog> createState() => _OpenShareSessionDialogState();
}

class _OpenShareSessionDialogState extends State<_OpenShareSessionDialog> {
  bool _isDeleting = false;
  String? _actionError;

  DateTime? _sessionDate() {
    final updatedAt = widget.session.updatedAt;
    if (updatedAt != null && updatedAt > 0) {
      return DateTime.fromMillisecondsSinceEpoch(updatedAt);
    }

    final startedAt = widget.session.startedAt;
    if (startedAt != null && startedAt > 0) {
      return DateTime.fromMillisecondsSinceEpoch(startedAt);
    }

    return null;
  }

  Widget _buildSummaryTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _delete() async {
    final deleteAction = widget.onDelete;
    if (!widget.canDelete || deleteAction == null || _isDeleting) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Shared Session'),
          content: const Text('Delete this shared session permanently? This cannot be undone.'),
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
        _actionError = 'Failed to delete shared session.';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _actionError = 'Failed to delete shared session: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.session.displayTitle?.trim();
    final author = widget.session.displayAuthor?.trim();
    final userName = widget.session.user?.username.trim();
    final deviceName = widget.session.deviceInfo?.clientName?.trim();

    return AlertDialog(
      title: const Text('Shared Session'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (title == null || title.isEmpty) ? 'Unknown Item' : title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (author != null && author.isNotEmpty) _buildSummaryTile('Author', author),
              if (userName != null && userName.isNotEmpty) _buildSummaryTile('User', userName),
              if (deviceName != null && deviceName.isNotEmpty) _buildSummaryTile('Device', deviceName),
              _buildSummaryTile('Date', formatDateTimeLabel(_sessionDate())),
              _buildSummaryTile('Session ID', widget.session.id),
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
        TextButton(onPressed: _isDeleting ? null : () => Navigator.of(context).pop(false), child: const Text('Close')),
        if (widget.canDelete)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            onPressed: _isDeleting ? null : _delete,
            child: _isDeleting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Delete'),
          ),
      ],
    );
  }
}
