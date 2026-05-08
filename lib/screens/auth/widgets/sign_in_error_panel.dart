import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInErrorPanel extends StatelessWidget {
  const SignInErrorPanel({super.key, required this.message, this.stackTraceDetails});

  final String message;
  final String? stackTraceDetails;

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
          if (_canCopyDetails) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => _copyStackTrace(context),
                icon: const Icon(Icons.copy_all_rounded, size: 18),
              ),
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
