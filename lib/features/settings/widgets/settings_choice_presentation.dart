import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/widgets/settings_segmented_presentation.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/inputs/search_field.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsChoicePresentation<T> extends StatelessWidget {
  const SettingsChoicePresentation({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.presentation = SettingsChoicePresentationMode.auto,
    this.description,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });

  final String label;
  final List<SettingsChoiceOption<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  final SettingsChoicePresentationMode presentation;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;

  SettingsChoicePresentationMode _resolveMode() {
    if (presentation != SettingsChoicePresentationMode.auto) {
      return presentation;
    }

    final hasDescriptions = options.any((option) => option.description != null && option.description!.isNotEmpty);
    final hasShortLabels = options.every((option) => option.label.length <= 18);

    if (options.length <= 3 && !hasDescriptions && hasShortLabels) {
      return SettingsChoicePresentationMode.segmented;
    }

    if (options.length <= 3) {
      return SettingsChoicePresentationMode.inlineRadio;
    }

    if (options.length > 8) {
      return SettingsChoicePresentationMode.searchableDialog;
    }

    return SettingsChoicePresentationMode.dialog;
  }

  T _resolveSafeValue() {
    for (final option in options) {
      if (option.value == value) {
        return option.value;
      }
    }

    return options.first.value;
  }

  String _currentOptionLabel(T safeValue) {
    for (final option in options) {
      if (option.value == safeValue) {
        return option.label;
      }
    }

    return options.first.label;
  }

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          context.l10n.errorDropdownConfiguration(label),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final safeValue = _resolveSafeValue();
    final isEnabled = enabled && onChanged != null;
    final resolvedMode = _resolveMode();

    switch (resolvedMode) {
      case SettingsChoicePresentationMode.segmented:
        return SettingsSegmentedPresentation<T>(
          label: label,
          options: options,
          value: safeValue,
          onChanged: onChanged,
          description: description,
          icon: icon,
          tooltip: tooltip,
          enabled: isEnabled,
        );
      case SettingsChoicePresentationMode.inlineRadio:
        return _buildInlineRadio(context, safeValue, isEnabled);
      case SettingsChoicePresentationMode.dialog:
      case SettingsChoicePresentationMode.searchableDialog:
      case SettingsChoicePresentationMode.auto:
        return _buildDialogTile(
          context,
          safeValue,
          isEnabled,
          searchable: resolvedMode == SettingsChoicePresentationMode.searchableDialog,
        );
    }
  }

  Widget _buildInlineRadio(BuildContext context, T safeValue, bool isEnabled) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RadioGroup<T>(
      groupValue: safeValue,
      onChanged: (nextValue) {
        if (isEnabled && nextValue != null) {
          onChanged?.call(nextValue);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SettingsControlLabel(
              label: label,
              description: description,
              enabled: isEnabled,
              icon: icon,
              tooltip: tooltip,
            ),
          ),
          for (final option in options)
            InkWell(
              onTap: isEnabled ? () => onChanged?.call(option.value) : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 32, right: 20, top: 12, bottom: 12),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 20,
                        color: isEnabled
                            ? (option.value == safeValue ? colorScheme.primary : colorScheme.onSurfaceVariant)
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.label,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isEnabled
                                  ? (option.value == safeValue ? colorScheme.primary : colorScheme.onSurface)
                                  : colorScheme.onSurface.withValues(alpha: 0.38),
                            ),
                          ),
                          if (option.description != null && option.description!.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              option.description!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isEnabled
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Radio<T>(value: option.value, activeColor: colorScheme.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDialogTile(BuildContext context, T safeValue, bool isEnabled, {required bool searchable}) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentLabel = _currentOptionLabel(safeValue);
    final summary = description != null && description!.isNotEmpty ? '$currentLabel\n$description' : currentLabel;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: SettingsControlLabel(label: label, description: summary, enabled: isEnabled, icon: icon, tooltip: tooltip),
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: colorScheme.onSurfaceVariant.withValues(alpha: isEnabled ? 0.6 : 0.38),
      ),
      onTap: isEnabled
          ? () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) {
                  return _SettingsChoiceDialog<T>(
                    title: label,
                    description: description,
                    options: options,
                    selectedValue: safeValue,
                    searchable: searchable,
                    onSelected: (nextValue) {
                      onChanged?.call(nextValue);
                      Navigator.of(dialogContext).pop();
                    },
                  );
                },
              );
            }
          : null,
    );
  }
}

class _SettingsChoiceDialog<T> extends StatefulWidget {
  const _SettingsChoiceDialog({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.searchable,
    required this.onSelected,
    this.description,
  });

  final String title;
  final String? description;
  final List<SettingsChoiceOption<T>> options;
  final T selectedValue;
  final bool searchable;
  final ValueChanged<T> onSelected;

  @override
  State<_SettingsChoiceDialog<T>> createState() => _SettingsChoiceDialogState<T>();
}

class _SettingsChoiceDialogState<T> extends State<_SettingsChoiceDialog<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;
    final normalizedQuery = _query.trim().toLowerCase();

    final filteredOptions = normalizedQuery.isEmpty
        ? widget.options
        : widget.options
              .where((option) {
                final matchesLabel = option.label.toLowerCase().contains(normalizedQuery);
                final matchesDescription = (option.description ?? '').toLowerCase().contains(normalizedQuery);
                return matchesLabel || matchesDescription;
              })
              .toList(growable: false);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SizedBox(
          width: 440,
          child: RadioGroup<T>(
            groupValue: widget.selectedValue,
            onChanged: (nextValue) {
              if (nextValue != null) {
                widget.onSelected(nextValue);
              }
            },
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
                            _buildDialogOptionTile(theme, colorScheme, filteredOptions[index]),
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
      ),
      actions: [
        YaabsaButton(
          variant: YaabsaButtonVariant.text,
          onPressed: () => Navigator.of(context).pop(),
          label: Text(l10n.actionCancel),
        ),
      ],
    );
  }

  Widget _buildDialogOptionTile(ThemeData theme, ColorScheme colorScheme, SettingsChoiceOption<T> option) {
    final isSelected = option.value == widget.selectedValue;
    final hasDescription = option.description != null && option.description!.isNotEmpty;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: option.icon != null
          ? Icon(option.icon, color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant)
          : null,
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
      trailing: Radio<T>(value: option.value, activeColor: colorScheme.primary),
      onTap: () => widget.onSelected(option.value),
    );
  }
}
