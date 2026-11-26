import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsMultiChoicePresentation<T> extends StatelessWidget {
  const SettingsMultiChoicePresentation({
    super.key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.description,
    this.icon,
    this.tooltip,
    this.emptyLabel,
    this.searchable,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final List<SettingsChoiceOption<T>> options;
  final Iterable<T> selectedValues;
  final ValueChanged<Set<T>>? onChanged;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final String? emptyLabel;
  final bool? searchable;
  final bool enabled;
  final bool isLoading;

  String _summaryText(BuildContext context, Set<T> selectedSet) {
    final l10n = context.l10n;
    if (options.isEmpty) {
      return emptyLabel ?? l10n.statusNoneSelected;
    }

    final selectedLabels = <String>[];
    for (final option in options) {
      if (selectedSet.contains(option.value)) {
        selectedLabels.add(option.label);
      }
    }

    return switch (selectedLabels.length) {
      0 => l10n.statusNoneSelected,
      1 => selectedLabels.single,
      _ => l10n.selectedCount(selectedLabels.length),
    };
  }

  String _combinedDescription(BuildContext context, Set<T> selectedSet) {
    final summary = _summaryText(context, selectedSet);
    if (description != null && description!.isNotEmpty) {
      return '$summary\n$description';
    }

    return summary;
  }

  Future<void> _showDialog(BuildContext context, Set<T> initialSelection) {
    final isSearchable = searchable ?? (options.length > 8);

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return _SettingsMultiChoiceDialog<T>(
          title: label,
          description: description,
          options: options,
          initialSelection: initialSelection,
          searchable: isSearchable,
          onSaved: (nextSelection) {
            onChanged?.call(nextSelection);
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedSet = selectedValues.toSet();
    final isEnabled = enabled && onChanged != null && !isLoading && options.isNotEmpty;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: SettingsControlLabel(
        label: label,
        description: _combinedDescription(context, selectedSet),
        enabled: isEnabled,
        icon: icon,
        tooltip: tooltip,
      ),
      trailing: isLoading
          ? const SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5))
          : Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant.withValues(alpha: isEnabled ? 0.6 : 0.38),
            ),
      onTap: isEnabled ? () => _showDialog(context, selectedSet) : null,
    );
  }
}

class _SettingsMultiChoiceDialog<T> extends StatefulWidget {
  const _SettingsMultiChoiceDialog({
    required this.title,
    required this.options,
    required this.initialSelection,
    required this.searchable,
    required this.onSaved,
    this.description,
  });

  final String title;
  final String? description;
  final List<SettingsChoiceOption<T>> options;
  final Set<T> initialSelection;
  final bool searchable;
  final ValueChanged<Set<T>> onSaved;

  @override
  State<_SettingsMultiChoiceDialog<T>> createState() => _SettingsMultiChoiceDialogState<T>();
}

class _SettingsMultiChoiceDialogState<T> extends State<_SettingsMultiChoiceDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  late Set<T> _pendingSelection;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _pendingSelection = Set<T>.from(widget.initialSelection);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SettingsChoiceOption<T>> _filterOptions() {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return widget.options;
    }

    return widget.options
        .where((option) {
          final matchesLabel = option.label.toLowerCase().contains(normalizedQuery);
          final matchesDescription = (option.description ?? '').toLowerCase().contains(normalizedQuery);
          return matchesLabel || matchesDescription;
        })
        .toList(growable: false);
  }

  void _toggleOption(T value, bool isSelected) {
    setState(() {
      if (isSelected) {
        _pendingSelection.add(value);
      } else {
        _pendingSelection.remove(value);
      }
    });
  }

  Set<T> _orderedSelection() {
    final ordered = <T>{};
    for (final option in widget.options) {
      if (_pendingSelection.contains(option.value)) {
        ordered.add(option.value);
      }
    }

    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final filteredOptions = _filterOptions();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.description != null && widget.description!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
                  child: Text(
                    widget.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
              if (widget.searchable) ...[
                YaabsaSearchField(
                  controller: _searchController,
                  hintText: l10n.settingsSearchHint,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  onClear: () {
                    _searchController.clear();
                    setState(() {
                      _query = '';
                    });
                  },
                ),
                const SizedBox(height: 12),
              ],
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (filteredOptions.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l10n.searchNoResultsFor(_query.trim()),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        )
                      else
                        for (var index = 0; index < filteredOptions.length; index++) ...[
                          _buildOptionTile(theme, colorScheme, filteredOptions[index]),
                          if (index < filteredOptions.length - 1) const Divider(height: 8, thickness: 0.5),
                        ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        YaabsaButton(
          variant: YaabsaButtonVariant.text,
          onPressed: () => Navigator.of(context).pop(),
          label: Text(l10n.actionCancel),
        ),
        YaabsaButton(
          variant: YaabsaButtonVariant.filled,
          onPressed: () => widget.onSaved(_orderedSelection()),
          label: Text(l10n.actionDone),
        ),
      ],
    );
  }

  Widget _buildOptionTile(ThemeData theme, ColorScheme colorScheme, SettingsChoiceOption<T> option) {
    final isSelected = _pendingSelection.contains(option.value);
    final hasDescription = option.description != null && option.description!.isNotEmpty;

    return CheckboxListTile(
      value: isSelected,
      onChanged: (nextSelected) => _toggleOption(option.value, nextSelected ?? false),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      controlAffinity: ListTileControlAffinity.trailing,
      secondary: option.icon != null ? Icon(option.icon, color: colorScheme.onSurfaceVariant) : null,
      title: Text(
        option.label,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      subtitle: hasDescription
          ? Text(option.description!, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant))
          : null,
    );
  }
}
