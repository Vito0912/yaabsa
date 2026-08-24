import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class SignInErrorPanel extends StatelessWidget {
  const SignInErrorPanel({super.key, required this.message, this.stackTraceDetails, this.onRetry});

  final String message;
  final String? stackTraceDetails;
  final VoidCallback? onRetry;

  bool get _canCopyDetails => stackTraceDetails != null && stackTraceDetails!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded, size: 18, color: colorScheme.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
              ),
            ],
          ),
          if (_canCopyDetails || onRetry != null) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onRetry != null)
                  TextButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Retry'),
                  ),
                if (_canCopyDetails)
                  IconButton(
                    onPressed: () => _copyStackTrace(context),
                    icon: const Icon(Icons.copy_all_rounded, size: 18),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _copyStackTrace(BuildContext context) async {
    final details = stackTraceDetails;
    if (details == null || details.trim().isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: details));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
  }
}
