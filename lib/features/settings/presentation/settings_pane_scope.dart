import 'package:material_ui/material_ui.dart';

class SettingsPaneScope extends InheritedWidget {
  const SettingsPaneScope({
    super.key,
    required this.isTwoPane,
    required this.isSubpage,
    this.breadcrumbText,
    this.onNavigateBack,
    this.onOpenRoute,
    required super.child,
  });

  final bool isTwoPane;
  final bool isSubpage;
  final String? breadcrumbText;
  final VoidCallback? onNavigateBack;
  final ValueChanged<String>? onOpenRoute;

  static SettingsPaneScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsPaneScope>();
  }

  @override
  bool updateShouldNotify(covariant SettingsPaneScope oldWidget) {
    return isTwoPane != oldWidget.isTwoPane ||
        isSubpage != oldWidget.isSubpage ||
        breadcrumbText != oldWidget.breadcrumbText;
  }
}
