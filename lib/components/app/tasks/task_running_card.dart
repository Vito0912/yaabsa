import 'package:flutter/material.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';

class TaskRunningCard extends StatelessWidget {
  const TaskRunningCard({super.key, required this.task, this.progressLabel});

  final AbsTask task;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    final isFinished = task.isFinished;
    final isFailed = task.isFailed;

    final title = _taskTitle(task);
    final description = task.description?.trim();
    final failureMessage = task.error?.trim();
    final scanSummary = _scanSummary(task.data?.scanResults);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: _buildLeadingIcon(context, isFinished: isFinished, isFailed: isFailed),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
                if (description != null && description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                if (scanSummary != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      scanSummary,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                if (!isFinished && progressLabel != null && progressLabel!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      progressLabel!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                if (isFailed && failureMessage != null && failureMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      failureMessage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context, {required bool isFinished, required bool isFailed}) {
    if (!isFinished) {
      return const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.2)));
    }

    if (isFailed) {
      return Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error, size: 20);
    }

    return Icon(Icons.check_circle_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 20);
  }
}

String _taskTitle(AbsTask task) {
  final explicitTitle = task.title?.trim();
  if (explicitTitle != null && explicitTitle.isNotEmpty) {
    return explicitTitle;
  }

  switch (task.action) {
    case 'embed-metadata':
      return 'Embedding Metadata';
    case 'encode-m4b':
      return 'Encoding M4B';
    case 'library-scan':
      return 'Scanning Library';
    case 'library-match-all':
      return 'Matching Library Items';
    case 'scan-item':
      return 'Scanning Item';
    default:
      return task.action.trim().isEmpty ? 'Task' : task.action;
  }
}

String? _scanSummary(AbsTaskScanResults? scanResults) {
  if (scanResults == null) {
    return null;
  }

  final segments = <String>[];
  if ((scanResults.added ?? 0) > 0) {
    segments.add('Added ${scanResults.added}');
  }
  if ((scanResults.updated ?? 0) > 0) {
    segments.add('Updated ${scanResults.updated}');
  }
  if ((scanResults.missing ?? 0) > 0) {
    segments.add('Missing ${scanResults.missing}');
  }

  if ((scanResults.elapsed ?? 0) > 0) {
    final elapsed = Duration(milliseconds: scanResults.elapsed!);
    segments.add('Elapsed ${elapsed.inSeconds}s');
  }

  if (segments.isEmpty) {
    return null;
  }

  return segments.join(' • ');
}
