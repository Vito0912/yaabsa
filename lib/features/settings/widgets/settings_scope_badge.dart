import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsScopeBadge extends StatelessWidget {
  const SettingsScopeBadge({super.key, required this.scope});

  final SettingScope scope;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    final (label, background, foreground) = switch (scope) {
      SettingScope.app => (l10n.settingsScopeApp, colorScheme.surfaceContainerHigh, colorScheme.onSurfaceVariant),
      SettingScope.account => (
        l10n.settingsScopeAccount,
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
      ),
      SettingScope.server => (l10n.settingsScopeServer, colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: foreground, fontWeight: FontWeight.w600),
      ),
    );
  }
}
