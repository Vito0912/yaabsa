import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/ui/components/feedback/feedback_panel.dart';
import 'package:yaabsa/util/l10n.dart';

class ConnectionIssueView extends StatelessWidget {
  const ConnectionIssueView({
    super.key,
    required this.icon,
    this.title,
    this.message,
    this.details,
    this.onRetry,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.showDownloadsShortcut = true,
    this.showBackAction = false,
    this.backActionLabel,
    this.onBackAction,
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
      title: currentAppLocalizations().errorConnectionUnavailable,
      message: message ?? currentAppLocalizations().errorSectionRequiresServerConnection,
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
    String? title,
    String? message,
    String? secondaryActionLabel,
    Future<void> Function()? onSecondaryAction,
    bool showDownloadsShortcut = true,
    bool? showBackAction,
    String? backActionLabel,
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
  final String? title;
  final String? message;
  final String? details;
  final Future<void> Function()? onRetry;
  final String? secondaryActionLabel;
  final Future<void> Function()? onSecondaryAction;
  final bool showDownloadsShortcut;
  final bool showBackAction;
  final String? backActionLabel;
  final Future<void> Function()? onBackAction;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
    final effectiveSecondaryLabel = secondaryActionLabel ?? (showDownloadsShortcut ? l10n.actionOpenDownloads : null);

    return YaabsaFeedbackPanel(
      icon: icon,
      title: title ?? l10n.errorUnableToLoadContent,
      message: message ?? l10n.errorRetryCheckConnection,
      details: details,
      action: onRetry != null || effectiveSecondaryAction != null
          ? Wrap(
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
                    label: Text(backActionLabel ?? l10n.actionBack),
                  ),
                if (onRetry != null)
                  FilledButton.icon(
                    onPressed: () async {
                      await onRetry!();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(retryLabel ?? l10n.actionRetry),
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
            )
          : null,
    );
  }
}
