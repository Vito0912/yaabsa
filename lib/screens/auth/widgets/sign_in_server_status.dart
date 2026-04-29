import 'package:flutter/material.dart';
import 'package:yaabsa/api/me/status.dart';

class SignInServerStatus extends StatelessWidget {
  const SignInServerStatus({super.key, required this.isLoading, required this.status, required this.error});

  final bool isLoading;
  final ServerStatus? status;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Row(
        children: [
          SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 8),
          Text('Checking server...', style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      );
    }

    if (status != null) {
      return Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              status!.serverVersion,
              style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      );
    }

    if (error != null) {
      return Text(error!, style: textTheme.bodySmall?.copyWith(color: colorScheme.error));
    }

    return const SizedBox.shrink();
  }
}
