import 'dart:convert';

import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';

class ManualMatchLastConfiguration {
  const ManualMatchLastConfiguration({required this.enabledFields, required this.listModes});

  final Set<ManualMatchField> enabledFields;
  final Map<ManualMatchField, ManualListApplyMode> listModes;

  static ManualMatchLastConfiguration? _current;

  static ManualMatchLastConfiguration? get current => _current;

  String toRawSettingValue() {
    final payload = <String, dynamic>{
      'enabledFields': enabledFields.map((field) => field.name).toList(growable: false),
      'listModes': <String, String>{for (final entry in listModes.entries) entry.key.name: entry.value.name},
    };
    return jsonEncode(payload);
  }

  static void restoreFromRawSettingValue(String? rawSettingValue) {
    _current = fromRawSettingValue(rawSettingValue);
  }

  static ManualMatchLastConfiguration? fromRawSettingValue(String? rawSettingValue) {
    final source = rawSettingValue?.trim();
    if (source == null || source.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map) {
        return null;
      }

      final map = Map<String, dynamic>.from(decoded);
      final rawEnabledFields = map['enabledFields'];
      final rawListModes = map['listModes'];

      final enabledFields = <ManualMatchField>{};
      if (rawEnabledFields is List) {
        for (final entry in rawEnabledFields) {
          final field = _fieldFromName(entry?.toString());
          if (field != null) {
            enabledFields.add(field);
          }
        }
      }

      final listModes = <ManualMatchField, ManualListApplyMode>{};
      if (rawListModes is Map) {
        for (final entry in rawListModes.entries) {
          final field = _fieldFromName(entry.key.toString());
          final mode = _modeFromName(entry.value?.toString());
          if (field != null && mode != null) {
            listModes[field] = mode;
          }
        }
      }

      if (enabledFields.isEmpty && listModes.isEmpty) {
        return null;
      }

      return ManualMatchLastConfiguration(enabledFields: enabledFields, listModes: listModes);
    } catch (_) {
      return null;
    }
  }

  static void save({
    required Set<ManualMatchField> enabledFields,
    required Map<ManualMatchField, ManualListApplyMode> listModes,
  }) {
    _current = ManualMatchLastConfiguration(
      enabledFields: Set<ManualMatchField>.from(enabledFields),
      listModes: Map<ManualMatchField, ManualListApplyMode>.from(listModes),
    );
  }

  static ManualMatchField? _fieldFromName(String? value) {
    final fieldName = value?.trim();
    if (fieldName == null || fieldName.isEmpty) {
      return null;
    }

    for (final field in ManualMatchField.values) {
      if (field.name == fieldName) {
        return field;
      }
    }
    return null;
  }

  static ManualListApplyMode? _modeFromName(String? value) {
    final modeName = value?.trim();
    if (modeName == null || modeName.isEmpty) {
      return null;
    }

    for (final mode in ManualListApplyMode.values) {
      if (mode.name == modeName) {
        return mode;
      }
    }
    return null;
  }
}
