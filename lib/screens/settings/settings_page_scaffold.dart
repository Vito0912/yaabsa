import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  void _handleEmbeddedBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }

    context.go(embeddedBackFallbackRoute ?? '/settings');
  }

  Widget _buildContent(BuildContext context) {
    final contentChildren = <Widget>[
      if (embedded && showEmbeddedTitle)
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 20, 8),
          child: Row(
            children: [
              if (showEmbeddedBackButton)
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => _handleEmbeddedBack(context),
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
        ),
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
        ),
      ),
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
