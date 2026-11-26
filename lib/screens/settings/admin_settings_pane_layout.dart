import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/presentation/settings_pane_scope.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminSettingsPaneLayout extends StatelessWidget {
  const AdminSettingsPaneLayout({
    super.key,
    required this.title,
    required this.child,
    this.maxWidth,
    this.fallbackRoute = SettingsRoutes.adminServer,
  });

  final String title;
  final Widget child;
  final double? maxWidth;
  final String fallbackRoute;

  void _handleBack(BuildContext context, SettingsPaneScope? paneScope) {
    if (paneScope?.onNavigateBack != null) {
      paneScope!.onNavigateBack!();
      return;
    }

    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }

    context.go(fallbackRoute);
  }

  Widget _buildTwoPaneHeader(
    BuildContext context,
    SettingsPaneScope? paneScope, {
    required bool showBack,
    required String? breadcrumbText,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumbText != null && breadcrumbText.isNotEmpty) ...[
          InkWell(
            onTap: showBack ? () => _handleBack(context, paneScope) : null,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                breadcrumbText,
                style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
        Row(
          children: [
            if (showBack) ...[
              IconButton(
                tooltip: context.l10n.actionBack,
                onPressed: () => _handleBack(context, paneScope),
                icon: const Icon(Icons.arrow_back_rounded),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paneScope = SettingsPaneScope.maybeOf(context);
    final isTwoPane = paneScope != null && paneScope.isTwoPane;

    if (isTwoPane) {
      final showBack = paneScope.isSubpage;
      final breadcrumbText = paneScope.breadcrumbText;

      return Material(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 12),
              child: _buildTwoPaneHeader(context, paneScope, showBack: showBack, breadcrumbText: breadcrumbText),
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                child: maxWidth != null
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth!),
                          child: child,
                        ),
                      )
                    : child,
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: context.l10n.actionBack,
                  onPressed: () => _handleBack(context, paneScope),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Expanded(
                  child: Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: maxWidth != null
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth!),
                        child: child,
                      ),
                    )
                  : child,
            ),
          ),
        ],
      ),
    );
  }
}
