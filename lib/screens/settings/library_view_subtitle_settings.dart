import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_editor_header.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/library_view_subtitle_preferences.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryViewSubtitleSettings extends ConsumerWidget {
  const LibraryViewSubtitleSettings({super.key});

  static const String routeName = '/settings/library/view-subtitles';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: context.l10n.settingViewSubtitles,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(context.l10n.promptSignInToManageSettings),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final view in LibraryViewSubtitleView.values)
                  LibraryViewSubtitlePreferencesEditor(userId: user.id, view: view),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString())),
          ),
        ),
      ],
    );
  }
}

class LibraryViewSubtitlePreferencesEditor extends ConsumerStatefulWidget {
  const LibraryViewSubtitlePreferencesEditor({required this.userId, required this.view, super.key});

  final String userId;
  final LibraryViewSubtitleView view;

  @override
  ConsumerState<LibraryViewSubtitlePreferencesEditor> createState() => _LibraryViewSubtitlePreferencesEditorState();
}

class _LibraryViewSubtitlePreferencesEditorState extends ConsumerState<LibraryViewSubtitlePreferencesEditor> {
  bool _isSaving = false;

  Future<void> _persist(LibraryViewSubtitlePreferences preferences) async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(
            widget.userId,
            widget.view.settingKey,
            LibraryViewSubtitlePreferencesCodec.encode(preferences),
          );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.errorOperationFailed(
                context.l10n.operationSaveSubtitlesForView(widget.view.label),
                error.toString(),
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _reset() async {
    await _persist(LibraryViewSubtitlePreferencesCodec.defaultsFor(widget.view));
  }

  Future<void> _updateField(
    LibraryViewSubtitlePreferences preferences,
    LibraryViewSubtitleField field,
    bool? selected,
  ) async {
    if (selected == null) {
      return;
    }

    final nextFields = preferences.fields.toList();
    if (selected) {
      if (nextFields.length >= LibraryViewSubtitlePreferencesCodec.maxCustomFields) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.validationMaxSubtitleFields(LibraryViewSubtitlePreferencesCodec.maxCustomFields),
            ),
          ),
        );
        return;
      }
      nextFields.add(field);
    } else {
      nextFields.remove(field);
    }

    await _persist(LibraryViewSubtitlePreferences(mode: LibraryViewSubtitleMode.custom, fields: nextFields));
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);
    ref.watch(userSettingsWatcherProvider);
    final fallbackRawValue = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(
          widget.userId,
          widget.view.settingKey,
          defaultValue: LibraryViewSubtitlePreferencesCodec.defaultEncodedFor(widget.view),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsEditorHeader(title: widget.view.label, onReset: _isSaving ? null : _reset),
        StreamBuilder<UserSettingEntry?>(
          stream: appDatabase.watchUserSetting(widget.userId, widget.view.settingKey),
          builder: (context, snapshot) {
            final rawValue = snapshot.data?.value ?? fallbackRawValue;
            final preferences = LibraryViewSubtitlePreferencesCodec.decode(rawValue, widget.view);
            final fields = LibraryViewSubtitlePreferencesCodec.fieldsFor(widget.view);

            return SettingsNavigationSection(
              title: '',
              showSectionTitle: false,
              topPadding: 0,
              children: [
                Column(
                  children: [
                    SettingDropdown<LibraryViewSubtitleMode>.remote(
                      label: context.l10n.librarySubtitleChooseInfo(widget.view.label),
                      values: LibraryViewSubtitleMode.values,
                      valueLabels: [for (final mode in LibraryViewSubtitleMode.values) mode.label],
                      valueDescriptions: [for (final mode in LibraryViewSubtitleMode.values) mode.description],
                      value: preferences.mode,
                      enabled: !_isSaving,
                      isLoading: _isSaving,
                      onValueChanged: (value) =>
                          _persist(LibraryViewSubtitlePreferences(mode: value, fields: preferences.fields)),
                    ),
                    if (preferences.mode == LibraryViewSubtitleMode.custom) ...[
                      const Divider(height: 1),
                      _SubtitleFieldsSetting(
                        fields: fields,
                        selectedFields: preferences.fields,
                        enabled: !_isSaving,
                        onChanged: (field, selected) => _updateField(preferences, field, selected),
                      ),
                    ],
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SubtitleFieldsSetting extends StatelessWidget {
  const _SubtitleFieldsSetting({
    required this.fields,
    required this.selectedFields,
    required this.enabled,
    required this.onChanged,
  });

  final List<LibraryViewSubtitleField> fields;
  final List<LibraryViewSubtitleField> selectedFields;
  final bool enabled;
  final void Function(LibraryViewSubtitleField field, bool? selected) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final field in fields)
          CheckboxListTile(
            value: selectedFields.contains(field),
            title: Text(field.label),
            contentPadding: const EdgeInsets.fromLTRB(36, 0, 16, 0),
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: enabled ? (selected) => onChanged(field, selected) : null,
          ),
      ],
    );
  }
}
