import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class TaskRunningCard extends StatelessWidget {
  const TaskRunningCard({super.key, required this.task, this.progressLabel});

  final AbsTask task;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isFinished = task.isFinished;
    final isFailed = task.isFailed;

    final title = _taskTitle(task, l10n);
    final description = task.description?.trim();
    final failureMessage = task.error?.trim();
    final scanSummary = _scanSummary(task.data?.scanResults, l10n);

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
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                if (scanSummary != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      scanSummary,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.error),
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
      return const Center(
        child: SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2.2)),
      );
    }

    if (isFailed) {
      return Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error, size: 20);
    }

    return Icon(Icons.check_circle_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 20);
  }
}

String _taskTitle(AbsTask task, AppLocalizations l10n) {
  final explicitTitle = task.title?.trim();
  if (explicitTitle != null && explicitTitle.isNotEmpty) {
    return explicitTitle;
  }

  switch (task.action) {
    case 'embed-metadata':
      return l10n.taskEmbeddingMetadata;
    case 'encode-m4b':
      return l10n.taskEncodingM4b;
    case 'library-scan':
      return l10n.taskScanningLibrary;
    case 'library-match-all':
      return l10n.taskMatchingLibraryItems;
    case 'scan-item':
      return l10n.taskScanningItem;
    default:
      return task.action.trim().isEmpty ? l10n.taskGeneric : task.action;
  }
}

String? _scanSummary(AbsTaskScanResults? scanResults, AppLocalizations l10n) {
  if (scanResults == null) {
    return null;
  }

  final segments = <String>[];
  if ((scanResults.added ?? 0) > 0) {
    segments.add(l10n.taskScanAddedCount(scanResults.added!));
  }
  if ((scanResults.updated ?? 0) > 0) {
    segments.add(l10n.taskScanUpdatedCount(scanResults.updated!));
  }
  if ((scanResults.missing ?? 0) > 0) {
    segments.add(l10n.taskScanMissingCount(scanResults.missing!));
  }

  if ((scanResults.elapsed ?? 0) > 0) {
    final elapsed = Duration(milliseconds: scanResults.elapsed!);
    segments.add(l10n.taskScanElapsed(l10n.durationCompactSeconds(elapsed.inSeconds)));
  }

  if (segments.isEmpty) {
    return null;
  }

  return segments.join(' • ');
}
