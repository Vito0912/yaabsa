import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/download_destination.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;
import 'package:yaabsa/util/setting_key.dart';

class DownloadSettings extends ConsumerStatefulWidget {
  const DownloadSettings({super.key});

  static const String routeName = '/settings/downloads';

  @override
  ConsumerState<DownloadSettings> createState() => _DownloadSettingsState();
}

class _DownloadSettingsState extends ConsumerState<DownloadSettings> {
  bool _isPicking = false;
  bool _isCleaning = false;
  late final Future<String> _defaultLocationFuture;

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _defaultLocationFuture = defaultDownloadLocationDescription();
  }

  Future<void> _pickLocation(String userId) async {
    if (!supportsCustomDownloadLocation || _isPicking) return;
    setState(() => _isPicking = true);
    try {
      String? nextValue;
      if (!kIsWeb && Platform.isAndroid) {
        final pickedUri = await FileDownloader().uri.pickDirectory(
          startLocation: SharedStorage.downloads,
          persistedUriPermission: true,
        );
        nextValue = pickedUri?.toString();
      } else if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
        final directoryPath = await FilePicker.getDirectoryPath(dialogTitle: 'Choose download folder');
        if (directoryPath != null && directoryPath.trim().isNotEmpty) {
          nextValue = encodeDesktopDownloadLocation(directoryPath);
        }
      }
      if (nextValue == null) return;
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(userId, SettingKeys.downloadPath, nextValue);
      _showMessage('Download location updated');
    } catch (e) {
      _showMessage('Failed to update location: $e');
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _resetToDefaultLocation(String userId) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);
    try {
      await ref.read(settingsManagerProvider.notifier).setUserSetting<String>(userId, SettingKeys.downloadPath, '');
      _showMessage('Using default download location');
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _handleLocationAction(String userId, {required bool hasCustomLocation}) async {
    if (!supportsCustomDownloadLocation || _isPicking) return;
    if (!hasCustomLocation) {
      await _pickLocation(userId);
      return;
    }
    final selectedAction = await showModalBottomSheet<_LocationAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Choose folder'),
              onTap: () => Navigator.of(context).pop(_LocationAction.choose),
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt_rounded),
              title: const Text('Use default location'),
              onTap: () => Navigator.of(context).pop(_LocationAction.useDefault),
            ),
          ],
        ),
      ),
    );
    if (selectedAction == _LocationAction.choose) await _pickLocation(userId);
    if (selectedAction == _LocationAction.useDefault) await _resetToDefaultLocation(userId);
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);
    return SettingsPageScaffold(
      title: 'Downloads',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        ref
            .watch(currentUserProvider)
            .when(
              data: (user) {
                if (user == null) {
                  return const Padding(padding: EdgeInsets.all(20), child: Text('Sign in to configure downloads'));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SettingsNavigationSection(
                      title: 'Download behavior',
                      topPadding: 8,
                      items: [
                        SettingsNavigationItem(
                          icon: Icons.download_for_offline_rounded,
                          title: 'Smart Downloads',
                          subtitle: 'Automatically download and remove items based on rules',
                          onTap: () => context.push('/settings/library/smart-downloads'),
                        ),
                      ],
                      settings: [
                        StreamBuilder<UserSettingEntry?>(
                          stream: db.watchUserSetting(user.id, SettingKeys.downloadPath),
                          builder: (context, snapshot) {
                            final fallback = ref
                                .read(settingsManagerProvider.notifier)
                                .getUserSetting<String>(user.id, SettingKeys.downloadPath, defaultValue: '');
                            final raw = snapshot.data?.value ?? fallback;
                            final custom = parseDownloadLocationSetting(raw) != null;
                            return FutureBuilder<String>(
                              future: _defaultLocationFuture,
                              builder: (context, locationSnapshot) => SettingButton(
                                label: 'Download Location',
                                description: custom
                                    ? formatDownloadLocationForDisplay(raw)
                                    : (locationSnapshot.data ?? 'Loading default location...'),
                                buttonText: custom ? 'Change' : 'Choose',
                                buttonIcon: Icons.folder_open,
                                onPressed: supportsCustomDownloadLocation
                                    ? () => _handleLocationAction(user.id, hasCustomLocation: custom)
                                    : null,
                                isLoading: _isPicking,
                              ),
                            );
                          },
                        ),
                        StreamBuilder<UserSettingEntry?>(
                          stream: db.watchUserSetting(user.id, SettingKeys.downloadTypePreference),
                          builder: (context, snapshot) {
                            final fallback = ref
                                .read(settingsManagerProvider.notifier)
                                .getUserSetting<String>(
                                  user.id,
                                  SettingKeys.downloadTypePreference,
                                  defaultValue: 'askEveryTime',
                                );
                            final value = SettingsParser.decodeValue<String>(snapshot.data?.value, fallback);
                            return SettingDropdown<String>.remote(
                              label: 'Download Preference',
                              description: 'What files to download by default',
                              value: value,
                              values: const ['askEveryTime', 'audiobook', 'ebook', 'both'],
                              valueLabels: const ['Ask every time', 'Audiobook only', 'Ebook only', 'Both'],
                              onValueChanged: (newValue) => ref
                                  .read(settingsManagerProvider.notifier)
                                  .setUserSetting<String>(user.id, SettingKeys.downloadTypePreference, newValue),
                            );
                          },
                        ),
                        SettingSwitchTile(
                          label: 'Download only on Wi-Fi',
                          settingKey: SettingKeys.downloadOnlyOnWifi,
                          userId: user.id,
                          subtitle:
                              'Wait for a Wi-Fi connection before starting any download, including Smart Downloads.',
                          onChanged: (_) => unawaited(downloadHandler.applyDownloadSettings()),
                        ),
                        SettingSlider<int>(
                          label: 'Maximum parallel downloads',
                          description: 'Limit the number of files downloading at the same time across all items.',
                          values: const <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                          valueLabels: const <String>[
                            '1 file',
                            '2 files',
                            '3 files',
                            '4 files',
                            '5 files',
                            '6 files',
                            '7 files',
                            '8 files',
                            '9 files',
                            '10 files',
                          ],
                          settingKey: SettingKeys.downloadMaxParallel,
                          userId: user.id,
                          onChanged: (_) => unawaited(downloadHandler.applyDownloadSettings()),
                        ),
                        SettingSwitchTile(
                          label: 'Download Continue Listening and Continue Series',
                          settingKey: SettingKeys.downloadContinueListeningAndSeries,
                          userId: user.id,
                          subtitle: 'Automatically download all items shown in Continue Listening and Continue Series.',
                          onChanged: (enabled) {
                            final manager = ref.read(smartDownloadManagerProvider.notifier);
                            if (!enabled) {
                              unawaited(manager.deleteContinueShelfDownloads(userId: user.id));
                            }
                            manager.requestReconcile(reason: 'continue shelf setting changed');
                          },
                        ),
                        SettingButton(
                          label: 'Delete listened items now',
                          description: 'Remove finished smart downloads',
                          buttonText: 'Delete',
                          buttonIcon: Icons.delete_sweep_outlined,
                          isDestructive: true,
                          isLoading: _isCleaning,
                          onPressed: _isCleaning
                              ? null
                              : () async {
                                  setState(() => _isCleaning = true);
                                  try {
                                    final deleted = await ref
                                        .read(smartDownloadManagerProvider.notifier)
                                        .deleteListenedManagedDownloads(userId: user.id);
                                    _showMessage(
                                      deleted == 0
                                          ? 'No listened smart downloads were ready to delete.'
                                          : 'Deleted $deleted listened smart download${deleted == 1 ? '' : 's'}',
                                    );
                                  } catch (error) {
                                    _showMessage('Failed to delete listened smart downloads: $error');
                                  } finally {
                                    if (mounted) setState(() => _isCleaning = false);
                                  }
                                },
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) =>
                  Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load download settings: $error')),
            ),
      ],
    );
  }
}

enum _LocationAction { choose, useDefault }
