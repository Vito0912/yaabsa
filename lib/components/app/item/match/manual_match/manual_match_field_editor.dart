import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_description_field.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/inputs/string_chip_list_input.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';
import 'package:yaabsa/util/l10n.dart';

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
    final currentLabel = (currentValue?.trim().isNotEmpty ?? false) ? currentValue!.trim() : context.l10n.statusNotSet;

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
                  _buildValueEditor(context),
                  if (field != ManualMatchField.cover) ...[
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.matchCurrentValueSummary(currentLabel),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
      return _buildChipsEditor(context);
    }
    if (_isMultilineField) {
      return _buildDescriptionEditor(context);
    }
    return _buildCompactTextInput(context);
  }

  Widget _buildCompactTextInput(BuildContext context) {
    final readOnly = field == ManualMatchField.cover;

    return StyledTextField(
      controller: textController,
      enabled: !saving,
      readOnly: readOnly,
      maxLines: 1,
      onChanged: readOnly ? null : onTextChanged,
      label: _fieldLabel(context, field),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  Widget _buildDescriptionEditor(BuildContext context) {
    return ManualMatchDescriptionField(
      label: _fieldLabel(context, field),
      textController: textController,
      saving: saving,
      onChanged: onTextChanged,
    );
  }

  Widget _buildChipsEditor(BuildContext context) {
    final values = extractStringList(textController?.text);
    return StringChipListInput(
      label: _fieldLabel(context, field),
      values: values,
      onChanged: (nextValues) {
        final serialized = nextValues.join(', ');
        if (textController != null && textController!.text != serialized) {
          textController!.text = serialized;
        }
        onTextChanged(serialized);
      },
      hintText: context.l10n.hintAddValue,
    );
  }

  Widget _buildBooleanInput(BuildContext context) {
    return YaabsaDropdownField<bool>(
      key: ValueKey<bool?>(boolValue),
      value: boolValue,
      onChanged: saving ? null : onBoolChanged,
      label: _fieldLabel(context, field),
      enabled: !saving,
      items: [
        DropdownMenuItem(value: true, child: Text(context.l10n.optionYes)),
        DropdownMenuItem(value: false, child: Text(context.l10n.optionNo)),
      ],
    );
  }

  Widget _buildListModeSelector(BuildContext context) {
    return SizedBox(
      width: 180,
      child: YaabsaDropdownField<ManualListApplyMode>(
        label: context.l10n.fieldMode,
        value: listMode,
        enabled: !saving,
        items: [
          for (final mode in ManualListApplyMode.values)
            DropdownMenuItem(value: mode, child: Text(_listModeLabel(context, mode))),
        ],
        onChanged: (value) {
          if (value == null) {
            return;
          }
          onListModeChanged(value);
        },
      ),
    );
  }

  Widget _buildCoverComparison(BuildContext context) {
    final newCoverUrl = textController?.text.trim() ?? '';

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _CoverPreviewCard(label: context.l10n.fieldCurrentCover, child: buildCurrentCoverPreview()),
        _CoverPreviewCard(label: context.l10n.fieldSelectedCover, child: _buildNewCoverPreview(context, newCoverUrl)),
      ],
    );
  }

  Widget _buildNewCoverPreview(BuildContext context, String coverUrl) {
    if (coverUrl.isEmpty) {
      return _coverFallback(context, icon: Icons.image_not_supported_rounded);
    }

    return YaabsaCoverImage(
      image: NetworkImage(coverUrl),
      width: 80,
      height: 80,
      borderRadius: BorderRadius.circular(8),
      placeholder: _coverFallback(context, icon: Icons.broken_image_rounded),
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

  String _fieldLabel(BuildContext context, ManualMatchField field) {
    final l10n = context.l10n;
    switch (field) {
      case ManualMatchField.cover:
        return l10n.fieldCoverImage;
      case ManualMatchField.title:
        return l10n.fieldTitle;
      case ManualMatchField.subtitle:
        return l10n.fieldSubtitle;
      case ManualMatchField.authors:
        return l10n.fieldAuthors;
      case ManualMatchField.narrators:
        return l10n.fieldNarrators;
      case ManualMatchField.description:
        return l10n.fieldDescription;
      case ManualMatchField.publisher:
        return l10n.fieldPublisher;
      case ManualMatchField.publishedYear:
        return l10n.fieldPublishedYear;
      case ManualMatchField.series:
        return l10n.fieldSeries;
      case ManualMatchField.genres:
        return l10n.fieldGenres;
      case ManualMatchField.tags:
        return l10n.fieldTags;
      case ManualMatchField.language:
        return l10n.fieldLanguage;
      case ManualMatchField.isbn:
        return l10n.fieldIsbn;
      case ManualMatchField.asin:
        return l10n.fieldAsin;
      case ManualMatchField.explicit:
        return l10n.fieldExplicit;
      case ManualMatchField.abridged:
        return l10n.fieldAbridged;
    }
  }

  String _listModeLabel(BuildContext context, ManualListApplyMode mode) {
    switch (mode) {
      case ManualListApplyMode.overwrite:
        return context.l10n.optionOverwrite;
      case ManualListApplyMode.add:
        return context.l10n.optionAddToCurrent;
    }
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
