import 'package:flutter/material.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/util/globals.dart';

import 'package:yaabsa/generated/l10n.dart';

class ManualMatchProviderDropdown extends StatelessWidget {
  const ManualMatchProviderDropdown({
    super.key,
    required this.providers,
    required this.selectedProviderValues,
    required this.onSelectionChanged,
    this.enabled = true,
    this.labelText = 'Providers',
  });

  final List<SearchProviderOption> providers;
  final Set<String> selectedProviderValues;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool enabled;
  final String labelText;

  String _selectedLabel() {
    if (selectedProviderValues.isEmpty) {
      return 'Select providers';
    }

    final selectedTexts = providers
        .where((provider) => selectedProviderValues.contains(provider.value))
        .map((provider) => provider.text)
        .toList(growable: false);
    if (selectedTexts.isEmpty) {
      return 'Select providers';
    }

    return selectedTexts.join(', ');
  }

  Future<void> _openSelector(BuildContext context) async {
    if (!enabled) {
      return;
    }

    final selected = await _showProviderSelector(
      context: context,
      providers: providers,
      selectedProviderValues: selectedProviderValues,
    );

    if (selected == null) {
      return;
    }

    onSelectionChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: enabled ? () => _openSelector(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
          enabled: enabled,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          _selectedLabel(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

Future<Set<String>?> _showProviderSelector({
  required BuildContext context,
  required List<SearchProviderOption> providers,
  required Set<String> selectedProviderValues,
}) async {
  if (context.isMobile) {
    return showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: _ProviderSelectionSheet(providers: providers, selectedProviderValues: selectedProviderValues),
        );
      },
    );
  }

  return showDialog<Set<String>>(
    context: context,
    builder: (context) {
      return Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
          child: _ProviderSelectionSheet(providers: providers, selectedProviderValues: selectedProviderValues),
        ),
      );
    },
  );
}

class _ProviderSelectionSheet extends StatefulWidget {
  const _ProviderSelectionSheet({required this.providers, required this.selectedProviderValues});

  final List<SearchProviderOption> providers;
  final Set<String> selectedProviderValues;

  @override
  State<_ProviderSelectionSheet> createState() => _ProviderSelectionSheetState();
}

class _ProviderSelectionSheetState extends State<_ProviderSelectionSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set<String>.from(widget.selectedProviderValues);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(S.current.componentsAppItemMatchManualMatchManualMatchProviderDropdownSelectProviders),
          trailing: IconButton(
            tooltip: S.current.componentsAppItemMatchManualMatchManualMatchProviderDropdownClose,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: widget.providers.length,
            itemBuilder: (context, index) {
              final provider = widget.providers[index];
              final selected = _selected.contains(provider.value);
              return CheckboxListTile(
                value: selected,
                onChanged: (value) {
                  setState(() {
                    if (value ?? false) {
                      _selected.add(provider.value);
                    } else {
                      _selected.remove(provider.value);
                    }
                  });
                },
                title: Text(provider.text),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.current.componentsAppItemMatchManualMatchManualMatchProviderDropdownCancel),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(Set<String>.from(_selected)),
                child: Text(S.current.componentsAppItemMatchManualMatchManualMatchProviderDropdownApply),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
