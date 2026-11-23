import 'package:material_ui/material_ui.dart';
import 'package:wear_plus/wear_plus.dart';

class WearFixedView extends StatelessWidget {
  const WearFixedView({required this.children, super.key}) : builder = null;

  const WearFixedView.builder({required this.builder, super.key}) : children = const [];

  final List<Widget> children;
  final LayoutWidgetBuilder? builder;

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
                child: builder != null
                    ? LayoutBuilder(builder: builder!)
                    : Column(
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
