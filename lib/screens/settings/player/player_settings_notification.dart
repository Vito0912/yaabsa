import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettingsNotification extends ConsumerStatefulWidget {
  const PlayerSettingsNotification({super.key});

  static const String routeName = '/settings/player/notification';

  @override
  ConsumerState<PlayerSettingsNotification> createState() => _PlayerSettingsNotificationState();
}

class _PlayerSettingsNotificationState extends ConsumerState<PlayerSettingsNotification> {
  int _selectedPageIndex = 0;
  List<List<String>> _pages = [];
  bool _isInitialized = false;

  final Map<String, _ActionTypeInfo> _actionInfos = {
    'rewind': const _ActionTypeInfo(
      label: 'Rewind',
      icon: Icons.replay_rounded,
      description: 'Go back by your configured rewind interval',
    ),
    'fastForward': const _ActionTypeInfo(
      label: 'Fast Forward',
      // TODO: There seems to be no forward_media that would be available as media
      icon: Icons.forward_10_rounded,
      description: 'Go forward by your configured forward interval',
    ),
    'speed': const _ActionTypeInfo(
      label: 'Playback Speed',
      icon: Icons.speed_rounded,
      description: 'Cycle through playback speeds',
    ),
    'stop': const _ActionTypeInfo(
      label: 'Stop',
      icon: Icons.stop_rounded,
      description: 'Stop playback and close notification',
    ),
    'skipToNext': const _ActionTypeInfo(
      label: 'Next Chapter',
      icon: Icons.skip_next_rounded,
      description: 'Skip to the next chapter',
    ),
    'skipToPrevious': const _ActionTypeInfo(
      label: 'Previous Chapter',
      icon: Icons.skip_previous_rounded,
      description: 'Go back to the previous chapter',
    ),
    'switchPage': const _ActionTypeInfo(
      label: 'Switch Page',
      icon: Icons.more_vert_rounded,
      description: 'Switch to the next page of notification controls',
    ),
  };

  void _loadSettings() {
    if (_isInitialized) return;

    final manager = ref.read(settingsManagerProvider.notifier);
    final settingVal = manager.getGlobalSetting<String>(SettingKeys.mediaNotificationPages);

    try {
      final List<dynamic> outer = json.decode(settingVal);
      final List<List<String>> parsed = [];
      for (final page in outer) {
        if (page is List) {
          final list = page.map((e) => e.toString()).toList();
          while (list.length < 4) {
            list.add('');
          }
          parsed.add(list.take(4).toList());
        }
      }
      if (parsed.isNotEmpty) {
        _pages = parsed;
      } else {
        _pages = [
          ['rewind', 'fastForward', 'speed', 'stop'],
        ];
      }
    } catch (e) {
      _pages = [
        ['rewind', 'fastForward', 'speed', 'stop'],
      ];
    }

    if (_selectedPageIndex >= _pages.length) {
      _selectedPageIndex = 0;
    }
    _isInitialized = true;
  }

  Future<void> _saveSettings() async {
    final manager = ref.read(settingsManagerProvider.notifier);
    final encoded = json.encode(_pages);
    await manager.setGlobalSetting<String>(SettingKeys.mediaNotificationPages, encoded);
  }

  void _addPage() {
    if (_pages.length >= 4) return;

    setState(() {
      if (_pages.length == 1) {
        final firstPage = List<String>.from(_pages[0]);
        if (!firstPage.contains('switchPage')) {
          firstPage[3] = 'switchPage';
          _pages[0] = firstPage;
        }
      }

      _pages.add(['skipToPrevious', 'skipToNext', 'stop', 'switchPage']);
      _selectedPageIndex = _pages.length - 1;
      _saveSettings();
    });
  }

  void _deletePage(int index) {
    if (_pages.length <= 1) return;

    setState(() {
      _pages.removeAt(index);
      if (_selectedPageIndex >= _pages.length) {
        _selectedPageIndex = _pages.length - 1;
      }
      if (_pages.length == 1) {
        final singlePage = List<String>.from(_pages[0]);
        for (int i = 0; i < singlePage.length; i++) {
          if (singlePage[i] == 'switchPage') {
            singlePage[i] = '';
          }
        }
        _pages[0] = singlePage;
      }
      _saveSettings();
    });
  }

  void _updateSlot(int slotIndex, String action) {
    setState(() {
      final page = List<String>.from(_pages[_selectedPageIndex]);
      while (page.length < 4) {
        page.add('');
      }

      if (action == 'switchPage') {
        for (int i = 0; i < 4; i++) {
          if (i != slotIndex && page[i] == 'switchPage') {
            page[i] = '';
          }
        }
      }

      page[slotIndex] = action;
      _pages[_selectedPageIndex] = page;
      _saveSettings();
    });
  }

