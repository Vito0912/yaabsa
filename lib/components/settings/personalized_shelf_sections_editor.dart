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

  BorderRadius _getBorderRadius(int index, int total) {
    if (total == 1) {
      return BorderRadius.circular(24);
    }
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(4),
      );
    }
    if (index == total - 1) {
      return const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      );
    }
    return BorderRadius.circular(4);
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
            final total = preferences.orderedSectionIds.length;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                buildDefaultDragHandles: false,
                physics: const NeverScrollableScrollPhysics(),
                onReorderItem: _isSaving
                    ? (_, _) {}
                    : (oldIndex, newIndex) => _handleReorder(preferences, oldIndex, newIndex),
                itemCount: total,
                itemBuilder: (context, index) {
                  final sectionId = preferences.orderedSectionIds[index];
                  final section = PersonalizedShelfSection.fromId(sectionId);
                  final isVisible = !preferences.hiddenSectionIds.contains(sectionId);

                  return Padding(
                    key: ValueKey('${widget.mediaType.name}:$sectionId'),
                    padding: EdgeInsets.only(bottom: index == total - 1 ? 0 : 2),
                    child: ClipRRect(
                      borderRadius: _getBorderRadius(index, total),
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        child: _PersonalizedShelfSectionRow(
                          sectionLabel: section?.label ?? sectionId,
                          sectionIcon: section?.icon ?? Icons.view_carousel_outlined,
                          isVisible: isVisible,
                          isSaving: _isSaving,
                          onVisibilityChanged: (nextValue) =>
                              _handleVisibilityToggle(preferences, sectionId, nextValue),
                          reorderIndex: index,
                        ),
                      ),
                    ),
                  );
                },
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
    required this.sectionLabel,
    required this.sectionIcon,
    required this.isVisible,
    required this.isSaving,
    required this.onVisibilityChanged,
    required this.reorderIndex,
  });

  final String sectionLabel;
  final IconData sectionIcon;
  final bool isVisible;
  final bool isSaving;
  final ValueChanged<bool> onVisibilityChanged;
  final int reorderIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(sectionIcon, size: 22, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              sectionLabel,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
            ),
          ),
          Switch.adaptive(value: isVisible, onChanged: isSaving ? null : onVisibilityChanged),
          const SizedBox(width: 16),
          ReorderableDragStartListener(
            index: reorderIndex,
            child: Icon(Icons.drag_handle_rounded, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
