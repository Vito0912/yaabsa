import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';

typedef StringChipListInputValidator = String? Function(String value);
typedef StringChipListInputNormalizer = String Function(String value);

class ChipListInlineInput extends StatelessWidget {
  const ChipListInlineInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    this.style,
    this.minWidth = 90,
    this.maxWidth = 180,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final TextStyle? style;
  final double minWidth;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SizedBox(
        height: 24,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
          child: Align(
            alignment: Alignment.centerLeft,
            child: InlineTextField(
              controller: controller,
              style: style,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.done,
              hintText: hintText,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
        ),
      ),
    );
  }
}

class StringChipListInput extends StatefulWidget {
  const StringChipListInput({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.emptyStateText,
    this.suggestions = const <String>[],
    this.validator,
    this.normalizer,
    this.onTryAdd,
    this.chipLabelBuilder,
    this.onChipTap,
  });

  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final String? emptyStateText;
  final List<String> suggestions;
  final StringChipListInputValidator? validator;
  final StringChipListInputNormalizer? normalizer;
  final FutureOr<String?> Function(String value, List<String> currentValues)? onTryAdd;
  final String Function(String value)? chipLabelBuilder;
  final ValueChanged<String>? onChipTap;

  @override
  State<StringChipListInput> createState() => _StringChipListInputState();
}

class _StringChipListInputState extends State<StringChipListInput> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String? _validationError;

  Widget _buildInlineInput(BuildContext context) {
    return ChipListInlineInput(
      controller: _controller,
      style: Theme.of(context).textTheme.bodySmall,
      hintText: widget.hintText ?? 'Add value',
      onChanged: (value) {
        setState(() {
          _query = value;
          _validationError = null;
        });
      },
      onSubmitted: _addValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalizeValue(String value) {
    final trimmed = value.trim();
    final normalizer = widget.normalizer;
    if (normalizer == null) {
      return trimmed;
    }

    return normalizer(trimmed).trim();
  }

  bool _containsIgnoreCase(String candidate) {
    final normalizedCandidate = candidate.toLowerCase();
    for (final value in widget.values) {
      if (value.toLowerCase() == normalizedCandidate) {
        return true;
      }
    }
    return false;
  }

  void _addValue(String rawValue) async {
    if (!widget.enabled) {
      return;
    }

    var valueToAdd = _normalizeValue(rawValue);
    if (valueToAdd.isEmpty) {
      setState(() {
        _validationError = null;
      });
      return;
    }

    final validator = widget.validator;
    if (validator != null) {
      final validationMessage = validator(valueToAdd);
      if (validationMessage != null && validationMessage.trim().isNotEmpty) {
        setState(() {
          _validationError = validationMessage.trim();
        });
        return;
      }
    }

    final onTryAdd = widget.onTryAdd;
    if (onTryAdd != null) {
      final customValue = await onTryAdd(valueToAdd, widget.values);
      if (!mounted || customValue == null) {
        return;
      }

      valueToAdd = _normalizeValue(customValue);
      if (valueToAdd.isEmpty) {
        return;
      }

      if (validator != null) {
        final validationMessage = validator(valueToAdd);
        if (validationMessage != null && validationMessage.trim().isNotEmpty) {
          setState(() {
            _validationError = validationMessage.trim();
          });
          return;
        }
      }
    }

    if (_containsIgnoreCase(valueToAdd)) {
      _controller.clear();
      setState(() {
        _query = '';
        _validationError = null;
      });
      return;
    }

    widget.onChanged(<String>[...widget.values, valueToAdd]);
    _controller.clear();
    setState(() {
      _query = '';
      _validationError = null;
    });
  }

  void _removeValue(String value) {
    if (!widget.enabled) {
      return;
    }

    final loweredValue = value.toLowerCase();
    widget.onChanged(widget.values.where((entry) => entry.toLowerCase() != loweredValue).toList(growable: false));
  }

  @override
  Widget build(BuildContext context) {
    final showSuggestions = _query.trim().isNotEmpty;
    final filteredSuggestions = widget.suggestions
        .map((entry) => _normalizeValue(entry))
        .where((entry) => entry.isNotEmpty)
        .where((entry) => entry.toLowerCase().contains(_query.toLowerCase()))
        .where((entry) => !_containsIgnoreCase(entry))
        .toSet()
        .take(8)
        .toList(growable: false);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasInlineValue = _controller.text.trim().isNotEmpty;
    final hasEmptyState =
        widget.values.isEmpty &&
        !hasInlineValue &&
        widget.emptyStateText != null &&
        widget.emptyStateText!.trim().isNotEmpty;

    final decoration = yaabsaFieldDecoration(context, label: widget.label).copyWith(
      enabled: widget.enabled,
      helperText: widget.helperText,
      errorText: _validationError,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showSuggestions && filteredSuggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final suggestion in filteredSuggestions)
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    avatar: const Icon(Icons.add_rounded, size: 14),
                    label: Text(suggestion, style: theme.textTheme.bodySmall),
                    onPressed: widget.enabled ? () => _addValue(suggestion) : null,
                  ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        InputDecorator(
          decoration: decoration,
          isEmpty: widget.values.isEmpty && !hasInlineValue,
          isFocused: false,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (hasEmptyState)
                Text(
                  widget.emptyStateText!,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              for (final value in widget.values)
                InputChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  label: Text(widget.chipLabelBuilder?.call(value) ?? value, style: theme.textTheme.bodySmall),
                  onPressed: widget.onChipTap == null ? null : () => widget.onChipTap!(value),
                  onDeleted: widget.enabled ? () => _removeValue(value) : null,
                ),
              if (widget.enabled) _buildInlineInput(context),
            ],
          ),
        ),
      ],
    );
  }
}