  void _showActionPicker(int slotIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Text(
                  'Select Action for Slot ${slotIndex + 1}',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.remove_circle_outline_rounded, color: colorScheme.error),
                      title: Text('Clear Slot', style: TextStyle(color: colorScheme.error)),
                      subtitle: const Text('Leave this button position empty'),
                      onTap: () {
                        _updateSlot(slotIndex, '');
                        Navigator.of(context).pop();
                      },
                    ),
                    ..._actionInfos.entries.map((entry) {
                      final key = entry.key;
                      final info = entry.value;

                      if (key == 'switchPage' && _pages.length <= 1) {
                        return const SizedBox.shrink();
                      }

                      return ListTile(
                        leading: Icon(info.icon, color: colorScheme.primary),
                        title: Text(info.label),
                        subtitle: Text(info.description),
                        onTap: () {
                          _updateSlot(slotIndex, key);
                          Navigator.of(context).pop();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreviewButton(List<String> actions, int index, ColorScheme colorScheme) {
    final action = index < actions.length ? actions[index] : '';
    final info = _actionInfos[action];

    final Widget buttonChild;
    if (action.isEmpty || info == null) {
      buttonChild = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add_rounded, size: 14, color: colorScheme.outline),
      );
    } else {
      buttonChild = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          shape: BoxShape.circle,
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Icon(info.icon, color: colorScheme.onSurface, size: 18),
      );
    }

    return InkWell(onTap: () => _showActionPicker(index), borderRadius: BorderRadius.circular(18), child: buttonChild);
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currentPageActions = _selectedPageIndex < _pages.length ? _pages[_selectedPageIndex] : <String>[];
    final hasMultiplePages = _pages.length > 1;
    final isPageMissingSwitch = hasMultiplePages && !currentPageActions.contains('switchPage');

    return SettingsPageScaffold(
      title: 'Media Notification Layout',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book Title',
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Author Name',
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.pause_rounded, color: colorScheme.onPrimaryContainer, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildPreviewButton(currentPageActions, 0, colorScheme),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Positioned(
                              left: 56,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildPreviewButton(currentPageActions, 1, colorScheme),
                    const SizedBox(width: 8),
                    _buildPreviewButton(currentPageActions, 2, colorScheme),
                    const SizedBox(width: 8),
                    _buildPreviewButton(currentPageActions, 3, colorScheme),
                  ],
                ),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'This layout might look different on different versions of Android and devices.',
                  style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),

        if (isPageMissingSwitch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: colorScheme.errorContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colorScheme.error),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colorScheme.onErrorContainer, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Missing Switch Page Action',
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Since you have multiple pages, this page needs a "Switch Page" button so you can cycle through them.',
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.onErrorContainer),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Text('Notification Pages', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              if (_pages.length > 1)
                IconButton(
                  tooltip: 'Delete Current Page',
                  icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
                  onPressed: () => _deletePage(_selectedPageIndex),
                ),
              if (_pages.length < 4)
                TextButton.icon(
                  onPressed: _addPage,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Page'),
                ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 8,
            children: List.generate(_pages.length, (index) {
              final isSelected = index == _selectedPageIndex;
              return ChoiceChip(
                label: Text('Page ${index + 1}'),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedPageIndex = index;
                    });
                  }
                },
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        SettingsNavigationSection(
          title: 'Arrange Buttons (Page ${_selectedPageIndex + 1})',
          settings: List.generate(4, (index) {
            final action = index < currentPageActions.length ? currentPageActions[index] : '';
            final info = _actionInfos[action];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.surfaceContainer,
                child: Icon(
                  info?.icon ?? Icons.add_rounded,
                  color: action.isNotEmpty ? colorScheme.primary : colorScheme.outline,
                ),
              ),
              title: Text('Slot ${index + 1}'),
              subtitle: Text(info?.label ?? 'Empty - Tap to assign action'),
              trailing: Icon(Icons.edit_outlined, size: 20, color: colorScheme.onSurfaceVariant),
              onTap: () => _showActionPicker(index),
            );
          }),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _pages = [
                  ['rewind', 'fastForward', 'speed', 'stop'],
                ];
                _selectedPageIndex = 0;
                _saveSettings();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset to Default'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTypeInfo {
  final String label;
  final IconData icon;
  final String description;

  const _ActionTypeInfo({required this.label, required this.icon, required this.description});
}
