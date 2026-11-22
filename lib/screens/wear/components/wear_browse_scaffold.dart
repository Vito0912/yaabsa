import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_scaffold.dart';

export 'package:yaabsa/ui/components/wear/wear_browse_button.dart';

class WearBrowseScaffold extends ConsumerWidget {
  const WearBrowseScaffold({
    this.title,
    this.subtitle,
    required this.itemCount,
    required this.itemBuilder,
    this.background,
    this.backgroundColor = Colors.black,
    this.dismissible = true,
    this.transformItems = true,
    this.onLoadMore,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget? background;
  final Color backgroundColor;
  final bool dismissible;
  final bool transformItems;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flatScrolling = ref.watch(wearPreferencesProvider.select((preferences) => preferences.flatScrolling));
    return WearBrowseScaffoldView(
      title: title,
      subtitle: subtitle,
      background: background,
      backgroundColor: backgroundColor,
      dismissible: dismissible,
      transformItems: transformItems,
      flatScrolling: flatScrolling,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onLoadMore: onLoadMore,
    );
  }
}
