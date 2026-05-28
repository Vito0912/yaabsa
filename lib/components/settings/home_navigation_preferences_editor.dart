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
                  itemCount: preferences.orderedViews.length,
                  itemBuilder: (context, index) {
                    final view = preferences.orderedViews[index];
                    final isVisible = !preferences.hiddenViews.contains(view);
                    final isDefault = preferences.defaultView == view;

                    return _HomeNavigationPreferenceRow(
                      key: ValueKey(view.storageKey),
                      view: view,
                      isVisible: isVisible,
                      isDefault: isDefault,
                      isSaving: _isSaving,
                      showDivider: index < preferences.orderedViews.length - 1,
                      onVisibilityChanged: (nextValue) => _handleVisibilityToggle(preferences, view, nextValue),
                      onSetDefault: () => _handleDefaultViewChange(preferences, view),
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

class _HomeNavigationPreferenceRow extends StatelessWidget {
  const _HomeNavigationPreferenceRow({
    super.key,
    required this.view,
    required this.isVisible,
    required this.isDefault,
    required this.isSaving,
    required this.showDivider,
    required this.onVisibilityChanged,
    required this.onSetDefault,
    required this.reorderIndex,
  });

  final HomePrimaryView view;
  final bool isVisible;
  final bool isDefault;
  final bool isSaving;
  final bool showDivider;
  final ValueChanged<bool> onVisibilityChanged;
  final VoidCallback onSetDefault;
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
            Icon(view.icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(view.label, style: Theme.of(context).textTheme.titleSmall)),
            IconButton(
              tooltip: isVisible
                  ? (isDefault ? 'Default view' : 'Set as default view')
                  : 'Enable this view to set it as default',
              onPressed: !isSaving && isVisible && !isDefault ? onSetDefault : null,
              icon: Icon(
                isDefault ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
                color: isDefault ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
            ),
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
