import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/util/logger.dart';

enum DesktopPageCommand { search, refresh, dismiss }

class DesktopShortcutController {
  final List<_DesktopPageShortcutsState> _targets = [];
  bool _refreshing = false;

  bool invoke(DesktopPageCommand command) {
    final targets = _targets.where((target) => target.isActive).toList()
      ..sort((a, b) => (b.context as Element).depth.compareTo((a.context as Element).depth));
    for (final target in targets) {
      switch (command) {
        case DesktopPageCommand.search:
          final callback = target.widget.onSearch;
          if (callback != null) {
            callback();
            return true;
          }
        case DesktopPageCommand.refresh:
          final callback = target.widget.onRefresh;
          if (callback != null) {
            if (!_refreshing) unawaited(_refresh(target.refresh));
            return true;
          }
        case DesktopPageCommand.dismiss:
          if (target.widget.onDismiss?.call() ?? false) return true;
      }
    }
    return false;
  }

  Future<void> _refresh(Future<void> Function() callback) async {
    _refreshing = true;
    try {
      await callback();
    } catch (e, s) {
      logger('Shortcut refresh failed: $e\n$s', tag: 'Navigation', level: InfoLevel.error);
    } finally {
      _refreshing = false;
    }
  }
}

class DesktopShortcutScope extends InheritedWidget {
  const DesktopShortcutScope({super.key, required this.controller, required super.child});

  final DesktopShortcutController controller;

  static DesktopShortcutController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DesktopShortcutScope>()?.controller;
  }

  @override
  bool updateShouldNotify(DesktopShortcutScope oldWidget) => controller != oldWidget.controller;
}

class DesktopPageShortcuts extends ConsumerStatefulWidget {
  const DesktopPageShortcuts({super.key, this.onSearch, this.onRefresh, this.onDismiss, required this.child});

  final VoidCallback? onSearch;
  final Future<void> Function()? onRefresh;
  final bool Function()? onDismiss;
  final Widget child;

  @override
  ConsumerState<DesktopPageShortcuts> createState() => _DesktopPageShortcutsState();
}

class _DesktopPageShortcutsState extends ConsumerState<DesktopPageShortcuts> {
  DesktopShortcutController? _controller;
  List<ModalRoute<dynamic>> _routes = [];
  bool _refreshing = false;

  Future<void> refresh() async {
    final callback = widget.onRefresh;
    if (!mounted || callback == null || _refreshing) return;
    setState(() => _refreshing = true);
    try {
      await Future.wait<void>([
        ref.read(mediaProgressProvider.notifier).refreshAllProgress(),
        Future<void>.sync(callback),
      ]);
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  bool get isActive {
    if (!mounted || _routes.any((route) => !route.isCurrent)) return false;
    final box = context.findRenderObject();
    if (box is RenderBox && box.attached && box.hasSize) {
      final bounds = box.localToGlobal(Offset.zero) & box.size;
      final screen = Offset.zero & MediaQuery.sizeOf(context);
      if (!bounds.overlaps(screen)) return false;
    }
    var visible = true;
    context.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is Offstage && widget.offstage) {
        visible = false;
        return false;
      }
      return true;
    });
    return visible;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DesktopShortcutScope.maybeOf(context);
    if (controller != _controller) {
      _controller?._targets.remove(this);
      _controller = controller;
      _controller?._targets.add(this);
    }
    final route = ModalRoute.of(context);
    _routes = [?route];
    var navigator = context.findAncestorStateOfType<NavigatorState>();
    while (navigator != null) {
      final parentRoute = ModalRoute.of(navigator.context);
      if (parentRoute != null) _routes.add(parentRoute);
      navigator = navigator.context.findAncestorStateOfType<NavigatorState>();
    }
  }

  @override
  void dispose() {
    _controller?._targets.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        if (_refreshing) const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
      ],
    );
  }
}
