import 'package:material_ui/material_ui.dart';

class NavigationItemConfig {
  final IconData icon;
  final String label;
  final Widget page;
  final int? badgeCount;

  Widget buildIcon({Color? color, double? size}) {
    final iconWidget = Icon(icon, color: color, size: size);
    final count = badgeCount;
    if (count == null || count <= 0) {
      return iconWidget;
    }

    return Badge.count(count: count, child: iconWidget);
  }

  const NavigationItemConfig({required this.icon, required this.label, required this.page, this.badgeCount});
}
