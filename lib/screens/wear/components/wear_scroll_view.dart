import 'package:material_ui/material_ui.dart';
import 'package:wear_plus/wear_plus.dart';

class WearScrollView extends StatefulWidget {
  const WearScrollView({required this.children, super.key});

  final List<Widget> children;

  @override
  State<WearScrollView> createState() => _WearScrollViewState();
}

class _WearScrollViewState extends State<WearScrollView> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // An 80% wide, 60% tall rectangle fits inside a round display (~)
              final padding = shape == WearShape.round
                  ? EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.10,
                      vertical: constraints.maxHeight * 0.20,
                    )
                  : const EdgeInsets.all(12);

              return Padding(
                padding: padding,
                child: LayoutBuilder(
                  builder: (context, viewport) {
                    return Scrollbar(
                      controller: _controller,
                      child: SingleChildScrollView(
                        controller: _controller,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: viewport.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: widget.children,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
