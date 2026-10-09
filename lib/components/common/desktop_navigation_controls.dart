import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/desktop_page_shortcuts.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/desktop_navigation_history.dart';
import 'package:yaabsa/util/logger.dart';

class DesktopNavigationControls extends ConsumerStatefulWidget {
  const DesktopNavigationControls({super.key, required this.router, required this.history, required this.child});

  final GoRouter router;
  final DesktopNavigationHistory history;
  final Widget child;

  @override
  ConsumerState<DesktopNavigationControls> createState() => _DesktopNavigationControlsState();
}

class _DesktopNavigationControlsState extends ConsumerState<DesktopNavigationControls> {
  final Map<int, int> _mouseButtons = {};
  final DesktopShortcutController _shortcuts = DesktopShortcutController();

  bool get _enabled =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  @override
  void initState() {
    super.initState();
    if (_enabled) {
      widget.history.attach(widget.router);
      HardwareKeyboard.instance.addHandler(_handleKeyEvent);
    }
  }

  @override
  void dispose() {
    if (_enabled) {
      HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
      widget.history.detach();
    }
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent || event.synthesized) return false;
    final keyboard = HardwareKeyboard.instance;
    final key = event.logicalKey;
    final isMac = defaultTargetPlatform == TargetPlatform.macOS;
    final commandModifier = isMac
        ? keyboard.isMetaPressed && !keyboard.isControlPressed
        : keyboard.isControlPressed && !keyboard.isMetaPressed;
    if (commandModifier && !keyboard.isAltPressed && !keyboard.isShiftPressed) {
      if (isMac && (key == LogicalKeyboardKey.bracketLeft || key == LogicalKeyboardKey.bracketRight)) {
        unawaited(_navigate(forward: key == LogicalKeyboardKey.bracketRight));
        return true;
      }
      if (widget.history.hasOverlay) return false;
      if (key == LogicalKeyboardKey.keyF) {
        return _shortcuts.invoke(DesktopPageCommand.search);
      }
      if (key == LogicalKeyboardKey.keyR && !_isTextInputFocused()) {
        return _shortcuts.invoke(DesktopPageCommand.refresh);
      }
      if (key == LogicalKeyboardKey.comma && ref.read(currentUserProvider).value != null) {
        unawaited(_openSettings());
        return true;
      }
    }
    if (keyboard.isControlPressed || keyboard.isMetaPressed || keyboard.isShiftPressed) return false;
    if (key == LogicalKeyboardKey.f5 && !isMac && !keyboard.isAltPressed && !widget.history.hasOverlay) {
      return !_isTextInputFocused() && _shortcuts.invoke(DesktopPageCommand.refresh);
    }
    if (key == LogicalKeyboardKey.browserBack ||
        key == LogicalKeyboardKey.goBack ||
        (keyboard.isAltPressed && key == LogicalKeyboardKey.arrowLeft)) {
      unawaited(_navigate(forward: false));
      return true;
    }
    if (key == LogicalKeyboardKey.browserForward || (keyboard.isAltPressed && key == LogicalKeyboardKey.arrowRight)) {
      unawaited(_navigate(forward: true));
      return true;
    }
    return false;
  }

  bool _isTextInputFocused() {
    final context = FocusManager.instance.primaryFocus?.context;
    final editable = context?.widget is EditableText
        ? context!.widget as EditableText
        : context?.findAncestorWidgetOfExactType<EditableText>();
    return editable != null && editable.textInputAction != TextInputAction.search;
  }

  Future<void> _openSettings() async {
    final configuration = widget.router.routerDelegate.currentConfiguration;
    if (configuration.isEmpty) return;
    final last = configuration.last;
    final uri = last is ImperativeRouteMatch ? last.matches.uri : configuration.uri;
    if (uri.path == '/' && uri.queryParameters['tab'] == 'settings') return;
    await widget.router.push<void>('/settings');
  }

  KeyEventResult _handleEscape(FocusNode node, KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape ||
        keyboard.isAltPressed ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    if (widget.history.hasOverlay) {
      if (!widget.history.canDismissOverlay) return KeyEventResult.ignored;
      unawaited(widget.history.dismissOverlay());
      return KeyEventResult.handled;
    }
    return _shortcuts.invoke(DesktopPageCommand.dismiss) ? KeyEventResult.handled : KeyEventResult.ignored;
  }

  void _handleMouseButtons(PointerEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    final previous = _mouseButtons[event.pointer] ?? 0;
    _mouseButtons[event.pointer] = event.buttons;
    final pressed = event.buttons & ~previous & (kBackMouseButton | kForwardMouseButton);
    if (pressed == kBackMouseButton) {
      unawaited(_navigate(forward: false));
    } else if (pressed == kForwardMouseButton) {
      unawaited(_navigate(forward: true));
    }
  }

  Future<void> _navigate({required bool forward}) async {
    try {
      if (forward) {
        await widget.history.forward();
      } else {
        await widget.history.back();
      }
    } catch (e, s) {
      logger('Desktop navigation failed: $e\n$s', tag: 'Navigation', level: InfoLevel.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;
    ref.listen(currentUserProvider.select((value) => value.value?.id), (previous, next) {
      if (previous != next) widget.history.clear();
    });
    return DesktopShortcutScope(
      controller: _shortcuts,
      child: Focus(
        autofocus: true,
        onKeyEvent: _handleEscape,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: _handleMouseButtons,
          onPointerMove: _handleMouseButtons,
          onPointerUp: (event) => _mouseButtons.remove(event.pointer),
          onPointerCancel: (event) => _mouseButtons.remove(event.pointer),
          child: widget.child,
        ),
      ),
    );
  }
}
