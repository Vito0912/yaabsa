import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/util/l10n.dart';

class SignInAdvancedOptions extends StatelessWidget {
  const SignInAdvancedOptions({
    super.key,
    required this.isExpanded,
    required this.onExpandedChanged,
    required this.isLoading,
    required this.allowsApiKey,
    required this.useApiKey,
    required this.onUseApiKeyChanged,
    required this.onImportMagicConfig,
    required this.customHeaders,
    required this.onAddHeader,
    required this.onEditHeader,
    required this.onRemoveHeader,
  });

  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;
  final bool isLoading;
  final bool allowsApiKey;
  final bool useApiKey;
  final ValueChanged<bool> onUseApiKeyChanged;
  final VoidCallback onImportMagicConfig;
  final Map<String, String> customHeaders;
  final VoidCallback onAddHeader;
  final ValueChanged<String> onEditHeader;
  final ValueChanged<String> onRemoveHeader;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: isLoading ? null : () => onExpandedChanged(!isExpanded),
          icon: Icon(isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
          label: Text(context.l10n.headingAdvancedOptions),
        ),
        if (isExpanded)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surfaceContainerLow,
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (allowsApiKey)
                    YaabsaSwitchTile.adaptive(
                      value: useApiKey,
                      contentPadding: EdgeInsets.zero,
                      onChanged: isLoading ? null : onUseApiKeyChanged,
                      title: Text(context.l10n.authUseApiKey),
                      subtitle: Text(context.l10n.authApiKeyHelp),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              context.l10n.headingCustomHeaders,
                              style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: isLoading ? null : onAddHeader,
                              icon: const Icon(Icons.add_rounded),
                              label: Text(context.l10n.actionAdd),
                            ),
                          ],
                        ),
                        if (customHeaders.isEmpty)
                          Text(
                            context.l10n.statusNoCustomHeadersConfigured,
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                          )
                        else
                          ...customHeaders.entries.map((entry) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text(entry.key, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text(entry.value, maxLines: 1, overflow: TextOverflow.ellipsis),
                              trailing: Wrap(
                                spacing: 4,
                                children: [
                                  YaabsaActionIconButton(
                                    icon: Icons.edit_outlined,
                                    tooltip: context.l10n.actionEdit,
                                    onPressed: isLoading ? null : () => onEditHeader(entry.key),
                                    iconSize: 24,
                                    buttonSize: 48,
                                    compact: false,
                                    variant: YaabsaActionButtonVariant.outlined,
                                    shape: YaabsaActionButtonShape.rounded,
                                  ),
                                  YaabsaDeleteIconButton(
                                    tooltip: context.l10n.actionRemove,
                                    onPressed: isLoading ? null : () => onRemoveHeader(entry.key),
                                    iconSize: 24,
                                    buttonSize: 48,
                                    compact: false,
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : onImportMagicConfig,
                      icon: const Icon(Icons.qr_code_2_rounded),
                      label: Text(context.l10n.actionImport),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
