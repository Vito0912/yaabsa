import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_editor_header.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';
import 'package:yaabsa/util/personalized_shelf_preferences.dart';

class PersonalizedShelfSectionsEditor extends ConsumerStatefulWidget {
  const PersonalizedShelfSectionsEditor({super.key, required this.userId, required this.mediaType});

  final String userId;
  final HomeLibraryMediaType mediaType;

  @override
  ConsumerState<PersonalizedShelfSectionsEditor> createState() => _PersonalizedShelfSectionsEditorState();
}

class _PersonalizedShelfSectionsEditorState extends ConsumerState<PersonalizedShelfSectionsEditor> {
  bool _isSaving = false;

  String get _settingKey => PersonalizedShelfPreferencesCodec.settingKeyFor(widget.mediaType);

  String get _title => '${widget.mediaType.label} libraries';

  Future<void> _persistPreferences(PersonalizedShelfPreferences preferences, {String? successMessage}) async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(widget.userId, _settingKey, PersonalizedShelfPreferencesCodec.encode(preferences));

      if (!mounted || successMessage == null || successMessage.isEmpty) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update $_title: $error')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleVisibilityToggle(
    PersonalizedShelfPreferences preferences,
    String sectionId,
    bool isVisible,
  ) async {
    final nextPreferences = preferences.withVisibility(sectionId, isVisible);
    await _persistPreferences(nextPreferences);
  }

  Future<void> _handleReorder(PersonalizedShelfPreferences preferences, int oldIndex, int newIndex) async {
    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }

    if (targetIndex == oldIndex) {
      return;
    }

    final nextPreferences = preferences.reordered(oldIndex, targetIndex);
    await _persistPreferences(nextPreferences);
  }

  Future<void> _resetToDefaults() async {
    final defaults = PersonalizedShelfPreferencesCodec.defaultsFor(widget.mediaType);
    await _persistPreferences(defaults, successMessage: 'Reset $_title to defaults.');
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);
    final fallbackRawValue = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(
          widget.userId,
          _settingKey,
          defaultValue: PersonalizedShelfPreferencesCodec.defaultEncodedFor(widget.mediaType),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsEditorHeader(title: _title, topPadding: 20, onReset: _isSaving ? null : _resetToDefaults),
        StreamBuilder<UserSettingEntry?>(
          stream: appDatabase.watchUserSetting(widget.userId, _settingKey),
          builder: (context, snapshot) {
            final rawValue = snapshot.data?.value ?? fallbackRawValue;
            final preferences = PersonalizedShelfPreferencesCodec.decode(rawValue, widget.mediaType);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorderItem: _isSaving
                      ? (_, _) {}
                      : (oldIndex, newIndex) => _handleReorder(preferences, oldIndex, newIndex),
                  itemCount: preferences.orderedSectionIds.length,
                  itemBuilder: (context, index) {
                    final sectionId = preferences.orderedSectionIds[index];
                    final section = PersonalizedShelfSection.fromId(sectionId);
                    final isVisible = !preferences.hiddenSectionIds.contains(sectionId);

                    return _PersonalizedShelfSectionRow(
                      key: ValueKey('${widget.mediaType.name}:$sectionId'),
                      sectionLabel: section?.label ?? sectionId,
                      sectionIcon: section?.icon ?? Icons.view_carousel_outlined,
                      isVisible: isVisible,
                      isSaving: _isSaving,
                      showDivider: index < preferences.orderedSectionIds.length - 1,
                      onVisibilityChanged: (nextValue) => _handleVisibilityToggle(preferences, sectionId, nextValue),
                      reorderIndex: index,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PersonalizedShelfSectionRow extends StatelessWidget {
  const _PersonalizedShelfSectionRow({
    super.key,
    required this.sectionLabel,
    required this.sectionIcon,
    required this.isVisible,
    required this.isSaving,
    required this.showDivider,
    required this.onVisibilityChanged,
    required this.reorderIndex,
  });

  final String sectionLabel;
  final IconData sectionIcon;
  final bool isVisible;
  final bool isSaving;
  final bool showDivider;
  final ValueChanged<bool> onVisibilityChanged;
  final int reorderIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2), width: 1))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(sectionIcon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(sectionLabel, style: Theme.of(context).textTheme.titleSmall)),
            Switch.adaptive(value: isVisible, onChanged: isSaving ? null : onVisibilityChanged),
            ReorderableDragStartListener(
              index: reorderIndex,
              child: Icon(Icons.drag_handle_rounded, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
