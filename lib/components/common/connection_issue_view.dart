import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/generated/l10n.dart';

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
    this.retryLabel,
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
      title: S.current.componentsCommonConnectionIssueViewNoServerConnectionAvailable,
      message: message ?? S.current.componentsCommonConnectionIssueViewRequiresActiveServerConnection,
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
    String title = '',
    String message = '',
    String? secondaryActionLabel,
    Future<void> Function()? onSecondaryAction,
    bool showDownloadsShortcut = true,
  }) {
    final effectiveTitle = title.isEmpty ? S.current.componentsCommonConnectionIssueViewUnableToLoadContent : title;
    final effectiveMessage = message.isEmpty
        ? S.current.componentsCommonConnectionIssueViewTryAgainAndCheckServerConnection
        : message;

    return ConnectionIssueView(
      key: key,
      icon: Icons.error_outline_rounded,
      title: effectiveTitle,
      message: effectiveMessage,
      details: error.toString(),
      onRetry: onRetry,
      secondaryActionLabel: secondaryActionLabel,
      onSecondaryAction: onSecondaryAction,
      showDownloadsShortcut: showDownloadsShortcut,
    );
  }

  final IconData icon;
  final String title;
  final String message;
  final String? details;
  final Future<void> Function()? onRetry;
  final String? secondaryActionLabel;
  final Future<void> Function()? onSecondaryAction;
  final bool showDownloadsShortcut;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveSecondaryAction =
        onSecondaryAction ??
        (showDownloadsShortcut
            ? () async {
                context.go('/?tab=downloads&intent=downloads');
              }
            : null);
    final effectiveSecondaryLabel =
        secondaryActionLabel ??
        (showDownloadsShortcut ? S.current.componentsCommonConnectionIssueViewOpenDownloads : null);
    final effectiveRetryLabel = retryLabel ?? S.current.componentsCommonConnectionIssueViewRetry;

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
                    if (onRetry != null)
                      FilledButton.icon(
                        onPressed: () async {
                          await onRetry!();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(effectiveRetryLabel),
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
