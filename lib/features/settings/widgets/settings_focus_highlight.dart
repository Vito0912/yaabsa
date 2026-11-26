import 'dart:async';

import 'package:material_ui/material_ui.dart';

class SettingsFocusHighlight extends StatefulWidget {
  const SettingsFocusHighlight({super.key, required this.focused, this.focusToken, required this.child});

  final bool focused;
  final Object? focusToken;
  final Widget child;

  @override
  State<SettingsFocusHighlight> createState() => _SettingsFocusHighlightState();
}

class _SettingsFocusHighlightState extends State<SettingsFocusHighlight> {
  bool _pulseActive = false;
  Timer? _pulseTimer;

  @override
  void initState() {
    super.initState();
    if (widget.focused) {
      _triggerFocus();
    }
  }

  @override
  void didUpdateWidget(covariant SettingsFocusHighlight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focused && (!oldWidget.focused || widget.focusToken != oldWidget.focusToken)) {
      _triggerFocus();
    }
  }

  @override
  void dispose() {
    _pulseTimer?.cancel();
    super.dispose();
  }

  void _triggerFocus() {
    _pulseTimer?.cancel();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      await Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignment: 0.25,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _pulseActive = true;
      });

      _pulseTimer = Timer(const Duration(milliseconds: 1100), () {
        if (!mounted) {
          return;
        }

        setState(() {
          _pulseActive = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final highlightColor = Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.55);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      color: _pulseActive ? highlightColor : Colors.transparent,
      child: widget.child,
    );
  }
}
