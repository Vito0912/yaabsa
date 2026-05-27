import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_inputs.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_description_field.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';

class ManualMatchFieldEditor extends StatelessWidget {
  const ManualMatchFieldEditor({
    super.key,
    required this.field,
    required this.enabled,
    required this.saving,
    required this.currentValue,
    required this.textController,
    required this.boolValue,
    required this.listMode,
    required this.onToggleField,
    required this.onTextChanged,
    required this.onBoolChanged,
    required this.onListModeChanged,
    required this.buildCurrentCoverPreview,
  });

  final ManualMatchField field;
  final bool enabled;
  final bool saving;
  final String? currentValue;
  final TextEditingController? textController;
  final bool? boolValue;
  final ManualListApplyMode listMode;
  final ValueChanged<bool> onToggleField;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<bool?> onBoolChanged;
  final ValueChanged<ManualListApplyMode> onListModeChanged;
  final Widget Function() buildCurrentCoverPreview;

  bool get _isBooleanField => field == ManualMatchField.explicit || field == ManualMatchField.abridged;

  bool get _isMultilineField => field == ManualMatchField.description;

  bool get _usesChipsEditor => field == ManualMatchField.tags || field == ManualMatchField.genres;

  @override
  Widget build(BuildContext context) {
    final currentLabel = (currentValue?.trim().isNotEmpty ?? false) ? currentValue!.trim() : 'Not set';
    final showHeadingInRow = !_usesChipsEditor && !_isMultilineField;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Checkbox(
              value: enabled,
              visualDensity: VisualDensity.compact,
              onChanged: saving ? null : (value) => onToggleField(value ?? false),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeadingInRow)
                    Text(
                      field.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  if (showHeadingInRow) const SizedBox(height: 4),
                  _buildValueEditor(context),
                  if (field != ManualMatchField.cover) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Current: $currentLabel',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                  if (field == ManualMatchField.cover) ...[const SizedBox(height: 6), _buildCoverComparison(context)],
                  if (manualListFields.contains(field) && enabled) ...[
                    const SizedBox(height: 4),
                    _buildListModeSelector(context),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueEditor(BuildContext context) {
    if (_isBooleanField) {
      return _buildBooleanInput(context);
    }
    if (_usesChipsEditor) {
      return _buildChipsEditor();
    }
    if (_isMultilineField) {
      return _buildDescriptionEditor();
    }
    return _buildCompactTextInput();
  }

  Widget _buildCompactTextInput() {
    final readOnly = field == ManualMatchField.cover;

    return TextField(
      controller: textController,
      enabled: !saving,
      readOnly: readOnly,
      minLines: 1,
      maxLines: 1,
      onChanged: readOnly ? null : onTextChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
    );
  }

  Widget _buildDescriptionEditor() {
    return ManualMatchDescriptionField(
      label: field.label,
      textController: textController,
      saving: saving,
      onChanged: onTextChanged,
    );
  }

  Widget _buildChipsEditor() {
    final values = extractStringList(textController?.text);
    return LibraryItemEditorStringChips(
      label: field.label,
      values: values,
      onChanged: (nextValues) {
        final serialized = nextValues.join(', ');
        if (textController != null && textController!.text != serialized) {
          textController!.text = serialized;
        }
        onTextChanged(serialized);
      },
      hintText: 'Add value',
    );
  }

  Widget _buildBooleanInput(BuildContext context) {
    return YaabsaExpressiveDropdownField<bool>(
      key: ValueKey<bool?>(boolValue),
      value: boolValue,
      onChanged: saving ? null : onBoolChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      options: const [
        YaabsaDropdownOption<bool>(value: true, label: 'Yes'),
        YaabsaDropdownOption<bool>(value: false, label: 'No'),
      ],
    );
  }

  Widget _buildListModeSelector(BuildContext context) {
    return Row(
      children: [
        Text(
          'Mode:',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 180,
          child: YaabsaExpressiveDropdown<ManualListApplyMode>(
            value: listMode,
            enabled: !saving,
            options: ManualListApplyMode.values
                .map((mode) => YaabsaDropdownOption<ManualListApplyMode>(value: mode, label: mode.label))
                .toList(growable: false),
            onChanged: (value) {
              if (value == null) {
                return;
              }
              onListModeChanged(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCoverComparison(BuildContext context) {
    final newCoverUrl = textController?.text.trim() ?? '';

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _CoverPreviewCard(label: 'Current cover', child: buildCurrentCoverPreview()),
        _CoverPreviewCard(label: 'Selected cover', child: _buildNewCoverPreview(context, newCoverUrl)),
      ],
    );
  }

  Widget _buildNewCoverPreview(BuildContext context, String coverUrl) {
    if (coverUrl.isEmpty) {
      return _coverFallback(context, icon: Icons.image_not_supported_rounded);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Image.network(
          coverUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _coverFallback(context, icon: Icons.broken_image_rounded),
        ),
      ),
    );
  }

  Widget _coverFallback(BuildContext context, {required IconData icon}) {
    return Container(
      width: 80,
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _CoverPreviewCard extends StatelessWidget {
  const _CoverPreviewCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
