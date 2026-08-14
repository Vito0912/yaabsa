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

class LibraryViewSubtitleSettings extends ConsumerWidget {
  const LibraryViewSubtitleSettings({super.key});

  static const String routeName = '/settings/library/view-subtitles';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'View Subtitles',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('No active user. Sign in to configure view subtitles.'),
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
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load view subtitle settings: $error')),
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

  String get _subtitleSettingLabel => switch (widget.view) {
    LibraryViewSubtitleView.library => 'Choose which information is displayed under items',
    LibraryViewSubtitleView.series => 'Choose which information is displayed under series',
    LibraryViewSubtitleView.authors => 'Choose which information is displayed under authors',
  };

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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update ${widget.view.label}: $error')));
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
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('You can only select up to 3 fields for custom subtitles')));
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
                      label: _subtitleSettingLabel,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fields',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: enabled ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.38),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose up to three fields to show below the item, series or author',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                ),
              ),
            ],
          ),
        ),
        for (final field in fields)
          CheckboxListTile(
            value: selectedFields.contains(field),
            title: Text(field.label),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            controlAffinity: ListTileControlAffinity.trailing,
            onChanged: enabled ? (selected) => onChanged(field, selected) : null,
          ),
      ],
    );
  }
}
