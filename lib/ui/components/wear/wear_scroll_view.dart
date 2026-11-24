import 'package:material_ui/material_ui.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_indicator.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_physics.dart';

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
              final padding = shape == WearShape.round
                  ? EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.14,
                      vertical: constraints.maxHeight * 0.12,
                    )
                  : const EdgeInsets.all(12);

              final scrollView = SingleChildScrollView(
                controller: _controller,
                physics: const WearScrollPhysics(),
                padding: padding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - padding.vertical),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.children,
                  ),
                ),
              );

              if (shape == WearShape.round) {
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: WearScrollIndicator(controller: _controller, child: scrollView),
                );
              }

              return Scrollbar(controller: _controller, child: scrollView);
            },
          ),
        );
      },
    );
  }
}
