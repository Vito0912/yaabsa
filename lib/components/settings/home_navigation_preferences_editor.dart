import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_editor_header.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';

class HomeNavigationPreferencesEditor extends ConsumerStatefulWidget {
  const HomeNavigationPreferencesEditor({super.key, required this.userId, required this.mediaType});

  final String userId;
  final HomeLibraryMediaType mediaType;

  @override
  ConsumerState<HomeNavigationPreferencesEditor> createState() => _HomeNavigationPreferencesEditorState();
}

class _HomeNavigationPreferencesEditorState extends ConsumerState<HomeNavigationPreferencesEditor> {
  bool _isSaving = false;

  String get _settingKey => HomeNavigationPreferencesCodec.settingKeyFor(widget.mediaType);

  String get _title => '${widget.mediaType.label} libraries';

  Future<void> _persistPreferences(HomeNavigationPreferences preferences, {String? successMessage}) async {
    if (_isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(widget.userId, _settingKey, HomeNavigationPreferencesCodec.encode(preferences));

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
    HomeNavigationPreferences preferences,
    HomePrimaryView view,
    bool isVisible,
  ) async {
    final currentlyVisible = preferences.visibleViews;
    final isCurrentlyVisible = !preferences.hiddenViews.contains(view);
    if (!isVisible && isCurrentlyVisible && currentlyVisible.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('At least one view must stay enabled.')));
      return;
    }

    final nextPreferences = preferences.withVisibility(view, isVisible);
    await _persistPreferences(nextPreferences);
  }

  Future<void> _handleDefaultViewChange(HomeNavigationPreferences preferences, HomePrimaryView view) async {
    if (preferences.hiddenViews.contains(view) || preferences.defaultView == view) {
      return;
    }

    final nextPreferences = preferences.withDefault(view);
    await _persistPreferences(nextPreferences);
  }

  Future<void> _handleReorder(HomeNavigationPreferences preferences, int oldIndex, int newIndex) async {
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
    final defaults = HomeNavigationPreferencesCodec.defaultsFor(widget.mediaType);
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
          defaultValue: HomeNavigationPreferencesCodec.defaultEncodedFor(widget.mediaType),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsEditorHeader(title: _title, topPadding: 20, onReset: _isSaving ? null : _resetToDefaults),
        StreamBuilder<UserSettingEntry?>(
          stream: appDatabase.watchUserSetting(widget.userId, _settingKey),
          builder: (context, snapshot) {
            final rawValue = snapshot.data?.value ?? fallbackRawValue;
            final preferences = HomeNavigationPreferencesCodec.decode(rawValue, widget.mediaType);
            final total = preferences.orderedViews.length;

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
                  final view = preferences.orderedViews[index];
                  final isVisible = !preferences.hiddenViews.contains(view);
                  final isDefault = preferences.defaultView == view;

                  return Padding(
                    key: ValueKey(view.storageKey),
                    padding: EdgeInsets.only(bottom: index == total - 1 ? 0 : 2),
                    child: ClipRRect(
                      borderRadius: _getBorderRadius(index, total),
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        child: _HomeNavigationPreferenceRow(
                          view: view,
                          isVisible: isVisible,
                          isDefault: isDefault,
                          isSaving: _isSaving,
                          onVisibilityChanged: (nextValue) => _handleVisibilityToggle(preferences, view, nextValue),
                          onSetDefault: () => _handleDefaultViewChange(preferences, view),
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

class _HomeNavigationPreferenceRow extends StatelessWidget {
  const _HomeNavigationPreferenceRow({
    required this.view,
    required this.isVisible,
    required this.isDefault,
    required this.isSaving,
    required this.onVisibilityChanged,
    required this.onSetDefault,
    required this.reorderIndex,
  });

  final HomePrimaryView view;
  final bool isVisible;
  final bool isDefault;
  final bool isSaving;
  final ValueChanged<bool> onVisibilityChanged;
  final VoidCallback onSetDefault;
  final int reorderIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(view.icon, size: 22, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              view.label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, color: colorScheme.onSurface),
            ),
          ),
          IconButton(
            tooltip: isVisible
                ? (isDefault ? 'Default view' : 'Set as default view')
                : 'Enable this view to set it as default',
            onPressed: !isSaving && isVisible && !isDefault ? onSetDefault : null,
            icon: Icon(
              isDefault ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isDefault ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
