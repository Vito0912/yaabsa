import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConnectionIssueView extends StatelessWidget {
  const ConnectionIssueView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.details,
    this.onRetry,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.showDownloadsShortcut = true,
    this.showBackAction = false,
    this.backActionLabel = 'Back',
    this.onBackAction,
    this.retryLabel = 'Retry',
  });

  factory ConnectionIssueView.offline({
    Key? key,
    Future<void> Function()? onRetry,
    String? message,
    String? secondaryActionLabel,
    Future<void> Function()? onSecondaryAction,
    bool showDownloadsShortcut = true,
  }) {
    return ConnectionIssueView(
      key: key,
      icon: Icons.cloud_off_rounded,
      title: 'No server connection available',
      message: message ?? 'This section requires an active server connection. Reconnect and try again.',
      onRetry: onRetry,
      secondaryActionLabel: secondaryActionLabel,
      onSecondaryAction: onSecondaryAction,
      showDownloadsShortcut: showDownloadsShortcut,
    );
  }

  factory ConnectionIssueView.requestFailed({
    Key? key,
    required Object error,
    Future<void> Function()? onRetry,
    String title = 'Unable to load content',
    String message = 'Please try again. If the issue persists, check your server connection.',
    String? secondaryActionLabel,
    Future<void> Function()? onSecondaryAction,
    bool showDownloadsShortcut = true,
    bool? showBackAction,
    String backActionLabel = 'Back',
    Future<void> Function()? onBackAction,
  }) {
    final resolvedShowBackAction = showBackAction ?? _looksLikeNotFoundError(error);

    return ConnectionIssueView(
      key: key,
      icon: Icons.error_outline_rounded,
      title: title,
      message: message,
      details: error.toString(),
      onRetry: onRetry,
      secondaryActionLabel: secondaryActionLabel,
      onSecondaryAction: onSecondaryAction,
      showDownloadsShortcut: showDownloadsShortcut,
      showBackAction: resolvedShowBackAction,
      backActionLabel: backActionLabel,
      onBackAction: onBackAction,
    );
  }

  static bool _looksLikeNotFoundError(Object error) {
    final message = error.toString().toLowerCase();
    return message.contains('404') || message.contains('not found');
  }

  final IconData icon;
  final String title;
  final String message;
  final String? details;
  final Future<void> Function()? onRetry;
  final String? secondaryActionLabel;
  final Future<void> Function()? onSecondaryAction;
  final bool showDownloadsShortcut;
  final bool showBackAction;
  final String backActionLabel;
  final Future<void> Function()? onBackAction;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveBackAction = showBackAction
        ? (onBackAction ??
              () async {
                final navigator = Navigator.of(context);
                final router = GoRouter.of(context);
                final didPop = await navigator.maybePop();
                if (!didPop) {
                  router.go('/');
                }
              })
        : null;
    final effectiveSecondaryAction =
        onSecondaryAction ??
        (showDownloadsShortcut
            ? () async {
                context.go('/?tab=downloads&intent=downloads');
              }
            : null);
    final effectiveSecondaryLabel = secondaryActionLabel ?? (showDownloadsShortcut ? 'Open Downloads' : null);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              if (details != null && details!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  details!,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
              if (onRetry != null || effectiveSecondaryAction != null) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    if (effectiveBackAction != null)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await effectiveBackAction();
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: Text(backActionLabel),
                      ),
                    if (onRetry != null)
                      FilledButton.icon(
                        onPressed: () async {
                          await onRetry!();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(retryLabel),
                      ),
                    if (effectiveSecondaryAction != null &&
                        effectiveSecondaryLabel != null &&
                        effectiveSecondaryLabel.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed: () async {
                          await effectiveSecondaryAction();
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: Text(effectiveSecondaryLabel),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
