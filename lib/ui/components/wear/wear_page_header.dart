import 'dart:async';

import 'package:material_ui/material_ui.dart';

class WearActiveScope extends InheritedWidget {
  const WearActiveScope({required this.active, required super.child, super.key});

  final bool active;

  static bool isActive(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WearActiveScope>()?.active ?? true;
  }

  @override
  bool updateShouldNotify(WearActiveScope oldWidget) => active != oldWidget.active;
}

class WearPageHeader extends StatelessWidget {
  const WearPageHeader({this.title, this.subtitle, this.nowOverride, super.key});

  final String? title;
  final String? subtitle;
  final DateTime? nowOverride;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
        children: [
          WearTimeText(nowOverride: nowOverride),
          if (title != null) ...[
            const SizedBox(height: 10),
            Semantics(
              header: true,
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, height: 1.15, fontWeight: FontWeight.w700, color: colors.onSurface),
              ),
            ),
          ],
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.2, color: colors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class WearTimeText extends StatefulWidget {
  const WearTimeText({this.nowOverride, super.key});

  final DateTime? nowOverride;

  @override
  State<WearTimeText> createState() => _WearTimeTextState();
}

class _WearTimeTextState extends State<WearTimeText> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = widget.nowOverride ?? DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    _timer = null;
    if (widget.nowOverride != null) {
      _now = widget.nowOverride!;
      return;
    }

    _now = DateTime.now();
    final active = WearActiveScope.isActive(context) && (ModalRoute.isCurrentOf(context) ?? true);
    if (active) {
      _scheduleUpdate();
    }
  }

  void _scheduleUpdate() {
    final now = DateTime.now();
    final nextMinute = DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
    _timer = Timer(nextMinute.difference(now), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _now = DateTime.now();
      });
      _scheduleUpdate();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(_now).format(context);
    return Text(
      time,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        height: 1.1,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        decoration: TextDecoration.none,
      ),
    );
  }
}
