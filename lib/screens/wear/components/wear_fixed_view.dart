import 'package:material_ui/material_ui.dart';
import 'package:wear_plus/wear_plus.dart';

class WearFixedView extends StatelessWidget {
  const WearFixedView({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final padding = shape == WearShape.round
                  ? EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.08,
                      vertical: constraints.maxHeight * 0.08,
                    )
                  : const EdgeInsets.all(12);

              return Padding(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
