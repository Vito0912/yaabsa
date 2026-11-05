import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

class WearSwipeToDismiss extends StatelessWidget {
  const WearSwipeToDismiss({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);

    return Dismissible(
      key: const ValueKey('wear-screen'),
      direction: Directionality.of(context) == TextDirection.rtl
          ? DismissDirection.endToStart
          : DismissDirection.startToEnd,
      background: const ColoredBox(color: Colors.black),
      confirmDismiss: (_) async {
        if (route == null || !route.isCurrent) {
          return false;
        }

        if (route.isFirst) {
          await SystemNavigator.pop();
        } else {
          await Navigator.of(context).maybePop();
        }

        return false;
      },
      child: child,
    );
  }
}
