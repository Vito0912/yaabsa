import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

enum SettingsControlLoadState { loading, error }

class SettingsControlStatusPresentation extends StatelessWidget {
  const SettingsControlStatusPresentation({super.key, required this.label, required this.state});

  final String label;
  final SettingsControlLoadState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: SettingsControlLabel(label: label, enabled: false)),
          const SizedBox(width: 20),
          if (state == SettingsControlLoadState.loading)
            const SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5))
          else
            Semantics(
              label: 'Unable to load $label',
              child: Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 22),
            ),
        ],
      ),
    );
  }
}
