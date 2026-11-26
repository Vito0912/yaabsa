import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/features/settings/presentation/settings_pane_scope.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsPageScaffold extends StatelessWidget {
  const SettingsPageScaffold({
    required this.title,
    required this.children,
    super.key,
    this.maxWidth = 700,
    this.padding = const EdgeInsets.only(bottom: 24),
    this.embedded = false,
    this.showEmbeddedTitle = true,
    this.showEmbeddedBackButton = false,
    this.embeddedBackFallbackRoute,
  });

  final String title;
  final List<Widget> children;
  final double maxWidth;
  final EdgeInsetsGeometry padding;
  final bool embedded;
  final bool showEmbeddedTitle;
  final bool showEmbeddedBackButton;
  final String? embeddedBackFallbackRoute;

  void _handleEmbeddedBack(BuildContext context, SettingsPaneScope? paneScope) {
    if (paneScope?.onNavigateBack != null) {
      paneScope!.onNavigateBack!();
      return;
    }

    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }

    context.go(embeddedBackFallbackRoute ?? '/settings');
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
            onTap: showBack ? () => _handleEmbeddedBack(context, paneScope) : null,
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
                onPressed: () => _handleEmbeddedBack(context, paneScope),
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

  Widget _buildContent(BuildContext context) {
    final paneScope = SettingsPaneScope.maybeOf(context);
    final isTwoPane = paneScope != null && paneScope.isTwoPane;
    final showBack = isTwoPane ? paneScope.isSubpage : showEmbeddedBackButton;
    final breadcrumbText = isTwoPane ? paneScope.breadcrumbText : null;

    if (isTwoPane) {
      final effectiveMaxWidth = maxWidth == 700 ? 920.0 : maxWidth;
      final bodyColumn = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
      final listView = ListView(
        padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
        children: [
          if (maxWidth == double.infinity)
            bodyColumn
          else
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
                child: bodyColumn,
              ),
            ),
        ],
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (embedded && showEmbeddedTitle) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 12),
              child: _buildTwoPaneHeader(context, paneScope, showBack: showBack, breadcrumbText: breadcrumbText),
            ),
            const Divider(height: 1),
          ],
          Expanded(child: listView),
        ],
      );
    }

    final resolvedPadding = padding.resolve(Directionality.of(context));
    final bodyConstrained = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
    final paddedBody = resolvedPadding.horizontal == 0
        ? Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: bodyConstrained)
        : bodyConstrained;

    final contentChildren = <Widget>[
      if (embedded && showEmbeddedTitle)
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(showBack ? 8 : 16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (breadcrumbText != null && breadcrumbText.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: showBack ? 48 : 0, bottom: 2),
                      child: Text(
                        breadcrumbText,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  Row(
                    children: [
                      if (showBack)
                        IconButton(
                          tooltip: context.l10n.actionBack,
                          onPressed: () => _handleEmbeddedBack(context, paneScope),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      Center(child: paddedBody),
    ];

    return ListView(padding: padding, children: contentChildren);
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);
    if (embedded) {
      return Material(color: Theme.of(context).scaffoldBackgroundColor, child: content);
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(top: false, child: content),
    );
  }
}
