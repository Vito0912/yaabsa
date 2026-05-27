import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';

typedef StringChipListInputValidator = String? Function(String value);
typedef StringChipListInputNormalizer = String Function(String value);

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

  @override
  State<StringChipListInput> createState() => _StringChipListInputState();
}

class _StringChipListInputState extends State<StringChipListInput> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String? _validationError;

  Widget _buildInlineInput(BuildContext context) {
    return IntrinsicWidth(
      child: SizedBox(
        height: 32,
        child: Align(
          alignment: Alignment.centerLeft,
          child: InlineTextField(
            controller: _controller,
            style: Theme.of(context).textTheme.bodySmall,
            hintText: widget.hintText ?? 'Add value',
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              setState(() {
                _query = value;
                _validationError = null;
              });
            },
            onSubmitted: _addValue,
          ),
        ),
      ),
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

  void _addValue(String rawValue) {
    if (!widget.enabled) {
      return;
    }

    final normalizedValue = _normalizeValue(rawValue);
    if (normalizedValue.isEmpty) {
      setState(() {
        _validationError = null;
      });
      return;
    }

    final validator = widget.validator;
    if (validator != null) {
      final validationMessage = validator(normalizedValue);
      if (validationMessage != null && validationMessage.trim().isNotEmpty) {
        setState(() {
          _validationError = validationMessage.trim();
        });
        return;
      }
    }

    if (_containsIgnoreCase(normalizedValue)) {
      _controller.clear();
      setState(() {
        _query = '';
        _validationError = null;
      });
      return;
    }

    widget.onChanged(<String>[...widget.values, normalizedValue]);
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
    final colorScheme = Theme.of(context).colorScheme;

    final showSuggestions = _query.trim().isNotEmpty;
    final filteredSuggestions = widget.suggestions
        .map((entry) => _normalizeValue(entry))
        .where((entry) => entry.isNotEmpty)
        .where((entry) => entry.toLowerCase().contains(_query.toLowerCase()))
        .where((entry) => !_containsIgnoreCase(entry))
        .toSet()
        .take(8)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleSmall),
        if (widget.helperText != null && widget.helperText!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.helperText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        if (showSuggestions && filteredSuggestions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final suggestion in filteredSuggestions)
                  ActionChip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    avatar: const Icon(Icons.add_rounded, size: 14),
                    label: Text(suggestion, style: Theme.of(context).textTheme.bodySmall),
                    onPressed: widget.enabled ? () => _addValue(suggestion) : null,
                  ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.38)),
          ),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final value in widget.values)
                InputChip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide.none,
                  label: Text(value, style: Theme.of(context).textTheme.bodySmall),
                  onDeleted: widget.enabled ? () => _removeValue(value) : null,
                ),
              if (widget.enabled) _buildInlineInput(context),
            ],
          ),
        ),
        if (_validationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 2),
            child: Text(
              _validationError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ),
      ],
    );
  }
}
