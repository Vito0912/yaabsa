import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_field_editor.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';

import 'package:yaabsa/generated/l10n.dart';

class ManualMatchEditorPane extends StatelessWidget {
  const ManualMatchEditorPane({
    super.key,
    required this.selectedResult,
    required this.availableFields,
    required this.enabledFields,
    required this.allFieldsSelected,
    required this.listModes,
    required this.saving,
    required this.onToggleAll,
    required this.onToggleField,
    required this.onChangeListMode,
    required this.controllerForField,
    required this.boolValueForField,
    required this.onChangeFieldText,
    required this.onChangeBoolValue,
    required this.currentSummaryForField,
    required this.buildCurrentCoverPreview,
  });

  final ManualMatchResult? selectedResult;
  final List<ManualMatchField> availableFields;
  final Set<ManualMatchField> enabledFields;
  final bool allFieldsSelected;
  final Map<ManualMatchField, ManualListApplyMode> listModes;
  final bool saving;
  final ValueChanged<bool> onToggleAll;
  final void Function(ManualMatchField field, bool enabled) onToggleField;
  final void Function(ManualMatchField field, ManualListApplyMode mode) onChangeListMode;
  final TextEditingController? Function(ManualMatchField field) controllerForField;
  final bool? Function(ManualMatchField field) boolValueForField;
  final void Function(ManualMatchField field, String value) onChangeFieldText;
  final void Function(ManualMatchField field, bool? value) onChangeBoolValue;
  final String? Function(ManualMatchField field) currentSummaryForField;
  final Widget Function() buildCurrentCoverPreview;

  @override
  Widget build(BuildContext context) {
    if (selectedResult == null) {
      return Card(
        margin: EdgeInsets.zero,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              S.current.componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAMatchResultToChoose,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.edit_note_rounded),
            title: Text(S.current.componentsAppItemMatchManualMatchManualMatchEditorPaneApplyFields),
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          const Divider(height: 1),
          CheckboxListTile(
            value: allFieldsSelected,
            onChanged: saving ? null : (value) => onToggleAll(value ?? false),
            title: Text(S.current.componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAllAvailableFields),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: availableFields.length,
              itemBuilder: (context, index) {
                final field = availableFields[index];
                final enabled = enabledFields.contains(field);
                final currentValue = currentSummaryForField(field);

                return Column(
                  children: [
                    ManualMatchFieldEditor(
                      field: field,
                      enabled: enabled,
                      saving: saving,
                      currentValue: currentValue,
                      textController: controllerForField(field),
                      boolValue: boolValueForField(field),
                      listMode: listModes[field] ?? ManualListApplyMode.overwrite,
                      onToggleField: (value) => onToggleField(field, value),
                      onTextChanged: (value) => onChangeFieldText(field, value),
                      onBoolChanged: (value) => onChangeBoolValue(field, value),
                      onListModeChanged: (mode) => onChangeListMode(field, mode),
                      buildCurrentCoverPreview: buildCurrentCoverPreview,
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
