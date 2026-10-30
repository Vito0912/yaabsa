import 'package:material_ui/material_ui.dart';

class FeatureGate extends StatelessWidget {
  const FeatureGate({
    super.key,
    required this.enabled,
    required this.child,
    this.availability,
    this.disabledReason = 'This feature is unavailable',
  });

  final bool enabled;
  final Stream<bool>? availability;
  final String disabledReason;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final updates = availability;
    if (updates == null) {
      return _buildContent(enabled);
    }

    return StreamBuilder<bool>(
      stream: updates,
      initialData: enabled,
      builder: (context, snapshot) => _buildContent(snapshot.data ?? enabled),
    );
  }

  Widget _buildContent(bool available) {
    if (available) {
      return child;
    }

    return Tooltip(
      message: disabledReason,
      child: Semantics(
        enabled: false,
        child: AbsorbPointer(child: Opacity(opacity: 0.38, child: child)),
      ),
    );
  }
}
