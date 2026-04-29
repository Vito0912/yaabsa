import 'package:flutter/material.dart';

class SignInAdvancedOptions extends StatelessWidget {
  const SignInAdvancedOptions({
    super.key,
    required this.isExpanded,
    required this.onExpandedChanged,
    required this.isLoading,
    required this.allowsApiKey,
    required this.useApiKey,
    required this.onUseApiKeyChanged,
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
          label: const Text('Advanced Options'),
        ),
        if (isExpanded)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surfaceContainerLow,
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (allowsApiKey)
                  SwitchListTile.adaptive(
                    value: useApiKey,
                    contentPadding: EdgeInsets.zero,
                    onChanged: isLoading ? null : onUseApiKeyChanged,
                    title: const Text('Use API Key'),
                    subtitle: const Text('Authenticate with a generated API key instead of username/password.'),
                  ),
                Row(
                  children: [
                    Text('Custom Headers', style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: isLoading ? null : onAddHeader,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Header'),
                    ),
                  ],
                ),
                if (customHeaders.isEmpty)
                  Text(
                    'No custom headers configured.',
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
                        spacing: 0,
                        children: [
                          IconButton(
                            tooltip: 'Edit header',
                            onPressed: isLoading ? null : () => onEditHeader(entry.key),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: 'Remove header',
                            onPressed: isLoading ? null : () => onRemoveHeader(entry.key),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
      ],
    );
  }
}
