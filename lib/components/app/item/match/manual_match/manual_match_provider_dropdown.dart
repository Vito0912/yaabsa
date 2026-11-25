import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/l10n.dart';

class ManualMatchProviderDropdown extends StatelessWidget {
  const ManualMatchProviderDropdown({
    super.key,
    required this.providers,
    required this.selectedProviderValues,
    required this.onSelectionChanged,
    this.enabled = true,
    this.labelText,
  });

  final List<SearchProviderOption> providers;
  final Set<String> selectedProviderValues;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool enabled;
  final String? labelText;

  String _selectedLabel(BuildContext context) {
    if (selectedProviderValues.isEmpty) {
      return context.l10n.actionSelectProviders;
    }

    final selectedTexts = providers
        .where((provider) => selectedProviderValues.contains(provider.value))
        .map((provider) => provider.text)
        .toList(growable: false);
    if (selectedTexts.isEmpty) {
      return context.l10n.actionSelectProviders;
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
        decoration: yaabsaFieldDecoration(
          context,
          label: labelText ?? context.l10n.fieldMetadataProviders,
        ).copyWith(suffixIcon: const Icon(Icons.arrow_drop_down_rounded), enabled: enabled),
        child: Text(
          _selectedLabel(context),
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
          child: SafeArea(
            top: false,
            child: _ProviderSelectionSheet(providers: providers, selectedProviderValues: selectedProviderValues),
          ),
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
          title: Text(context.l10n.actionSelectProviders),
          trailing: IconButton(
            tooltip: context.l10n.actionClose,
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
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(Set<String>.from(_selected)),
                child: Text(context.l10n.actionApply),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
