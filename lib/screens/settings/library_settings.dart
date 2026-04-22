import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/download_destination.dart';
import 'package:yaabsa/util/setting_key.dart';

class LibrarySettings extends ConsumerStatefulWidget {
  const LibrarySettings({super.key});

  static const String routeName = '/settings/library';

  @override
  ConsumerState<LibrarySettings> createState() => _LibrarySettingsState();
}

class _LibrarySettingsState extends ConsumerState<LibrarySettings> {
  bool _isPicking = false;
  bool _isUpdatingCollapseSeries = false;
  late final Future<String> _defaultLocationFuture;

  @override
  void initState() {
    super.initState();
    _defaultLocationFuture = defaultDownloadLocationDescription();
  }

  Future<void> _pickLocation(String userId) async {
    if (!supportsCustomDownloadLocation || _isPicking) {
      return;
    }

    setState(() => _isPicking = true);

    try {
      String? nextValue;

      if (Platform.isAndroid) {
        final pickedUri = await FileDownloader().uri.pickDirectory(
          startLocation: SharedStorage.downloads,
          persistedUriPermission: true,
        );
        if (pickedUri == null) {
          return;
        }
        nextValue = pickedUri.toString();
      } else if (Platform.isLinux || Platform.isWindows) {
        final directoryPath = await FilePicker.getDirectoryPath(dialogTitle: 'Choose download folder');
        if (directoryPath == null || directoryPath.trim().isEmpty) {
          return;
        }
        nextValue = encodeDesktopDownloadLocation(directoryPath);
      }

      if (nextValue == null) {
        return;
      }

      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(userId, SettingKeys.downloadPath, nextValue);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download location updated.')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update location: $e')));
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _resetToDefaultLocation(String userId) async {
    if (_isPicking) {
      return;
    }

    setState(() => _isPicking = true);

    try {
      await ref.read(settingsManagerProvider.notifier).setUserSetting<String>(userId, SettingKeys.downloadPath, '');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Using default download location.')));
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update location: $e')));
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _handleLocationAction(String userId, {required bool hasCustomLocation}) async {
    if (!supportsCustomDownloadLocation || _isPicking) {
      return;
    }

    if (!hasCustomLocation) {
      await _pickLocation(userId);
      return;
    }

    final selectedAction = await showModalBottomSheet<_LocationAction>(
      context: context,
      builder: (context) {
        return SafeArea(
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
        );
      },
    );

    if (selectedAction == _LocationAction.choose) {
      await _pickLocation(userId);
      return;
    }

    if (selectedAction == _LocationAction.useDefault) {
      await _resetToDefaultLocation(userId);
    }
  }

  Future<void> _setCollapseSeriesEnabled(String userId, bool enabled) async {
    if (_isUpdatingCollapseSeries) {
      return;
    }

    setState(() => _isUpdatingCollapseSeries = true);

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<bool>(userId, SettingKeys.collapseSeries, enabled);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update collapse series setting: $e')));
    } finally {
      if (mounted) {
        setState(() => _isUpdatingCollapseSeries = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Library Settings',
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('No active user. Sign in to configure download settings.'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(user.id, SettingKeys.downloadPath),
                  builder: (context, snapshot) {
                    final fallbackValue = ref
                        .read(settingsManagerProvider.notifier)
                        .getUserSetting<String>(user.id, SettingKeys.downloadPath, defaultValue: '');

                    final currentRawValue = snapshot.data?.value ?? fallbackValue;
                    final hasCustomLocation = parseDownloadLocationSetting(currentRawValue) != null;
                    final currentDisplayValue = formatDownloadLocationForDisplay(currentRawValue);

                    return FutureBuilder<String>(
                      future: _defaultLocationFuture,
                      builder: (context, defaultLocationSnapshot) {
                        final defaultLocation = defaultLocationSnapshot.data ?? 'Loading default location...';
                        final currentLocationDisplay = hasCustomLocation ? currentDisplayValue : defaultLocation;

                        return SettingButton(
                          label: 'Download Location',
                          description: currentLocationDisplay,
                          buttonText: hasCustomLocation ? 'Change' : 'Choose',
                          buttonIcon: Icons.folder_open,
                          onPressed: supportsCustomDownloadLocation
                              ? () => _handleLocationAction(user.id, hasCustomLocation: hasCustomLocation)
                              : null,
                          isLoading: _isPicking,
                        );
                      },
                    );
                  },
                ),
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(user.id, SettingKeys.collapseSeries),
                  builder: (context, snapshot) {
                    final fallbackValue = ref
                        .read(settingsManagerProvider.notifier)
                        .getUserSetting<bool>(user.id, SettingKeys.collapseSeries, defaultValue: false);

                    final isEnabled = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);
                    final theme = Theme.of(context);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  'Collapse Series',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: _isUpdatingCollapseSeries ? theme.disabledColor : null,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Switch(
                                value: isEnabled,
                                onChanged: _isUpdatingCollapseSeries
                                    ? null
                                    : (value) => _setCollapseSeriesEnabled(user.id, value),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load user settings: $error')),
        ),
      ],
    );
  }
}

enum _LocationAction { choose, useDefault }
